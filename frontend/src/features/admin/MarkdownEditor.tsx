import { useState, useRef } from 'react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { 
  Heading1, 
  Heading2, 
  Heading3, 
  Bold, 
  Italic, 
  List, 
  ListOrdered, 
  Quote, 
  Code, 
  BookA, 
  FileText,
  Eye,
  Edit3
} from 'lucide-react';
import '@/styles/markdown.css';

interface MarkdownEditorProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  minRows?: number;
}

export default function MarkdownEditor({ 
  value, 
  onChange, 
  placeholder = "Write session summary, key discussion points, vocabulary, and notes...", 
  minRows = 10 
}: MarkdownEditorProps) {
  const [activeTab, setActiveTab] = useState<'write' | 'preview'>('write');
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const insertFormatting = (prefix: string, suffix: string = '', defaultText: string = '') => {
    const textarea = textareaRef.current;
    if (!textarea) return;

    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const selectedText = value.substring(start, end) || defaultText;
    
    // Check if inserting at beginning of line or requires newlines
    const isBlock = prefix.startsWith('#') || prefix.startsWith('- ') || prefix.startsWith('1. ') || prefix.startsWith('> ');
    const beforeText = value.substring(0, start);
    const afterText = value.substring(end);
    
    const needsLeadingNewline = isBlock && start > 0 && !beforeText.endsWith('\n');
    const leading = needsLeadingNewline ? '\n' : '';
    
    const replacement = `${leading}${prefix}${selectedText}${suffix}`;
    const newValue = `${beforeText}${replacement}${afterText}`;
    
    onChange(newValue);
    
    // Restore focus and selection
    setTimeout(() => {
      textarea.focus();
      const newCursorPos = start + leading.length + prefix.length + selectedText.length;
      textarea.setSelectionRange(newCursorPos, newCursorPos);
    }, 10);
  };

  const insertTemplate = () => {
    const template = `# Session Summary

## Overview
A brief overview of the book, manga, or article discussed in today's reading session...

### Discussion Highlights
1. First major theme or character moment
2. Cultural background, grammar subtleties, and discussion points
3. Questions raised by club members

### Key Vocabulary & Expressions
- **単語 (reading)**: Definition and context
- **表現 (reading)**: Common usage example

> "A memorable quote or passage that resonated with the group."
`;
    if (value.trim() && !window.confirm('Replace current content with the standard session template?')) {
      return;
    }
    onChange(template);
  };

  return (
    <div className="border border-gray-300 rounded-xl overflow-hidden focus-within:ring-2 focus-within:ring-primary/20 focus-within:border-primary transition-all bg-white shadow-sm">
      {/* Editor Header & Toolbar */}
      <div className="bg-gray-50 border-b border-gray-200 p-2 flex flex-wrap items-center justify-between gap-2">
        {/* Formatting Actions */}
        <div className="flex flex-wrap items-center gap-1">
          <button
            type="button"
            onClick={() => insertFormatting('# ', '', 'Big Title')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors flex items-center gap-1 text-xs font-semibold"
            title="Big Title (H1)"
          >
            <Heading1 className="w-4 h-4" />
            <span className="hidden sm:inline">H1</span>
          </button>

          <button
            type="button"
            onClick={() => insertFormatting('## ', '', 'Section Heading')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors flex items-center gap-1 text-xs font-semibold"
            title="Section Heading (H2)"
          >
            <Heading2 className="w-4 h-4" />
            <span className="hidden sm:inline">H2</span>
          </button>

          <button
            type="button"
            onClick={() => insertFormatting('### ', '', 'Subheading')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors flex items-center gap-1 text-xs font-semibold"
            title="Subheading (H3)"
          >
            <Heading3 className="w-4 h-4" />
            <span className="hidden sm:inline">H3</span>
          </button>

          <div className="w-[1px] h-5 bg-gray-300 mx-1" />

          <button
            type="button"
            onClick={() => insertFormatting('**', '**', 'bold text')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors"
            title="Bold (**text**)"
          >
            <Bold className="w-4 h-4" />
          </button>

          <button
            type="button"
            onClick={() => insertFormatting('*', '*', 'italic text')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors"
            title="Italic (*text*)"
          >
            <Italic className="w-4 h-4" />
          </button>

          <div className="w-[1px] h-5 bg-gray-300 mx-1" />

          <button
            type="button"
            onClick={() => insertFormatting('- ', '', 'Bullet point')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors flex items-center gap-1 text-xs font-medium"
            title="Add Bullet Points (- item)"
          >
            <List className="w-4 h-4" />
            <span className="hidden md:inline">Bullet</span>
          </button>

          <button
            type="button"
            onClick={() => insertFormatting('1. ', '', 'Numbered item')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors flex items-center gap-1 text-xs font-medium"
            title="Add Numbered List (1. item)"
          >
            <ListOrdered className="w-4 h-4" />
            <span className="hidden md:inline">Numbered</span>
          </button>

          <button
            type="button"
            onClick={() => insertFormatting('> "', '"', 'Quote text here')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors"
            title="Blockquote (> quote)"
          >
            <Quote className="w-4 h-4" />
          </button>

          <button
            type="button"
            onClick={() => insertFormatting('```\n', '\n```', 'code or note')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors"
            title="Code / Monospace block"
          >
            <Code className="w-4 h-4" />
          </button>

          <button
            type="button"
            onClick={() => insertFormatting('- **単語 (reading)**: ', '', 'Meaning and nuance')}
            className="p-1.5 hover:bg-gray-200 text-gray-700 rounded transition-colors flex items-center gap-1 text-xs font-medium text-primary"
            title="Insert Vocabulary Format"
          >
            <BookA className="w-4 h-4" />
            <span className="hidden md:inline">Vocab</span>
          </button>

          <button
            type="button"
            onClick={insertTemplate}
            className="p-1.5 hover:bg-primary/10 text-primary hover:text-primary-dark rounded transition-colors flex items-center gap-1 text-xs font-medium ml-1"
            title="Insert Ready-Made Session Template"
          >
            <FileText className="w-4 h-4" />
            <span>Use Template</span>
          </button>
        </div>

        {/* Tab Switcher: Write vs Preview */}
        <div className="flex bg-gray-200/80 p-0.5 rounded-lg text-xs font-medium">
          <button
            type="button"
            onClick={() => setActiveTab('write')}
            className={`px-3 py-1 rounded-md transition-all flex items-center gap-1.5 ${
              activeTab === 'write' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            <Edit3 className="w-3.5 h-3.5" />
            Write
          </button>
          <button
            type="button"
            onClick={() => setActiveTab('preview')}
            className={`px-3 py-1 rounded-md transition-all flex items-center gap-1.5 ${
              activeTab === 'preview' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            <Eye className="w-3.5 h-3.5" />
            Live Preview
          </button>
        </div>
      </div>

      {/* Editor Body */}
      {activeTab === 'write' ? (
        <textarea
          ref={textareaRef}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          rows={minRows}
          className="w-full p-4 font-mono text-sm leading-relaxed outline-none resize-y text-gray-800 placeholder-gray-400 bg-white"
        />
      ) : (
        <div className="p-6 min-h-[250px] bg-white overflow-y-auto max-h-[500px]">
          {value.trim() ? (
            <div className="markdown-content">
              <ReactMarkdown remarkPlugins={[remarkGfm]}>
                {value}
              </ReactMarkdown>
            </div>
          ) : (
            <div className="text-gray-400 italic text-center py-12">
              Nothing to preview yet. Switch to "Write" tab and add your notes or click "Use Template".
            </div>
          )}
        </div>
      )}
    </div>
  );
}
