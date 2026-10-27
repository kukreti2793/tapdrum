#!/bin/bash
set -euo pipefail

if [[ "$(uname -s)" != Darwin ]]; then
    echo "TapDrum's app requires macOS 14+ and Xcode. Linux can run only the shared Core tests." >&2
    exit 1
fi
tapdrum_os_version="$(/usr/bin/sw_vers -productVersion)"
if [[ "${tapdrum_os_version%%.*}" -lt 14 ]]; then
    echo "This prototype targets macOS 14 or later. Found macOS $tapdrum_os_version." >&2
    exit 1
fi
tapdrum_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$tapdrum_root"
if ! /usr/bin/xcodebuild -version; then
    echo "Finish Xcode installation and first-launch setup, then select Xcode's developer tools before retrying." >&2
    exit 1
fi
/usr/bin/xcrun swift --version
if /usr/bin/pgrep -x TapDrum >/dev/null; then
    echo "Quit TapDrum before rebuilding the app bundle." >&2
    exit 1
fi
/usr/bin/xcrun swift test --jobs 2
/usr/bin/xcrun swift build --configuration release --product TapDrum --jobs 2
tapdrum_bin_dir="$(/usr/bin/xcrun swift build --configuration release --show-bin-path)"
tapdrum_bundle="$tapdrum_root/.build/TapDrum.app"
mkdir -p "$tapdrum_bundle/Contents/MacOS"
cp "$tapdrum_bin_dir/TapDrum" "$tapdrum_bundle/Contents/MacOS/TapDrum"
cp Resources/Info.plist "$tapdrum_bundle/Contents/Info.plist"
/usr/bin/plutil -lint "$tapdrum_bundle/Contents/Info.plist"
# Ad-hoc signing is for local development, not distribution/notarization.
/usr/bin/codesign --force --sign - --timestamp=none "$tapdrum_bundle"
/usr/bin/codesign --verify --strict "$tapdrum_bundle"
echo "Built local prototype: $tapdrum_bundle"
echo "Open it with: open \"$tapdrum_bundle\""
