#!/usr/bin/env node
// Usage: node dir2html.js <directory> [output.html]

const fs = require('fs');
const path = require('path');

const dir = path.resolve(process.argv[2] || '.');
const outFile = process.argv[3] || path.join(dir, 'output.html');

const IMAGE_EXTS = new Set(['.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp']);
const MIME = { '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.gif': 'image/gif', '.svg': 'image/svg+xml', '.webp': 'image/webp' };

const files = fs.readdirSync(dir)
  .filter(f => {
    const ext = path.extname(f).toLowerCase();
    return ext === '.md' || IMAGE_EXTS.has(ext);
  })
  .sort();

function toBase64(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  const mime = MIME[ext] || 'image/png';
  const data = fs.readFileSync(filePath).toString('base64');
  return `data:${mime};base64,${data}`;
}

// Inline local image references in markdown: ![alt](./foo.png) → base64
function inlineLocalImages(md, baseDir) {
  return md.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (match, alt, src) => {
    if (src.startsWith('http://') || src.startsWith('https://') || src.startsWith('data:')) {
      return match;
    }
    const imgPath = path.resolve(baseDir, src);
    if (fs.existsSync(imgPath)) {
      return `![${alt}](${toBase64(imgPath)})`;
    }
    return match;
  });
}

function escapeHtml(s) {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function mdToHtml(content, baseDir) {
  content = inlineLocalImages(content, baseDir);

  const parts = [];
  let lastIndex = 0;

  // Extract mermaid + fenced code blocks before line-by-line processing
  const blockRegex = /^```(\w*)\n([\s\S]*?)^```/gm;
  let match;
  while ((match = blockRegex.exec(content)) !== null) {
    if (match.index > lastIndex) {
      parts.push({ type: 'md', content: content.slice(lastIndex, match.index) });
    }
    const lang = match[1].toLowerCase();
    const code = match[2];
    if (lang === 'mermaid') {
      parts.push({ type: 'mermaid', content: code });
    } else {
      parts.push({ type: 'code', lang, content: code });
    }
    lastIndex = blockRegex.lastIndex;
  }
  if (lastIndex < content.length) {
    parts.push({ type: 'md', content: content.slice(lastIndex) });
  }

  return parts.map(part => {
    if (part.type === 'mermaid') {
      return `<div class="mermaid">\n${part.content}</div>`;
    }
    if (part.type === 'code') {
      return `<pre><code class="language-${part.lang}">${escapeHtml(part.content)}</code></pre>`;
    }
    return convertInlineMarkdown(part.content);
  }).join('');
}

function convertInlineMarkdown(md) {
  const lines = md.split('\n');
  const out = [];
  let inUl = false;
  let inOl = false;

  function closeList() {
    if (inUl) { out.push('</ul>'); inUl = false; }
    if (inOl) { out.push('</ol>'); inOl = false; }
  }

  for (let line of lines) {
    const h3 = line.match(/^### (.+)/);
    const h2 = line.match(/^## (.+)/);
    const h1 = line.match(/^# (.+)/);
    const ul = line.match(/^[-*] (.+)/);
    const ol = line.match(/^\d+\. (.+)/);
    const hr = line.match(/^---+$/);
    const blockquote = line.match(/^> (.+)/);

    if (h1) { closeList(); out.push(`<h1>${inline(h1[1])}</h1>`); }
    else if (h2) { closeList(); out.push(`<h2>${inline(h2[1])}</h2>`); }
    else if (h3) { closeList(); out.push(`<h3>${inline(h3[1])}</h3>`); }
    else if (ul) {
      if (!inUl) { closeList(); out.push('<ul>'); inUl = true; }
      out.push(`<li>${inline(ul[1])}</li>`);
    }
    else if (ol) {
      if (!inOl) { closeList(); out.push('<ol>'); inOl = true; }
      out.push(`<li>${inline(ol[1])}</li>`);
    }
    else if (hr) { closeList(); out.push('<hr>'); }
    else if (blockquote) { closeList(); out.push(`<blockquote>${inline(blockquote[1])}</blockquote>`); }
    else if (line.trim() === '') { closeList(); out.push(''); }
    else { closeList(); out.push(`<p>${inline(line)}</p>`); }
  }
  closeList();
  return out.join('\n');
}

function inline(s) {
  return s
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/__(.+?)__/g, '<strong>$1</strong>')
    .replace(/\*(.+?)\*/g, '<em>$1</em>')
    .replace(/_(.+?)_/g, '<em>$1</em>')
    .replace(/`([^`]+)`/g, '<code>$1</code>')
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    .replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img src="$2" alt="$1" style="max-width:100%">');
}

// Build sections
const sections = files.map(file => {
  const filePath = path.join(dir, file);
  const ext = path.extname(file).toLowerCase();

  if (ext === '.md') {
    const raw = fs.readFileSync(filePath, 'utf8');
    const html = mdToHtml(raw, dir);
    return `<section>
<div class="file-label">${escapeHtml(file)}</div>
<div class="md-content">${html}</div>
</section>`;
  }

  const src = toBase64(filePath);
  return `<section>
<div class="file-label">${escapeHtml(file)}</div>
<div class="img-content"><img src="${src}" alt="${escapeHtml(file)}"></div>
</section>`;
});

const html = `<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${escapeHtml(path.basename(dir))}</title>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
<style>
  *, *::before, *::after { box-sizing: border-box; }
  body {
    font-family: 'Hiragino Sans', 'Yu Gothic', 'Segoe UI', sans-serif;
    max-width: 860px;
    margin: 0 auto;
    padding: 2rem 1.5rem 4rem;
    background: #fff;
    color: #222;
    line-height: 1.75;
  }
  section {
    border-top: 1px solid #e0e0e0;
    padding: 2rem 0;
  }
  section:first-child { border-top: none; }
  .file-label {
    font-size: 0.75rem;
    font-family: monospace;
    color: #aaa;
    margin-bottom: 0.75rem;
    letter-spacing: 0.05em;
  }
  h1 { font-size: 1.8em; margin: 1em 0 0.5em; }
  h2 { font-size: 1.4em; margin: 1.2em 0 0.5em; border-bottom: 1px solid #eee; padding-bottom: 4px; }
  h3 { font-size: 1.15em; margin: 1em 0 0.4em; }
  p { margin: 0.6em 0; }
  ul, ol { padding-left: 1.5em; margin: 0.5em 0; }
  li { margin: 0.2em 0; }
  blockquote {
    border-left: 4px solid #ddd;
    margin: 0.8em 0;
    padding: 0.4em 1em;
    color: #555;
    background: #fafafa;
  }
  pre {
    background: #f5f5f5;
    padding: 1rem;
    border-radius: 6px;
    overflow-x: auto;
    font-size: 0.9em;
  }
  code { font-family: 'Fira Code', 'Courier New', monospace; background: #f0f0f0; padding: 0.1em 0.35em; border-radius: 3px; font-size: 0.9em; }
  pre code { background: none; padding: 0; }
  img { max-width: 100%; border-radius: 6px; }
  .img-content { text-align: center; }
  .mermaid { text-align: center; margin: 1.5rem 0; }
  hr { border: none; border-top: 1px solid #ddd; margin: 1.5rem 0; }
  a { color: #0070f3; text-decoration: none; }
  a:hover { text-decoration: underline; }
</style>
</head>
<body>
${sections.join('\n')}
<script>
  mermaid.initialize({ startOnLoad: true, theme: 'default' });
</script>
</body>
</html>`;

fs.writeFileSync(outFile, html);
console.log(`✓ ${files.length} file(s) → ${outFile}`);