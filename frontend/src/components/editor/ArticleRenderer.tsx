import { useMemo, useState } from 'react';
import { useCreateBlockNote } from '@blocknote/react';
import { BlockNoteView } from '@blocknote/mantine';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { appEditorSchema } from './editorSchema';
import { isBlockNoteContent, safeParseBlocks } from '../../lib/content-utils';
import { HelpCircle, Eye, EyeOff, Quote } from 'lucide-react';
import '@blocknote/mantine/style.css';
import '@/styles/markdown.css';

interface ArticleRendererProps {
  content?: string | null;
  dir?: 'ltr' | 'rtl' | 'auto';
  className?: string;
  fallbackText?: string;
}

// Subcomponent for BlockNote read-only rendering
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

// Helper to check if text matches Japanese vocabulary item
// Matches e.g. "台所 (だいどころ - daidokoro): Kitchen" or "孤独 (こどく): Solitude" or "食べる: To eat"
function parseVocab(text: string) {
  const match = text.match(/^([^\(:\uFF1A]+)(?:\s*[\(（]([^)）]+)[\)）])?\s*[:：]\s*(.+)$/);
  if (!match) return null;
  return {
    word: match[1].trim(),
    reading: match[2]?.trim() || '',
    meaning: match[3].trim(),
  };
}

// Single Interactive Vocabulary Card
function VocabChip({
  word,
  reading,
  meaning,
  isQuizHidden,
}: {
  word: string;
  reading?: string;
  meaning: string;
  isQuizHidden: boolean;
}) {
  const [revealed, setRevealed] = useState(false);
  const isHidden = isQuizHidden && !revealed;

  return (
    <div
      className="tactile-vocab-card"
      onClick={() => isQuizHidden && setRevealed(!revealed)}
      title={isQuizHidden ? 'Click to reveal / hide meaning' : undefined}
      style={{ cursor: isQuizHidden ? 'pointer' : 'default' }}
    >
      <div className="vocab-card-header">
        <span className="vocab-word font-ja-serif">{word}</span>
        {reading && (
          <span className="vocab-reading-pill">{reading}</span>
        )}
      </div>

      <div className="vocab-card-body">
        {isHidden ? (
          <span className="vocab-meaning-hidden">
            <EyeOff size={14} /> Click to reveal
          </span>
        ) : (
          <span className="vocab-meaning-text">{meaning}</span>
        )}
      </div>
    </div>
  );
}

export default function ArticleRenderer({
  content,
  dir = 'auto',
  className = '',
  fallbackText,
}: ArticleRendererProps) {
  const [quizMode, setQuizMode] = useState(false);
  const isBlock = useMemo(() => isBlockNoteContent(content), [content]);
  const parsedBlocks = useMemo(() => (isBlock ? safeParseBlocks(content) : null), [isBlock, content]);

  // Check if content likely contains vocabulary
  const hasVocabCandidates = useMemo(() => {
    if (!content) return false;
    return /[:：]/.test(content) && /[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]/.test(content);
  }, [content]);

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

  // Fallback to enhanced tactile Markdown rendering
  return (
    <div className={`markdown-content ${className}`} dir={dir}>
      {hasVocabCandidates && (
        <div className="vocab-quiz-toolbar">
          <div className="quiz-info">
            <HelpCircle size={15} />
            <span>Interactive Vocabulary & Quiz Mode</span>
          </div>
          <button
            type="button"
            className={`tactile-btn vocab-quiz-toggle ${quizMode ? 'active' : ''}`}
            onClick={() => setQuizMode(!quizMode)}
          >
            {quizMode ? <Eye size={14} /> : <EyeOff size={14} />}
            <span>{quizMode ? 'Reveal All Meanings' : 'Quiz Mode: Hide Meanings'}</span>
          </button>
        </div>
      )}

      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          blockquote: ({ children }) => (
            <blockquote className="pinned-sticky-note">
              <span className="sticky-note-pin" aria-hidden="true">📌</span>
              <Quote size={20} className="sticky-note-quote-icon" />
              <div className="sticky-note-body">{children}</div>
            </blockquote>
          ),
          li: ({ children }) => {
            // Try extracting plain text from children
            let plainText = '';
            if (Array.isArray(children)) {
              plainText = children.map(c => (typeof c === 'string' ? c : '')).join('');
            } else if (typeof children === 'string') {
              plainText = children;
            }

            const parsed = parseVocab(plainText);
            if (parsed && parsed.word && parsed.meaning) {
              return (
                <li className="vocab-li-wrapper">
                  <VocabChip
                    word={parsed.word}
                    reading={parsed.reading}
                    meaning={parsed.meaning}
                    isQuizHidden={quizMode}
                  />
                </li>
              );
            }

            return <li>{children}</li>;
          },
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}
