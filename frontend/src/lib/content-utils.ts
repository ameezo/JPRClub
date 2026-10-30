export interface VideoEmbedInfo {
  provider: 'youtube' | 'vimeo';
  id: string;
  embedUrl: string;
}

/**
 * Checks if a string is serialized BlockNote JSON content.
 */
export function isBlockNoteContent(content: string | null | undefined): boolean {
  if (!content || typeof content !== 'string') return false;
  const trimmed = content.trim();
  if (!trimmed.startsWith('[') || !trimmed.endsWith(']')) return false;
  try {
    const parsed = JSON.parse(trimmed);
    if (!Array.isArray(parsed)) return false;
    if (parsed.length === 0) return true;
    // Check if first element resembles a BlockNote block (has type and id or props)
    const first = parsed[0];
    return typeof first === 'object' && first !== null && ('type' in first || 'id' in first);
  } catch {
    return false;
  }
}

/**
 * Safely parses BlockNote JSON string into blocks array, or returns null.
 */
export function safeParseBlocks(content: string | null | undefined): any[] | null {
  if (!isBlockNoteContent(content)) return null;
  try {
    return JSON.parse(content!.trim());
  } catch {
    return null;
  }
}

/**
 * Validates and extracts embed information for approved video providers (YouTube and Vimeo).
 */
export function parseVideoEmbedUrl(url: string): VideoEmbedInfo | null {
  if (!url || typeof url !== 'string') return null;
  const trimmed = url.trim();

  // YouTube matchers
  // https://www.youtube.com/watch?v=VIDEO_ID
  // https://youtu.be/VIDEO_ID
  // https://www.youtube.com/embed/VIDEO_ID
  // https://www.youtube.com/shorts/VIDEO_ID
  const ytMatch = trimmed.match(
    /(?:https?:\/\/)?(?:www\.|m\.)?(?:youtube\.com\/(?:watch\?v=|embed\/|shorts\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})/i
  );
  if (ytMatch && ytMatch[1]) {
    return {
      provider: 'youtube',
      id: ytMatch[1],
      embedUrl: `https://www.youtube-nocookie.com/embed/${ytMatch[1]}`,
    };
  }

  // Vimeo matchers
  // https://vimeo.com/123456789
  // https://player.vimeo.com/video/123456789
  const vimeoMatch = trimmed.match(
    /(?:https?:\/\/)?(?:www\.|player\.)?vimeo\.com\/(?:video\/)?([0-9]{6,12})/i
  );
  if (vimeoMatch && vimeoMatch[1]) {
    return {
      provider: 'vimeo',
      id: vimeoMatch[1],
      embedUrl: `https://player.vimeo.com/video/${vimeoMatch[1]}`,
    };
  }

  return null;
}

/**
 * Checks if a URL is an allowed video embed.
 */
export function isAllowedVideoUrl(url: string): boolean {
  return parseVideoEmbedUrl(url) !== null;
}

/**
 * Extracts a clean plain-text snippet from either BlockNote JSON or Markdown.
 */
export function extractTextSnippet(content: string | null | undefined, maxLength: number = 180): string {
  if (!content || typeof content !== 'string') return '';
  const trimmed = content.trim();

  if (isBlockNoteContent(trimmed)) {
    try {
      const blocks = JSON.parse(trimmed);
      const textParts: string[] = [];
      
      const walkBlocks = (arr: any[]) => {
        for (const block of arr) {
          if (Array.isArray(block.content)) {
            for (const item of block.content) {
              if (item?.type === 'text' && item.text) {
                textParts.push(item.text);
              }
            }
          }
          if (block.props?.caption) {
            textParts.push(block.props.caption);
          }
          if (Array.isArray(block.children)) {
            walkBlocks(block.children);
          }
        }
      };

      walkBlocks(blocks);
      const combined = textParts.join(' ').replace(/\s+/g, ' ').trim();
      return combined.length > maxLength ? `${combined.slice(0, maxLength)}...` : combined;
    } catch {
      return '';
    }
  }

  // Markdown fallback
  const stripped = trimmed
    .replace(/[#*`~_\[\]()]/g, '')
    .replace(/\n+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();

  return stripped.length > maxLength ? `${stripped.slice(0, maxLength)}...` : stripped;
}

export interface SessionPhotoItem {
  url: string;
  sessionId: string;
  sessionTitle: string;
  sessionTitleAr?: string;
  scheduledAt: string;
  materialType?: string;
}

/**
 * Extracts all gallery photo URLs from a session (both session.gallery_images and BlockNote studio_content).
 */
export function extractSessionPhotos(session: any): SessionPhotoItem[] {
  const photos: SessionPhotoItem[] = [];
  const seenUrls = new Set<string>();

  if (!session) return photos;

  // 1. From session.gallery_images
  if (Array.isArray(session.gallery_images)) {
    for (const url of session.gallery_images) {
      if (typeof url === 'string' && url.trim() && !seenUrls.has(url.trim())) {
        seenUrls.add(url.trim());
        photos.push({
          url: url.trim(),
          sessionId: session.id,
          sessionTitle: session.title,
          sessionTitleAr: session.title_ar,
          scheduledAt: session.scheduled_at,
          materialType: session.material_type,
        });
      }
    }
  }

  // 2. From session.studio_content (BlockNote blocks)
  if (session.studio_content && isBlockNoteContent(session.studio_content)) {
    const blocks = safeParseBlocks(session.studio_content);
    if (Array.isArray(blocks)) {
      const walk = (arr: any[]) => {
        for (const block of arr) {
          if (block?.type === 'gallery' && block.props?.images) {
            let list: any[] = [];
            try {
              list = typeof block.props.images === 'string' ? JSON.parse(block.props.images) : block.props.images;
            } catch {}
            if (Array.isArray(list)) {
              for (const item of list) {
                const u = item?.url || (typeof item === 'string' ? item : null);
                if (typeof u === 'string' && u.trim() && !seenUrls.has(u.trim())) {
                  seenUrls.add(u.trim());
                  photos.push({
                    url: u.trim(),
                    sessionId: session.id,
                    sessionTitle: session.title,
                    sessionTitleAr: session.title_ar,
                    scheduledAt: session.scheduled_at,
                    materialType: session.material_type,
                  });
                }
              }
            }
          }
          if (Array.isArray(block?.children)) {
            walk(block.children);
          }
        }
      };
      walk(blocks);
    }
  }

  return photos;
}
