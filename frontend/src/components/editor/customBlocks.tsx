import { useState, useRef } from 'react';
import { createReactBlockSpec } from '@blocknote/react';
import { Video, Plus, Trash2, AlertCircle, Upload, Loader2, Images } from 'lucide-react';
import { parseVideoEmbedUrl } from '../../lib/content-utils';
import { uploadImage, getMediaUrl } from '../../lib/api';

export interface GalleryImageItem {
  url: string;
  caption?: string;
}

export const VideoEmbedBlock = createReactBlockSpec(
  {
    type: 'videoEmbed',
    propSchema: {
      url: { default: '' },
      caption: { default: '' },
    },
    content: 'none',
  },
  {
    render: (props) => {
      const { block, editor } = props;
      const [inputUrl, setInputUrl] = useState(block.props.url);
      const [error, setError] = useState<string | null>(null);
      const [isEditing, setIsEditing] = useState(!block.props.url);
      const embedInfo = parseVideoEmbedUrl(block.props.url);

      const handleSave = () => {
        const parsed = parseVideoEmbedUrl(inputUrl);
        if (!parsed) {
          setError('Only YouTube and Vimeo links are supported.');
          return;
        }
        setError(null);
        editor.updateBlock(block, {
          type: 'videoEmbed',
          props: {
            url: inputUrl,
            caption: block.props.caption,
          },
        });
        setIsEditing(false);
      };

      if (isEditing && editor.isEditable) {
        return (
          <div className="custom-block-card video-embed-card">
            <div className="custom-block-header">
              <Video size={18} className="custom-block-icon" />
              <span className="custom-block-title">Embed Video (YouTube or Vimeo)</span>
            </div>
            <div className="custom-block-form">
              <input
                type="url"
                value={inputUrl}
                onChange={(e) => {
                  setInputUrl(e.target.value);
                  setError(null);
                }}
                placeholder="https://www.youtube.com/watch?v=... or https://vimeo.com/..."
                className="custom-block-input"
              />
              <div className="custom-block-actions">
                <button
                  type="button"
                  onClick={handleSave}
                  className="btn-primary-sm"
                >
                  Embed Video
                </button>
                {block.props.url && (
                  <button
                    type="button"
                    onClick={() => {
                      setInputUrl(block.props.url);
                      setIsEditing(false);
                      setError(null);
                    }}
                    className="btn-secondary-sm"
                  >
                    Cancel
                  </button>
                )}
              </div>
            </div>
            {error && (
              <div className="custom-block-error">
                <AlertCircle size={14} />
                <span>{error}</span>
              </div>
            )}
          </div>
        );
      }

      if (!embedInfo) {
        return (
          <div className="custom-block-card video-embed-card empty">
            <Video size={24} />
            <p>No video linked.</p>
            {editor.isEditable && (
              <button
                type="button"
                onClick={() => setIsEditing(true)}
                className="btn-secondary-sm"
              >
                Add Video
              </button>
            )}
          </div>
        );
      }

      return (
        <div className="custom-block-embed-wrapper">
          <div className="video-responsive-container">
            <iframe
              src={embedInfo.embedUrl}
              title={block.props.caption || 'Video player'}
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
              className="video-iframe"
            />
          </div>
          {editor.isEditable ? (
            <div className="video-caption-toolbar">
              <input
                type="text"
                placeholder="Add video caption..."
                value={block.props.caption}
                onChange={(e) => {
                  editor.updateBlock(block, {
                    type: 'videoEmbed',
                    props: {
                      ...block.props,
                      caption: e.target.value,
                    },
                  });
                }}
                className="caption-inline-input"
              />
              <button
                type="button"
                onClick={() => setIsEditing(true)}
                className="btn-link-sm"
              >
                Change Video
              </button>
            </div>
          ) : (
            block.props.caption && (
              <p className="article-media-caption">{block.props.caption}</p>
            )
          )}
        </div>
      );
    },
  }
);

export const GalleryBlock = createReactBlockSpec(
  {
    type: 'gallery',
    propSchema: {
      images: { default: '[]' },
      caption: { default: '' },
      columns: { default: '2' },
    },
    content: 'none',
  },
  {
    render: (props) => {
      const { block, editor } = props;

      // In read-only mode (viewing published session or preview), photos uploaded in this block
      // are collected and displayed in the dedicated "Session Gallery" section at the bottom
      // of the session page. Return null to avoid duplicate rendering in the text body.
      if (!editor.isEditable) {
        return null;
      }

      const fileInputRef = useRef<HTMLInputElement>(null);
      const [isDragging, setIsDragging] = useState(false);
      const [isUploading, setIsUploading] = useState(false);
      const [uploadError, setUploadError] = useState<string | null>(null);

      let imageList: GalleryImageItem[] = [];
      try {
        imageList = JSON.parse(block.props.images || '[]');
      } catch {
        imageList = [];
      }

      const updateImages = (newList: GalleryImageItem[]) => {
        editor.updateBlock(block, {
          type: 'gallery',
          props: {
            ...block.props,
            images: JSON.stringify(newList),
          },
        });
      };

      const handleFiles = async (files: FileList | File[]) => {
        if (!files || files.length === 0) return;
        setIsUploading(true);
        setUploadError(null);
        try {
          const uploadedUrls: string[] = [];
          for (let i = 0; i < files.length; i++) {
            const file = files[i];
            if (!file.type.startsWith('image/')) continue;
            const url = await uploadImage(file);
            uploadedUrls.push(url);
          }
          if (uploadedUrls.length > 0) {
            const newItems = uploadedUrls.map(url => ({ url }));
            updateImages([...imageList, ...newItems]);
          }
        } catch (err: any) {
          console.error('Failed to upload image(s):', err);
          setUploadError(err?.response?.data?.detail || 'Failed to upload image(s). Please try again.');
        } finally {
          setIsUploading(false);
          if (fileInputRef.current) {
            fileInputRef.current.value = '';
          }
        }
      };

      const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files) {
          handleFiles(e.target.files);
        }
      };

      const handleDragOver = (e: React.DragEvent) => {
        e.preventDefault();
        e.stopPropagation();
        setIsDragging(true);
      };

      const handleDragLeave = (e: React.DragEvent) => {
        e.preventDefault();
        e.stopPropagation();
        setIsDragging(false);
      };

      const handleDrop = (e: React.DragEvent) => {
        e.preventDefault();
        e.stopPropagation();
        setIsDragging(false);
        if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
          handleFiles(e.dataTransfer.files);
        }
      };

      const handleRemoveImage = (index: number) => {
        const newList = imageList.filter((_, i) => i !== index);
        updateImages(newList);
      };

      const columnsCount = block.props.columns === '3' ? 3 : 2;

      return (
        <div className="custom-block-gallery-wrapper">
          <div
            className="gallery-block-admin-banner"
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '10px 14px',
              backgroundColor: '#fdf2f4',
              border: '1px solid #fbcfe8',
              borderRadius: '8px',
              marginBottom: '14px',
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#be185d', fontWeight: 600, fontSize: '13px' }}>
              <Images size={16} />
              <span>Session Gallery</span>
            </div>
            <span style={{ fontSize: '12px', color: '#6b7280' }}>
              Photos will be displayed in the Session Gallery at the bottom of the page
            </span>
          </div>

          {imageList.length > 0 && (
            <div
              className={`gallery-grid gallery-cols-${columnsCount}`}
              style={{
                display: 'grid',
                gridTemplateColumns: `repeat(${columnsCount}, 1fr)`,
                gap: '12px',
                marginBottom: '16px',
              }}
            >
              {imageList.map((img, idx) => (
                <div key={idx} className="gallery-grid-item">
                  <img
                    src={getMediaUrl(img.url)}
                    alt={img.caption || `Gallery item ${idx + 1}`}
                    className="gallery-grid-image"
                    loading="lazy"
                  />
                  {editor.isEditable && (
                    <button
                      type="button"
                      onClick={() => handleRemoveImage(idx)}
                      className="gallery-item-delete"
                      title="Remove image"
                    >
                      <Trash2 size={14} />
                    </button>
                  )}
                </div>
              ))}
            </div>
          )}

          {editor.isEditable && (
            <div className="gallery-editor-controls">
              <input
                ref={fileInputRef}
                type="file"
                multiple
                accept="image/*"
                onChange={handleFileChange}
                style={{ display: 'none' }}
              />

              <div
                className={`gallery-dropzone ${isDragging ? 'dragging' : ''}`}
                onDragOver={handleDragOver}
                onDragLeave={handleDragLeave}
                onDrop={handleDrop}
                onClick={() => !isUploading && fileInputRef.current?.click()}
                title="Click to browse photos or drag and drop here"
              >
                {isUploading ? (
                  <>
                    <Loader2 className="gallery-dropzone-icon animate-spin" />
                    <div className="gallery-dropzone-text">Uploading images...</div>
                    <div className="gallery-dropzone-subtext">Please wait while your files are uploaded.</div>
                  </>
                ) : (
                  <>
                    <Upload className="gallery-dropzone-icon" />
                    <div className="gallery-dropzone-text">
                      Click to browse or drag & drop images here
                    </div>
                    <div className="gallery-dropzone-subtext">
                      Select photos from your phone or computer (JPG, PNG, WebP)
                    </div>
                  </>
                )}
              </div>

              {uploadError && (
                <div style={{ color: '#dc2626', fontSize: '13px', display: 'flex', alignItems: 'center', gap: '6px', padding: '4px 0' }}>
                  <AlertCircle size={15} />
                  <span>{uploadError}</span>
                </div>
              )}

              <div className="gallery-toolbar-row">
                <button
                  type="button"
                  onClick={() => !isUploading && fileInputRef.current?.click()}
                  className="btn-gallery-add"
                  disabled={isUploading}
                >
                  <Plus size={14} /> Add Images
                </button>

                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <span style={{ fontSize: '12px', color: '#6b7280' }}>Columns:</span>
                  <select
                    value={block.props.columns}
                    onChange={(e) => {
                      editor.updateBlock(block, {
                        type: 'gallery',
                        props: {
                          ...block.props,
                          columns: e.target.value,
                        },
                      });
                    }}
                    className="gallery-cols-select"
                  >
                    <option value="2">2 Columns</option>
                    <option value="3">3 Columns</option>
                  </select>
                </div>
              </div>

              <input
                type="text"
                placeholder="Gallery caption (optional)..."
                value={block.props.caption}
                onChange={(e) => {
                  editor.updateBlock(block, {
                    type: 'gallery',
                    props: {
                      ...block.props,
                      caption: e.target.value,
                    },
                  });
                }}
                className="caption-inline-input"
              />
            </div>
          )}
        </div>
      );
    },
  }
);
