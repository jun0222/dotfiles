---
marp: true
theme: default
paginate: true
header: "Marp サンプル"
footer: "© 2026"
style: |
  section {
    font-family: 'Helvetica Neue', Arial, sans-serif;
  }
  section.lead {
    text-align: center;
  }
  .columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }
---

<!-- _class: lead -->
<!-- _paginate: false -->

# Marp サンプルスライド

Markdown でプレゼンを作る

---

## 基本構造

- `---` でスライドを区切る
- `<!-- _directive -->` でスライド単位の設定
- フロントマターで全体設定

```markdown
---
marp: true
theme: default
paginate: true
---

# スライド 1

---

# スライド 2
```

---

## テーマ一覧

| テーマ名 | 特徴 |
|---------|------|
| `default` | シンプルな白背景 |
| `gaia` | ダークモード対応 |
| `uncover` | ミニマルデザイン |

テーマ変更: フロントマターで `theme: gaia`

---

<!-- _backgroundColor: #1a1a2e -->
<!-- _color: #eee -->

## ダーク背景スライド

`_backgroundColor` と `_color` で1枚だけ色を変える

```markdown
<!-- _backgroundColor: #1a1a2e -->
<!-- _color: #eee -->
```

> 先頭に `_` を付けると **そのスライドだけ** に適用

---

## 2カラムレイアウト

<div class="columns">
<div>

### 左カラム

- 項目 A
- 項目 B
- 項目 C

</div>
<div>

### 右カラム

```python
def hello():
    print("Hello, Marp!")
```

</div>
</div>

---

## 画像の配置

```markdown
<!-- 背景画像 -->
![bg](./image.jpg)

<!-- 右半分に画像 -->
![bg right:40%](./image.jpg)

<!-- フィット・カバー -->
![bg fit](./image.jpg)
![bg cover](./image.jpg)
```

---

## よく使うディレクティブ

```markdown
<!-- グローバル（フロントマターに書く） -->
theme: gaia
paginate: true
header: "ヘッダー"
footer: "フッター"
size: 16:9       # or 4:3

<!-- スライド単位（先頭に _ を付ける） -->
<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _backgroundColor: #000 -->
<!-- _color: #fff -->
```

---

<!-- _class: lead -->

## CLI コマンド

```bash
# HTML に変換
marp slide.md

# PDF に変換
marp --pdf slide.md

# PNG 画像に変換
marp --images png slide.md

# ウォッチモード（ライブプレビュー）
marp --watch slide.md

# サーバーモード
marp --server .

# カスタムテーマを使う
marp --theme ./themes/custom.css slide.md
```

---

## まとめ

1. **Markdown** で書けるので Git 管理しやすい
2. **テーマ**で見た目を統一
3. **ディレクティブ**で柔軟にカスタマイズ
4. **CLI** で HTML / PDF / PNG に出力

> VS Code 拡張 `marp-team.marp-vscode` でリアルタイムプレビュー可能