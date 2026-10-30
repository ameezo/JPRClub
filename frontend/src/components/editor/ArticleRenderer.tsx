import { useMemo } from 'react';
import { useCreateBlockNote } from '@blocknote/react';
import { BlockNoteView } from '@blocknote/mantine';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { appEditorSchema } from './editorSchema';
import { isBlockNoteContent, safeParseBlocks } from '../../lib/content-utils';
import '@blocknote/mantine/style.css';
import '@/styles/markdown.css';

interface ArticleRendererProps {
  content?: string | null;
  dir?: 'ltr' | 'rtl' | 'auto';
  className?: string;
  fallbackText?: string;
}

// Subcomponent for BlockNote read-only rendering so useCreateBlockNote can receive initialContent
function BlockNoteReadOnly({ blocks, dir }: { blocks: any[]; dir?: 'ltr' | 'rtl' | 'auto' }) {
  const editor = useCreateBlockNote({
    schema: appEditorSchema,
    initialContent: blocks.length > 0 ? blocks : undefined,
  });

  return (
    <div className="article-blocknote-viewer" dir={dir}>
      <BlockNoteView
        editor={editor}
        editable={false}
        theme="light"
        formattingToolbar={false}
        linkToolbar={false}
        sideMenu={false}
        slashMenu={false}
      />
    </div>
  );
}

export default function ArticleRenderer({
  content,
  dir = 'auto',
  className = '',
  fallbackText,
}: ArticleRendererProps) {
  const isBlock = useMemo(() => isBlockNoteContent(content), [content]);
  const parsedBlocks = useMemo(() => (isBlock ? safeParseBlocks(content) : null), [isBlock, content]);

  if (!content || !content.trim()) {
    if (fallbackText) {
      return (
        <p className="text-gray-400 italic text-center py-8">
          {fallbackText}
        </p>
      );
    }
    return null;
  }

  if (isBlock && parsedBlocks) {
    return (
      <div className={`article-renderer-container ${className}`}>
        <BlockNoteReadOnly blocks={parsedBlocks} dir={dir} />
      </div>
    );
  }

  // Fallback to legacy Markdown rendering
  return (
    <div className={`markdown-content ${className}`} dir={dir}>
      <ReactMarkdown remarkPlugins={[remarkGfm]}>
        {content}
      </ReactMarkdown>
    </div>
  );
}
