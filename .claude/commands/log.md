# /log — 対話ログ・エラーメモ

Claude Codeとの対話で得た要点・エラー・気づきを `~/Desktop/claude-code/talk-log.html` に追記する。

## 使い方

```
/log <メモ内容>              # 要点・気づきを記録
/log --error <エラー内容>    # エラーを記録
/log --list                  # 直近30件を一覧表示（ターミナル出力）
/log --search <キーワード>   # キーワード検索（ターミナル出力）
```

## 処理内容

### 共通設定

- ログファイルパス: `~/Desktop/claude-code/talk-log.html`
- ディレクトリが存在しない場合は `mkdir -p ~/Desktop/claude-code` で作成
- タイムスタンプ: `date +"%Y-%m-%d %H:%M"` で取得

---

### 1. 引数をパース

- `--error` フラグあり → タイプ = `error`
- `--list` フラグあり → 一覧表示モード
- `--search <word>` → 検索モード
- それ以外 → タイプ = `note`（要点・気づき）

フラグを除いた残りの文字列がメモ本文（ARGUMENTS をそのまま扱う）。

---

### 2. 追記モード（`--list` `--search` 以外）

1. `~/Desktop/claude-code/talk-log.html` を Read する
   - ファイルが存在しない場合は後述の **初期HTMLテンプレート** を書き込んでから処理を続ける

2. タイプに応じたHTMLエントリを生成する:

**note の場合:**
```html
<div class="entry note">
  <span class="time">YYYY-MM-DD HH:MM</span>
  <span class="badge note">要点</span>
  <span class="body">本文</span>
</div>
```

**error の場合:**
```html
<div class="entry error">
  <span class="time">YYYY-MM-DD HH:MM</span>
  <span class="badge error">ERROR</span>
  <span class="body">本文</span>
</div>
```

3. 既存HTMLの `<!-- LOG_ENTRIES -->` コメントの**直後**に新エントリを挿入して Write する

4. 完了メッセージを出力:
```
✓ [タイプ] HH:MM に記録しました → ~/Desktop/claude-code/talk-log.html
```

---

### 3. 一覧表示モード（`--list`）

`talk-log.html` を Read して `.entry` ブロックを新しい順に最大30件抽出し、ターミナルにテキスト表示する:

```
📋 直近30件
──────────────────────────────────────
[要点] 2026-06-14 16:30 | メモ内容...
[ERR]  2026-06-14 15:10 | エラー内容...
```

---

### 4. 検索モード（`--search <キーワード>`）

`talk-log.html` を Read してキーワードを含む `.body` テキストを抽出し、ターミナルに表示する:

```
🔍 "キーワード" の検索結果 (N件)
──────────────────────────────────────
[要点] 2026-06-14 16:30 | ...マッチ内容...
```

---

## 初期HTMLテンプレート（ファイル新規作成時）

```html
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Claude Code Talk Log</title>
<style>
  body {
    font-family: 'Hiragino Sans', 'Yu Gothic', 'Segoe UI', sans-serif;
    max-width: 860px;
    margin: 0 auto;
    padding: 2rem 1.5rem 4rem;
    background: #0d1117;
    color: #e6edf3;
  }
  h1 { font-size: 1.4em; color: #58a6ff; border-bottom: 1px solid #30363d; padding-bottom: 0.5rem; }
  .entry {
    display: flex;
    align-items: baseline;
    gap: 0.75rem;
    padding: 0.6rem 0.75rem;
    margin: 0.4rem 0;
    border-radius: 6px;
    border-left: 3px solid transparent;
    background: #161b22;
    font-size: 0.92em;
    line-height: 1.6;
  }
  .entry.note  { border-left-color: #58a6ff; }
  .entry.error { border-left-color: #f85149; background: #1e1010; }
  .time  { color: #8b949e; font-size: 0.8em; white-space: nowrap; }
  .badge {
    font-size: 0.72em;
    font-weight: bold;
    padding: 0.15em 0.5em;
    border-radius: 4px;
    white-space: nowrap;
  }
  .badge.note  { background: #1f4080; color: #58a6ff; }
  .badge.error { background: #4a0f0f; color: #f85149; }
  .body { flex: 1; color: #e6edf3; }
  #search-box {
    width: 100%;
    padding: 0.5rem 0.75rem;
    margin: 1rem 0;
    background: #161b22;
    border: 1px solid #30363d;
    border-radius: 6px;
    color: #e6edf3;
    font-size: 0.9em;
  }
  #search-box:focus { outline: none; border-color: #58a6ff; }
  #count { color: #8b949e; font-size: 0.8em; margin-bottom: 0.5rem; }
</style>
</head>
<body>
<h1>Claude Code Talk Log</h1>
<input id="search-box" type="text" placeholder="🔍 キーワードで絞り込み..." oninput="filterEntries()">
<div id="count"></div>
<div id="log">
<!-- LOG_ENTRIES -->
</div>
<script>
  function filterEntries() {
    const q = document.getElementById('search-box').value.toLowerCase();
    const entries = document.querySelectorAll('.entry');
    let visible = 0;
    entries.forEach(el => {
      const text = el.querySelector('.body').textContent.toLowerCase();
      const show = !q || text.includes(q);
      el.style.display = show ? '' : 'none';
      if (show) visible++;
    });
    document.getElementById('count').textContent = q ? `${visible} 件ヒット` : `全 ${entries.length} 件`;
  }
  filterEntries();
</script>
</body>
</html>
```

---

## ルール

- 既存エントリは**絶対に削除・変更しない**。追記のみ
- 本文が空の場合は「メモ内容を入力してください」と出力して終了
- 新エントリは `<!-- LOG_ENTRIES -->` の直後（＝ログの先頭）に挿入して新しい順にする

## 実行例

```
/log npx @marp-team/marp-cli でPDF出力できる
/log --error marp: command not found → npx 経由で実行すること
/log dir2html.js は base64で画像インライン化する
/log --list
/log --search mermaid
```
