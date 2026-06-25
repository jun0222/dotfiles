# /addclaudecommand — Claude コマンドを追加する

`.claude/commands/` に新しいコマンド定義ファイルを作成する。

## 使い方

```
/addclaudecommand <コマンド名> [説明文]
```

- `<コマンド名>`: ファイル名になる（例: `mycommand` → `mycommand.md`）
- `[説明文]`: コマンドの一行説明（省略時は空欄のままテンプレート生成）

## 処理内容

### 1. 引数をパース

- 第1引数 → コマンド名（必須）
- 残り → 説明文（任意）

コマンド名が未指定の場合は「コマンド名を指定してください。例: `/addclaudecommand mycommand`」と出力して終了。

### 2. 出力パスを決定

```
<このファイルがある .claude/commands>/<コマンド名>.md
```

ファイルがすでに存在する場合は「`<コマンド名>.md` はすでに存在します。上書きしますか？ [y/N]」と確認してから処理を続ける。

### 3. テンプレートを生成して書き込む

以下のテンプレートを埋めて Write する。`COMMAND_NAME` と `DESCRIPTION` はパースした値に置き換える。

```markdown
# /COMMAND_NAME — DESCRIPTION

（ここにコマンドの目的を1〜2文で書く）

## 使い方

\```
/COMMAND_NAME <必須引数> [オプション]
\```

## 処理内容

1. **引数をパース**
   - （引数の説明）

2. **メイン処理**
   - （処理ステップ）

3. **完了メッセージを出力**
   \```
   ✓ 処理が完了しました
   \```

## ルール

- （守るべきルールを箇条書きで）

## 実行例

\```
/COMMAND_NAME 例1
/COMMAND_NAME 例2 --option
\```
```

### 4. 完了メッセージを出力

```
✓ .claude/commands/<コマンド名>.md を作成しました
次のステップ: ファイルを開いてテンプレートを編集してください
```

最後に `open .claude/commands/<コマンド名>.md` を実行してエディタで開く。

## ルール

- コマンド名はスペースなし・英数字とハイフンのみ（kebab-case 推奨）
- 上書き確認なしにファイルを消さない
- テンプレート内の `\`` はバックティック3つとして扱う（Markdownのエスケープ）

## 実行例

```
/addclaudecommand deploy デプロイフローを実行する
/addclaudecommand check-types TypeScriptの型チェックを走らせる
/addclaudecommand summarize
```