#!/usr/bin/env bash
# Builds dist/rus-sh-openai-plugin.zip from openai-plugin/ for platform.openai.com/plugins.
# plugin.json, mcp.json and assets/ sit at the ZIP root, as the OpenAI package guide requires.
#
# Usage: scripts/build-openai-plugin.sh [demo-video-url]
# With a URL, review.demo_recording_url is added to plugin.json inside the ZIP only.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="$repo_root/openai-plugin"
dist_dir="$repo_root/dist"
zip_path="$dist_dir/rus-sh-openai-plugin.zip"
demo_url="${1:-}"

staging_dir="$(mktemp -d)"
trap 'rm -rf "$staging_dir"' EXIT

cp -R "$source_dir/." "$staging_dir/"
find "$staging_dir" -name '.DS_Store' -delete

if [[ -n "$demo_url" ]]; then
  python3 - "$staging_dir/plugin.json" "$demo_url" <<'PY'
import json, sys
path, url = sys.argv[1], sys.argv[2]
if not url.startswith("https://"):
    sys.exit("demo URL must be https://")
with open(path) as f:
    manifest = json.load(f)
manifest["extensions"]["com.openai"]["review"]["demo_recording_url"] = url
with open(path, "w") as f:
    json.dump(manifest, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
fi

for manifest in plugin.json mcp.json; do
  python3 -m json.tool "$staging_dir/$manifest" > /dev/null
done

mkdir -p "$dist_dir"
rm -f "$zip_path"
(cd "$staging_dir" && zip -X -r -q "$zip_path" plugin.json mcp.json assets)
unzip -l "$zip_path"
