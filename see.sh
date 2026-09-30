#!/data/data/com.termux/files/usr/bin/bash
# see.sh — scan semua file .lua, output 0 (kosong) atau 1 (ada isi)
# usage: ./see.sh

DIR="${1:-.}"

find "$DIR" -type f -name "*.lua" | sort | while read f; do
    s=$(wc -c < "$f" | tr -d ' ')
    if [ "$s" -gt 0 ]; then
        printf "1  %s\n" "$f"
    else
        printf "0  %s\n" "$f"
    fi
done

echo ""
echo "=== ringkasan ==="
TOTAL=$(find "$DIR" -type f -name "*.lua" | wc -l | tr -d ' ')
EMPTY=$(find "$DIR" -type f -name "*.lua" -size 0 | wc -l | tr -d ' ')
FILLED=$((TOTAL - EMPTY))
echo "total   : $TOTAL"
echo "ada isi : $FILLED"
echo "kosong  : $EMPTY"
