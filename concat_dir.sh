#!/bin/sh
# 指定ディレクトリ内のテキストファイルを新しい順に結合して1ファイルに出力
# 使い方: sh concat_dir.sh <ディレクトリ> <拡張子>
# 例: sh concat_dir.sh ./notes .txt

if [ $# -lt 2 ]; then
    echo "使用法: $(basename "$0") <ディレクトリ> <拡張子>"
    echo "例: $(basename "$0") ./notes .txt"
    exit 1
fi

dir="${1%/}"
ext="$2"

if [ ! -d "$dir" ]; then
    echo "エラー: '$dir' はディレクトリが見つかりません"
    exit 1
fi

outfile="$(basename "$dir")${ext}"
rm -f "$outfile"

ls -1t "$dir" | while IFS= read -r fname; do
    fpath="$dir/$fname"
    [ -f "$fpath" ] && file "$fpath" | grep -q "text" || continue
    cat "$fpath" >> "$outfile"
    printf '  + %s\n' "$fname"
done

echo "→ $outfile"
