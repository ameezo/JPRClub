import React, { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useCreateBlockNote } from '@blocknote/react';
import { BlockNoteView } from '@blocknote/mantine';
import {
  SuggestionMenuController,
  getDefaultReactSlashMenuItems,
} from '@blocknote/react';
import { insertOrUpdateBlockForSlashMenu } from '@blocknote/core';
import {
  ArrowLeft,
  Check,
  Loader2,
  AlertCircle,
  ImageIcon,
  Video,
  Images,
  Trash2,
  Upload,
  Send,
  Save,
  CheckCircle2,
  X,
} from 'lucide-react';
import { appEditorSchema } from './editorSchema';
import {
  isBlockNoteContent,
  safeParseBlocks,
} from '../../lib/content-utils';
import { uploadImage, getMediaUrl } from '../../lib/api';
import '@blocknote/mantine/style.css';
import '../../styles/editor.css';

export interface ArticleComposerData {
  title: string;
  content: string; // JSON string of BlockNote blocks
  coverImageUrl?: string | null;
  contentLanguage: 'en' | 'ar';
}

export interface ArticleComposerProps {
  initialTitle?: string;
  initialContent?: string | null;
  initialCoverImage?: string | null;
  initialLanguage?: 'en' | 'ar';
  
  onSaveDraft: (data: ArticleComposerData) => Promise<void>;
  onManualSaveDraft?: (data: ArticleComposerData) => Promise<void>;
  onPublish?: (data: ArticleComposerData) => Promise<void>;
  onSubmitReview?: (data: ArticleComposerData) => Promise<void>;
  
  mode: 'session' | 'journal';
  statusBadge?: string;
  backUrl: string;
  titlePlaceholder?: string;
  canPublishDirectly?: boolean;
  authorName?: string;
}

type SaveState = 'saved' | 'saving' | 'unsaved' | 'error';

export default function ArticleComposer({
  initialTitle = '',
  initialContent = null,
  initialCoverImage = null,
  initialLanguage = 'en',
  onSaveDraft,
  onManualSaveDraft,
  onPublish,
  onSubmitReview,
  mode,
  statusBadge,
  backUrl,
  titlePlaceholder,
  canPublishDirectly = false,
  authorName,
}: ArticleComposerProps) {
  const navigate = useNavigate();

  // Form State
  const [title, setTitle] = useState(initialTitle);
  const [coverImageUrl, setCoverImageUrl] = useState<string | null>(initialCoverImage);
  const [contentLanguage, setContentLanguage] = useState<'en' | 'ar'>(initialLanguage);
  
  // UI & Save State
  const [saveState, setSaveState] = useState<SaveState>('saved');
  const [lastSavedAt, setLastSavedAt] = useState<Date | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [actionError, setActionError] = useState<string | null>(null);

  // Cover image modal state
  const [showCoverModal, setShowCoverModal] = useState(false);
  const [coverInputUrl, setCoverInputUrl] = useState('');
  const [uploadingCover, setUploadingCover] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Debounce refs
  const autoSaveTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const isDirtyRef = useRef(false);
  const isInitializedRef = useRef(false);

  // Parse initial content for BlockNote
  const isInitialBlockNote = isBlockNoteContent(initialContent);
  const initialBlocks = isInitialBlockNote ? safeParseBlocks(initialContent) : null;

  // Initialize BlockNote Editor
  const editor = useCreateBlockNote({
    schema: appEditorSchema,
    initialContent: initialBlocks && initialBlocks.length > 0 ? initialBlocks : undefined,
    uploadFile: async (file: File) => {
      const url = await uploadImage(file);
      return getMediaUrl(url);
    },
  });

  // Convert legacy Markdown to BlockNote on first mount if needed
  useEffect(() => {
    if (initialContent && !isInitialBlockNote && editor) {
      try {
        const blocks = editor.tryParseMarkdownToBlocks(initialContent);
        if (blocks && blocks.length > 0) {
          editor.replaceBlocks(editor.topLevelBlocks, blocks);
        }
      } catch (err) {
        console.warn('Failed to parse initial markdown:', err);
      }
    }
  }, [initialContent, isInitialBlockNote, editor]);

  // Construct current payload
  const getCurrentData = useCallback((): ArticleComposerData => {
    const blocksJson = JSON.stringify(editor.document);
    return {
      title: title.trim(),
      content: blocksJson,
      coverImageUrl: coverImageUrl || null,
      contentLanguage,
    };
  }, [editor, title, coverImageUrl, contentLanguage]);

  // Trigger auto-save debounce
  const triggerAutoSave = useCallback(() => {
    isDirtyRef.current = true;
    setSaveState('unsaved');

    if (autoSaveTimerRef.current) {
      clearTimeout(autoSaveTimerRef.current);
    }

    autoSaveTimerRef.current = setTimeout(async () => {
      if (!isDirtyRef.current) return;
      try {
        setSaveState('saving');
        const data = getCurrentData();
        // Only auto-save if title or document has some content
        if (data.title || editor.document.length > 1 || (editor.document[0]?.content as any[])?.length > 0) {
          await onSaveDraft(data);
          isDirtyRef.current = false;
          setSaveState('saved');
          setLastSavedAt(new Date());
        } else {
          setSaveState('saved');
        }
      } catch (err: any) {
        console.error('Auto-save failed:', err);
        setSaveState('error');
      }
    }, 2000); // 2-second debounce
  }, [getCurrentData, editor, onSaveDraft]);

  // Editor change listener
  useEffect(() => {
    if (!editor) return;

    const unsubscribe = editor.onChange(() => {
      // Ignore first trigger right after initialization
      if (!isInitializedRef.current) {
        isInitializedRef.current = true;
        return;
      }
      triggerAutoSave();
    });

    return () => {
      unsubscribe();
      if (autoSaveTimerRef.current) {
        clearTimeout(autoSaveTimerRef.current);
      }
    };
  }, [editor, triggerAutoSave]);

  // Handle Title Change
  const handleTitleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setTitle(e.target.value);
    triggerAutoSave();
  };

  // Handle Manual Save Draft
  const handleSaveDraftClick = async () => {
    if (autoSaveTimerRef.current) {
      clearTimeout(autoSaveTimerRef.current);
    }
    setActionError(null);
    setIsSubmitting(true);
    try {
      setSaveState('saving');
      const data = getCurrentData();
      if (onManualSaveDraft) {
        await onManualSaveDraft(data);
      } else {
        await onSaveDraft(data);
      }
      isDirtyRef.current = false;
      setSaveState('saved');
      setLastSavedAt(new Date());
    } catch (err: any) {
      setActionError(err?.response?.data?.detail || 'Failed to save draft.');
      setSaveState('error');
    } finally {
      setIsSubmitting(false);
    }
  };

  // Handle Primary Action (Publish / Submit Review)
  const handlePrimaryAction = async () => {
    if (!title.trim()) {
      setActionError('Please enter a title before publishing.');
      return;
    }
    if (autoSaveTimerRef.current) {
      clearTimeout(autoSaveTimerRef.current);
    }

    setActionError(null);
    setIsSubmitting(true);
    try {
      setSaveState('saving');
      const data = getCurrentData();

      if (canPublishDirectly && onPublish) {
        await onPublish(data);
      } else if (onSubmitReview) {
        await onSubmitReview(data);
      } else if (onPublish) {
        await onPublish(data);
      }
      isDirtyRef.current = false;
      setSaveState('saved');
    } catch (err: any) {
      setActionError(err?.response?.data?.detail || 'Action failed.');
      setSaveState('error');
    } finally {
      setIsSubmitting(false);
    }
  };

  // Cover image file upload handler
  const handleCoverFileUpload = async (file: File) => {
    setUploadingCover(true);
    try {
      const url = await uploadImage(file);
      setCoverImageUrl(url);
      setShowCoverModal(false);
      triggerAutoSave();
    } catch (err: any) {
      alert(err?.response?.data?.detail || 'Failed to upload cover image.');
    } finally {
      setUploadingCover(false);
    }
  };

  // Cover image URL save handler
  const handleCoverUrlSave = () => {
    if (coverInputUrl.trim()) {
      setCoverImageUrl(coverInputUrl.trim());
      setCoverInputUrl('');
      setShowCoverModal(false);
      triggerAutoSave();
    }
  };

  // Custom Slash Menu Items
  const getSlashMenuItems = useCallback(
    async (query: string) => {
      const defaultItems = getDefaultReactSlashMenuItems(editor);
      
      const customItems = [
        ...defaultItems
          .filter((i) => i.title !== 'Video')
          .map((item) => {
            if (item.title === 'Image') {
              return {
                ...item,
                title: 'Photo / Image',
                subtext: 'Insert a single inline photo',
                aliases: [...(item.aliases || []), 'photo', 'picture', 'pic', 'single photo'],
              };
            }
            return item;
          }),
        {
          title: 'Video Embed',
          subtext: 'YouTube or Vimeo player',
          group: 'Media',
          icon: <Video size={18} style={{ color: '#e88599' }} />,
          onItemClick: () => {
            insertOrUpdateBlockForSlashMenu(editor, { type: 'videoEmbed' });
          },
          aliases: ['video', 'youtube', 'vimeo', 'embed'],
        },
        {
          title: 'Photo Gallery',
          subtext: 'Upload photos for the Session Gallery',
          group: 'Media',
          icon: <Images size={18} style={{ color: '#e88599' }} />,
          onItemClick: () => {
            insertOrUpdateBlockForSlashMenu(editor, { type: 'gallery' });
          },
          aliases: ['photo gallery', 'photogallery', 'photo gallary', 'gallery', 'session gallery', 'photos'],
        },
      ];

      if (!query) return customItems;
      const q = query.toLowerCase();
      return customItems.filter(
        (item) =>
          item.title.toLowerCase().includes(q) ||
          item.subtext?.toLowerCase().includes(q) ||
          item.aliases?.some((a) => a.toLowerCase().includes(q))
      );
    },
    [editor]
  );

  const isRtl = contentLanguage === 'ar';

  return (
    <div className="article-composer-root">
      {/* Top Navigation / Action Bar */}
      <header className="composer-header">
        <div className="composer-header-left">
          <button
            type="button"
            onClick={() => navigate(backUrl)}
            className="composer-back-btn"
          >
            <ArrowLeft size={16} style={{ transform: isRtl ? 'rotate(180deg)' : 'none' }} />
            <span>Back</span>
          </button>

          {/* Publication status badge */}
          {statusBadge && (
            <span className={`composer-badge ${statusBadge.toLowerCase()}`}>
              {statusBadge}
            </span>
          )}

          {/* Save state indicator */}
          <div className={`composer-status-pill ${saveState}`}>
            {saveState === 'saving' && (
              <>
                <Loader2 size={12} className="animate-spin" />
                <span>Saving...</span>
              </>
            )}
            {saveState === 'saved' && (
              <>
                <Check size={12} />
                <span>Saved</span>
              </>
            )}
            {saveState === 'unsaved' && (
              <>
                <span className="inline-block w-2 h-2 rounded-full bg-amber-400" />
                <span>Unsaved changes</span>
              </>
            )}
            {saveState === 'error' && (
              <>
                <AlertCircle size={12} />
                <span>Save error</span>
              </>
            )}
          </div>
        </div>

        <div className="composer-header-right">
          {/* Language selector toggle */}
          <div className="composer-lang-toggle">
            <button
              type="button"
              className={`composer-lang-btn ${contentLanguage === 'en' ? 'active' : ''}`}
              onClick={() => {
                setContentLanguage('en');
                triggerAutoSave();
              }}
            >
              English
            </button>
            <button
              type="button"
              className={`composer-lang-btn ${contentLanguage === 'ar' ? 'active' : ''}`}
              onClick={() => {
                setContentLanguage('ar');
                triggerAutoSave();
              }}
            >
              العربية
            </button>
          </div>

          {/* Save Draft Button */}
          <button
            type="button"
            onClick={handleSaveDraftClick}
            disabled={isSubmitting}
            className="btn-composer-secondary"
          >
            <Save size={15} />
            <span>Save Draft</span>
          </button>

          {/* Primary Action Button */}
          {mode === 'session' ? (
            <button
              type="button"
              onClick={handlePrimaryAction}
              disabled={isSubmitting}
              className="btn-composer-primary"
            >
              <Send size={15} />
              <span>Publish to Studio</span>
            </button>
          ) : canPublishDirectly ? (
            <button
              type="button"
              onClick={handlePrimaryAction}
              disabled={isSubmitting}
              className="btn-composer-primary"
            >
              <CheckCircle2 size={15} />
              <span>Publish Article</span>
            </button>
          ) : (
            <button
              type="button"
              onClick={handlePrimaryAction}
              disabled={isSubmitting}
              className="btn-composer-primary"
            >
              <Send size={15} />
              <span>Submit for Review</span>
            </button>
          )}
        </div>
      </header>

      {/* Action Error Alert */}
      {actionError && (
        <div style={{ maxWidth: '860px', margin: '16px auto 0', padding: '0 16px' }}>
          <div className="custom-block-error" style={{ background: '#fef2f2', padding: '12px 16px', borderRadius: '8px', border: '1px solid #fecaca' }}>
            <AlertCircle size={16} />
            <span style={{ flex: 1 }}>{actionError}</span>
            <button type="button" onClick={() => setActionError(null)} style={{ background: 'transparent', border: 'none', cursor: 'pointer' }}>
              <X size={14} />
            </button>
          </div>
        </div>
      )}

      {/* Writing Canvas Body */}
      <main className="composer-canvas-wrapper">
        <div className="composer-canvas" dir={isRtl ? 'rtl' : 'ltr'}>
          {/* Cover Image Section */}
          <div className="composer-cover-section">
            {coverImageUrl ? (
              <div className="composer-cover-banner">
                <img
                  src={getMediaUrl(coverImageUrl)}
                  alt="Article Cover"
                  className="composer-cover-img"
                />
                <div className="composer-cover-actions">
                  <button
                    type="button"
                    onClick={() => setShowCoverModal(true)}
                    className="composer-cover-btn"
                  >
                    <ImageIcon size={14} /> Change Cover
                  </button>
                  <button
                    type="button"
                    onClick={() => {
                      setCoverImageUrl(null);
                      triggerAutoSave();
                    }}
                    className="composer-cover-btn"
                  >
                    <Trash2 size={14} /> Remove
                  </button>
                </div>
              </div>
            ) : (
              <div className="composer-cover-add-trigger">
                <button
                  type="button"
                  onClick={() => setShowCoverModal(true)}
                  className="btn-add-cover"
                >
                  <ImageIcon size={16} />
                  <span>Add cover image</span>
                </button>
              </div>
            )}
          </div>

          {/* Title Input */}
          <div className="composer-title-section">
            <textarea
              value={title}
              onChange={handleTitleChange}
              placeholder={titlePlaceholder || (isRtl ? 'عنوان المقال أو التوثيق...' : 'Title...')}
              rows={1}
              className="composer-title-input"
              dir="auto"
              onInput={(e) => {
                const target = e.target as HTMLTextAreaElement;
                target.style.height = 'auto';
                target.style.height = `${target.scrollHeight}px`;
              }}
            />
            {authorName && (
              <div className="composer-meta-row">
                <span>By {authorName}</span>
                {lastSavedAt && (
                  <span>
                    Saved at {lastSavedAt.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </span>
                )}
              </div>
            )}
          </div>

          {/* BlockNote Editor Canvas */}
          <div className="composer-editor-content">
            <BlockNoteView
              editor={editor}
              theme="light"
              slashMenu={false}
            >
              <SuggestionMenuController
                triggerCharacter="/"
                getItems={getSlashMenuItems}
              />
            </BlockNoteView>
          </div>
        </div>
      </main>

      {/* Cover Image Modal */}
      {showCoverModal && (
        <div className="composer-modal-overlay">
          <div className="composer-modal-card">
            <div className="composer-modal-title">
              <span>Choose Cover Image</span>
              <button
                type="button"
                onClick={() => setShowCoverModal(false)}
                className="composer-modal-close"
              >
                <X size={18} />
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div>
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  style={{ display: 'none' }}
                  onChange={(e) => {
                    if (e.target.files && e.target.files[0]) {
                      handleCoverFileUpload(e.target.files[0]);
                    }
                  }}
                />
                <button
                  type="button"
                  onClick={() => fileInputRef.current?.click()}
                  disabled={uploadingCover}
                  className="btn-composer-secondary"
                  style={{ width: '100%', justifyContent: 'center', padding: '12px' }}
                >
                  {uploadingCover ? (
                    <>
                      <Loader2 size={16} className="animate-spin" />
                      <span>Uploading...</span>
                    </>
                  ) : (
                    <>
                      <Upload size={16} />
                      <span>Upload from Device</span>
                    </>
                  )}
                </button>
              </div>

              <div style={{ textAlign: 'center', color: '#9ca3af', fontSize: '13px' }}>
                — or paste image URL —
              </div>

              <div style={{ display: 'flex', gap: '8px' }}>
                <input
                  type="url"
                  placeholder="https://example.com/image.jpg"
                  value={coverInputUrl}
                  onChange={(e) => setCoverInputUrl(e.target.value)}
                  className="custom-block-input"
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') {
                      e.preventDefault();
                      handleCoverUrlSave();
                    }
                  }}
                />
                <button
                  type="button"
                  onClick={handleCoverUrlSave}
                  className="btn-primary-sm"
                >
                  Set
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
