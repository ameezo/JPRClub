import React, { useState, useRef } from 'react';
import { Upload, X, Loader2, Link2, Plus, AlertCircle } from 'lucide-react';
import { uploadImage, uploadMultipleImages, getMediaUrl } from '@/lib/api';

interface CoverUploaderProps {
  coverUrl: string;
  onChange: (url: string) => void;
}

export function CoverUploader({ coverUrl, onChange }: CoverUploaderProps) {
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState('');
  const [showUrlInput, setShowUrlInput] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFile = async (file: File) => {
    setError('');
    setUploading(true);
    try {
      const url = await uploadImage(file);
      onChange(url);
    } catch (err: any) {
      setError(err?.response?.data?.detail || 'Failed to upload image');
    } finally {
      setUploading(false);
    }
  };

  const onDrop = (e: React.DragEvent) => {
    e.preventDefault();
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      handleFile(e.dataTransfer.files[0]);
    }
  };

  return (
    <div className="space-y-3">
      <input 
        ref={fileInputRef}
        type="file" 
        accept="image/*" 
        className="hidden" 
        onChange={(e) => {
          if (e.target.files && e.target.files[0]) {
            handleFile(e.target.files[0]);
          }
        }}
      />

      {coverUrl ? (
        <div className="relative group rounded-2xl overflow-hidden border border-gray-200 bg-gray-50 aspect-[21/9] max-h-64 flex items-center justify-center">
          <img 
            src={getMediaUrl(coverUrl)} 
            alt="Cover Preview" 
            className="w-full h-full object-cover"
          />
          <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-3">
            <button
              type="button"
              onClick={() => fileInputRef.current?.click()}
              disabled={uploading}
              className="px-4 py-2 bg-white text-gray-900 rounded-xl font-medium text-sm shadow hover:bg-gray-100 transition-colors"
            >
              Replace Photo
            </button>
            <button
              type="button"
              onClick={() => onChange('')}
              className="px-4 py-2 bg-red-600 text-white rounded-xl font-medium text-sm shadow hover:bg-red-700 transition-colors"
            >
              Remove
            </button>
          </div>
        </div>
      ) : (
        <div 
          onDragOver={(e) => e.preventDefault()}
          onDrop={onDrop}
          onClick={() => fileInputRef.current?.click()}
          className="border-2 border-dashed border-gray-300 hover:border-primary/50 hover:bg-primary/5 rounded-2xl p-6 text-center cursor-pointer transition-all flex flex-col items-center justify-center gap-2"
        >
          {uploading ? (
            <div className="flex flex-col items-center py-4">
              <Loader2 className="w-8 h-8 text-primary animate-spin mb-2" />
              <span className="text-sm text-gray-500 font-medium">Uploading cover photo...</span>
            </div>
          ) : (
            <>
              <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center text-primary mb-1">
                <Upload className="w-6 h-6" />
              </div>
              <div className="font-semibold text-gray-800 text-sm">
                Drop cover image here, or <span className="text-primary underline">browse</span>
              </div>
              <div className="text-xs text-gray-500">
                Supports camera, phone/tablet gallery, or local files (JPG, PNG, WebP)
              </div>
            </>
          )}
        </div>
      )}

      {error && (
        <div className="flex items-center gap-2 text-xs text-red-600 font-medium">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{error}</span>
        </div>
      )}

    </div>
  );
}

interface GalleryUploaderProps {
  images: string[];
  onChange: (images: string[]) => void;
}

export function GalleryUploader({ images, onChange }: GalleryUploaderProps) {
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState('');
  const [manualUrl, setManualUrl] = useState('');
  const [showManualAdd, setShowManualAdd] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFiles = async (fileList: FileList | File[]) => {
    setError('');
    const files = Array.from(fileList);
    if (files.length === 0) return;

    setUploading(true);
    try {
      const urls = await uploadMultipleImages(files);
      onChange([...images, ...urls]);
    } catch (err: any) {
      setError(err?.response?.data?.detail || 'Failed to upload images');
    } finally {
      setUploading(false);
    }
  };

  const removeImage = (indexToRemove: number) => {
    onChange(images.filter((_, idx) => idx !== indexToRemove));
  };

  const addManualUrl = (e: React.FormEvent) => {
    e.preventDefault();
    if (!manualUrl.trim()) return;
    onChange([...images, manualUrl.trim()]);
    setManualUrl('');
  };

  return (
    <div className="space-y-4">
      <input 
        ref={fileInputRef}
        type="file" 
        accept="image/*" 
        multiple
        className="hidden" 
        onChange={(e) => {
          if (e.target.files) {
            handleFiles(e.target.files);
          }
        }}
      />

      {/* Upload Dropzone */}
      <div 
        onDragOver={(e) => e.preventDefault()}
        onDrop={(e) => {
          e.preventDefault();
          if (e.dataTransfer.files) {
            handleFiles(e.dataTransfer.files);
          }
        }}
        onClick={() => fileInputRef.current?.click()}
        className="border-2 border-dashed border-gray-300 hover:border-primary/50 hover:bg-primary/5 rounded-2xl p-6 text-center cursor-pointer transition-all flex flex-col items-center justify-center gap-2 bg-gray-50/50"
      >
        {uploading ? (
          <div className="flex flex-col items-center py-4">
            <Loader2 className="w-8 h-8 text-primary animate-spin mb-2" />
            <span className="text-sm text-gray-600 font-medium">Uploading photos...</span>
          </div>
        ) : (
          <>
            <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center text-primary mb-1">
              <Upload className="w-6 h-6" />
            </div>
            <div className="font-semibold text-gray-800 text-sm">
              Drag & drop photos here, or <span className="text-primary underline">choose from files / device gallery</span>
            </div>
            <div className="text-xs text-gray-500">
              Select multiple photos at once from your phone, tablet, or laptop
            </div>
          </>
        )}
      </div>

      {error && (
        <div className="flex items-center gap-2 text-xs text-red-600 font-medium">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{error}</span>
        </div>
      )}

      {/* Thumbnails Grid */}
      {images.length > 0 && (
        <div>
          <div className="text-xs font-semibold text-gray-700 uppercase tracking-wider mb-2">
            Selected Photos ({images.length})
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
            {images.map((imgUrl, idx) => (
              <div 
                key={idx} 
                className="relative group rounded-xl overflow-hidden aspect-square border border-gray-200 bg-gray-100 shadow-sm"
              >
                <img 
                  src={getMediaUrl(imgUrl)} 
                  alt={`Session Photo ${idx + 1}`}
                  className="w-full h-full object-cover transition-transform group-hover:scale-105" 
                />
                
                {/* Photo number badge */}
                <div className="absolute top-2 left-2 bg-black/60 backdrop-blur-sm text-white px-2 py-0.5 rounded-md text-[10px] font-bold">
                  #{idx + 1}
                </div>

                {/* Remove button */}
                <button
                  type="button"
                  onClick={(e) => {
                    e.stopPropagation();
                    removeImage(idx);
                  }}
                  className="absolute top-2 right-2 p-1.5 bg-red-600 text-white rounded-full shadow hover:bg-red-700 transition-colors opacity-90 group-hover:opacity-100"
                  title="Remove photo"
                >
                  <X className="w-3.5 h-3.5" />
                </button>
              </div>
            ))}
          </div>
        </div>
      )}


    </div>
  );
}
