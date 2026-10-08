#!/usr/bin/env bash
# Obsidian 보관함을 Apple 메모처럼 보이게 하고 Apple Notes Sync를 깐다.
# usage: ./install.sh <vault-path> [--no-sync]
set -euo pipefail

VAULT="${1:?usage: ./install.sh <vault-path> [--no-sync]}"
SYNC=1; [[ "${2:-}" == "--no-sync" ]] && SYNC=0
HERE="$(cd "$(dirname "$0")" && pwd)"
OBS="$VAULT/.obsidian"
PLUGIN_REPO="coddingtonbear/obsidian-apple-notes"

[[ -d "$OBS" ]] || { echo "Obsidian 보관함이 아닙니다: $VAULT (.obsidian 없음)"; exit 1; }
command -v node >/dev/null || { echo "Node.js가 필요합니다: brew install node"; exit 1; }
if pgrep -xq Obsidian; then
  echo "Obsidian을 먼저 종료하세요. 켜져 있으면 설정을 덮어씁니다."; exit 1
fi

mkdir -p "$OBS/snippets"
cp "$HERE"/snippets/*.css "$OBS/snippets/"

if (( SYNC )); then
  command -v icloud-md >/dev/null || npm install -g icloud-md
  P="$OBS/plugins/icloud-notes"; mkdir -p "$P"
  for f in main.js manifest.json styles.css; do
    curl -fsSL "https://github.com/$PLUGIN_REPO/releases/latest/download/$f" -o "$P/$f"
  done
fi

# 기존 설정은 유지하고 필요한 키만 합친다.
SYNC=$SYNC node - "$OBS" <<'JS'
const fs = require('fs'), path = require('path');
const dir = process.argv[2];
const edit = (name, fallback, fn) => {
  const f = path.join(dir, name);
  const v = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f, 'utf8')) : fallback;
  fs.writeFileSync(f, JSON.stringify(fn(v) ?? v, null, 2) + '\n');
};
const addAll = (arr, items) => [...new Set([...(arr || []), ...items])];
edit('appearance.json', {}, a => {
  a.baseFontSize = 14;
  a.accentColor = '#e2a400';
  a.translucency = false;
  a.enabledCssSnippets = addAll(a.enabledCssSnippets, ['apple-notes', 'apple-notes-headings']);
});
edit('app.json', {}, a => { a.readableLineLength = false; });
if (process.env.SYNC === '1') {
  edit('community-plugins.json', [], p => addAll(p, ['icloud-notes']));
  const data = path.join(dir, 'plugins/icloud-notes/data.json');
  if (!fs.existsSync(data)) edit('plugins/icloud-notes/data.json', { folder: 'Apple Notes' }, () => {});
}
JS

echo "완료. Obsidian을 열고:"
(( SYNC )) && echo "  1. 설정 → 커뮤니티 플러그인 → '제한 모드 끄기' (처음 한 번)" \
           && echo "  2. 설정 → Apple Notes Sync → Connect 로 iCloud 로그인"
echo "  스니펫은 설정 → 외관 → CSS 스니펫에서 켜고 끌 수 있습니다."
