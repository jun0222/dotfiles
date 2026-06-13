# /marp — Marp スライド生成

指定したトピックでMarpプレゼンテーションを生成する。

## 使い方

```
/marp <トピック> [--slides N] [--theme default|gaia|uncover|custom] [--out ファイル名]
```

## 処理内容

以下の手順でMarpスライドを生成・出力してください。

1. **引数をパース**
   - トピック（必須）
   - `--slides N`：スライド数（デフォルト: 8）
   - `--theme <name>`：テーマ（デフォルト: default）
   - `--out <file>`：出力ファイルパス（デフォルト: `./marp/output/<トピックをsnake_case>.md`）

2. **フロントマターを生成**
   ```yaml
   ---
   marp: true
   theme: <theme>
   paginate: true
   header: "<トピック>"
   footer: "© $(date +%Y)"
   ---
   ```

3. **スライド構成を考えて生成**
   - 1枚目: タイトルスライド（`_class: lead`）
   - 中間: 内容スライド（箇条書き・コード・表を適切に使う）
   - 最後: まとめスライド

4. **ファイルに書き出す**（`--out` で指定したパス）

5. **出力後に以下を表示**
   ```bash
   # プレビュー（ウォッチモード）
   marp --watch <file>

   # PDF出力
   marp --pdf <file>

   # HTML出力
   marp <file>
   ```
   
6. ユーザーの確認を楽に

最後にcliにて `open ./marp/output` を実行し、ユーザーが結果を簡単に確認できるようにする

## ルール

- 日本語で書く（トピックが英語でも）
- 1スライド1メッセージを意識してシンプルに
- コードブロックや表を積極的に使う
- `---` でスライドを区切る
- ディレクティブは `<!-- _key: value -->` 形式

## 参考ファイル

- サンプル: `marp/sample.md`
- カスタムテーマ: `marp/themes/custom.css`（`--theme ./marp/themes/custom.css` で使用）

## 実行例

```
/marp Gitブランチ戦略 --slides 10 --theme gaia
/marp Docker入門 --out ./marp/docker.md
/marp APIデザイン --theme ./marp/themes/custom.css --slides 12
```