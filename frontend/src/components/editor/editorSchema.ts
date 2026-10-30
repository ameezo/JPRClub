import { BlockNoteSchema, defaultBlockSpecs } from '@blocknote/core';
import { VideoEmbedBlock, GalleryBlock } from './customBlocks';

export const appEditorSchema = BlockNoteSchema.create({
  blockSpecs: {
    ...defaultBlockSpecs,
    videoEmbed: VideoEmbedBlock(),
    gallery: GalleryBlock(),
  },
});

export type AppEditorSchema = typeof appEditorSchema;
