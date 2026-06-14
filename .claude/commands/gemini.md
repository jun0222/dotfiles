# /gemini — Gemini CLI に聞く

Gemini CLI（`/usr/local/bin/gemini`）を非インタラクティブモードで呼び出し、結果を表示する。
Claude Code の中から Gemini にセカンドオピニオンや別視点を求めるときに使う。

## 使い方

```
/gemini <質問・プロンプト>
/gemini --file <パス> <質問>      # ファイルを読ませて質問
/gemini --model <モデル名> <質問>  # モデルを指定
/gemini --yolo <質問>              # 確認なしで自動実行（YOLO mode）
```

## 処理内容

### 1. 引数をパース

ARGUMENTS から以下を抽出する:

| フラグ | 変数 | デフォルト |
|---|---|---|
| `--file <path>` | `FILE` | なし |
| `--model <name>` | `MODEL` | なし（CLIデフォルトに任せる） |
| `--yolo` | `YOLO` | false |
| それ以外すべて | `PROMPT` | （必須） |

`PROMPT` が空なら「質問内容を入力してください」と出力して終了。

### 2. コマンドを組み立てて実行

**ファイルなし（基本形）:**
```bash
gemini -p "<PROMPT>"
```

**ファイルあり（ファイル内容をstdinで渡す）:**
```bash
cat <FILE> | gemini -p "<PROMPT>\n\n上記のファイル（<FILE>）について回答してください。"
```

**モデル指定あり:**
```bash
gemini -m <MODEL> -p "<PROMPT>"
```

**YOLO モード:**
```bash
gemini --yolo -p "<PROMPT>"
```

フラグは組み合わせ可能（例: `--file` + `--model` + `--yolo`）。

実行は Bash ツールを使う。タイムアウトは **120秒**。

### 3. 結果を表示

Gemini の出力をそのまま表示する。その後、以下を1行で添える:

```
── Gemini CLI (モデル名 or デフォルト) ──
```

エラー終了（exit code != 0）の場合はエラー内容を表示して終了。

## ルール

- Claude 自身は回答を加工・要約しない。Gemini の生出力を見せる
- `--file` で存在しないパスを指定された場合は「ファイルが見つかりません: <path>」と出力して終了
- ストリーム出力は `-o text` オプションで安定させる

## 実行例

```
/gemini このコードのパフォーマンス改善案を教えて
/gemini --file ./dir2html.js 読みやすさの観点でレビューして
/gemini --model gemini-2.5-pro このアーキテクチャどう思う？
/gemini --file ./marp/sample.md --model gemini-2.5-flash 要約して
```