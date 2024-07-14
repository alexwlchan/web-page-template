#!/usr/bin/env bash
# This script creates an Alfred snippet bundle that expands my HTML template
# when I type the shortcut `!html`.

set -o errexit
set -o nounset

KEYWORD="!html"

ROOT=$(git rev-parse --show-toplevel)

pushd $(mktemp -d)
  cat > info.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>snippetkeywordprefix</key>
	<string></string>
	<key>snippetkeywordsuffix</key>
	<string></string>
</dict>
</plist>
EOF

  # Get the HTML template as a JSON-escaped string
  snippet=$(jq -R -s '.' < "$ROOT/index.html")

  # This is an arbitrary choice of ID; it just has to be used consistently
  snippet_id="$(uuidgen)"

  cat > "$snippet_id.json" <<EOF
{
    "alfredsnippet": {
        "snippet": $snippet,
        "uid": "$snippet_id",
        "name": "HTML template",
        "keyword": "$KEYWORD"
    }
}
EOF

  zip "HTML template.alfredsnippets" "info.plist" "$snippet_id.json"
  open "HTML template.alfredsnippets"
popd
