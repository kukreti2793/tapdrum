# Build and run the Milestone 1 prototype

Status: implemented source; the first owner-run Mac build failed on an unsupported
capture preset. Corrected source awaits native rebuild. Launch/camera tests remain
unrun. Linux checks are not evidence the Mac app has passed; no prebuilt release.

## Continuing after the first compile error

The owner shares build output here and runs only the specific commands needed;
local agent/terminal access is not required. The initial `.inputPriority` compiler
error came from a macOS-unavailable capture preset in our code. Its source fix
removes the preset and preserves direct camera-format configuration. The shutdown
completion warning is also addressed with explicit actor/sendability annotations.
After that fix is pushed, update the existing feature checkout and retry:

```sh
git pull --ff-only
./scripts/run-macos.command
```

Run these inside `tapdrum-m1`. A fast-forward failure should be reported without
resetting local changes. No re-clone, dependency reinstall or cache deletion is
required for this source correction. Successful native compilation is still
unconfirmed; return the next result before testing live camera behavior.

## On the owner's Mac

Requirements: macOS 14+, Apple Silicon is the initial test target, and completed
Xcode installation/first launch with its active command-line tools. Owner reports
Xcode 26.6 on macOS 26.5.2. The package uses Swift tools 5.9 and Swift 5 language
mode; no third-party packages, ML model downloads or sample libraries are needed.

Use the `feat/milestone-1-hand-tracking` branch. If you do not already have a local
checkout, these commands create a **new** directory; do not overwrite existing work:

```sh
git clone --branch feat/milestone-1-hand-tracking https://github.com/kukreti2793/tapdrum.git tapdrum-m1
cd tapdrum-m1
./scripts/run-macos.command
```

For an existing checkout, preserve local changes, fetch the branch and switch to
it using your normal Git workflow. Run the script from that checkout. You can
also open `Package.swift` in Xcode for editing. Use the packaged app for camera
testing so macOS can read its bundle identity and camera purpose description;
`swift run` or an Xcode package-executable launch is not the supported TCC path.

The script:

1. Checks macOS/Xcode and refuses to replace a running TapDrum bundle.
2. Runs the Core unit tests, then builds the native executable in Release mode
   using at most two build jobs for the 8 GB Mac.
3. Creates `.build/TapDrum.app` with the camera-only `Info.plist`, applies a local
   ad-hoc signature, verifies that signature, and opens it.

You do not need a paid developer signing identity for this local development
procedure. It is not distribution signing/notarization. Rebuilding may cause
macOS to ask for camera permission again. Quit TapDrum before another rebuild.

To build without opening, use `./scripts/build-macos.sh`. If Xcode setup or the
native compile fails, keep the first error and surrounding output and send it
back; do not disable verification, reset privacy globally, or upgrade tools just
to suppress an unexplained failure.

## First launch

Choose the built-in camera first, preferably 1280×720 at 30 fps when advertised,
then click **Start camera**. Allow camera access in macOS's prompt. If denied,
use the gear button to open Camera privacy settings, enable TapDrum as appropriate,
then retry. Enumeration alone does not start capture; no microphone is requested.

To switch camera or mode, press **Stop**, make the selection, then **Start camera**.
Only advertised format/rate combinations are shown, with duplicate size/rate
choices collapsed to the first advertised native format. The default prefers
720p/30 fps. A camera advertising 60 fps is not a guarantee the analysis sustains
60 fps. Pixel processing prefers NV12 and falls back to BGRA only if needed.

Use landscape orientation with the preview upright. Arbitrary phone rotation
during capture is outside this first prototype; stop/reposition/restart if needed.
Mirror affects the preview, not the unmirrored Vision input or anatomical labels.
The overlay uses AVFoundation's preview coordinate conversion to account for
letterboxing/mirroring. Verify alignment on your real camera; this is untested.

For iPhone: use a stable mount, lock it with the rear camera unobstructed, check
Continuity Camera prerequisites, and connect the original data cable/trust the
Mac for the wired trial. A connected cable alone does not prove wired transport.
Do not assume higher FPS or lower latency than the built-in camera. Automatic
framing/effects can change the image; disable or account for them during tests.
No iPhone app or iOS project is required for this Continuity Camera prototype.

Green/orange identify estimated left/right hands; unknown handedness remains
unknown. Finger labels identify the model's landmarks. The dashed palm ring is
derived from five confident anchors, **not** a measured contact patch. Confidence
is the mean of returned joint confidences; it is not strike confidence. There are
no persistent hand IDs or cross-frame identity guarantees yet.

Diagnostics show analyzed sample cadence, counts/drops/rejections/failures, rolling
Vision p50/p95, clock-converted presentation-timestamp-to-callback age when valid,
app CPU/physical footprint, thermal state and latest memory-pressure event. A dash
means unavailable. CPU 100% is one full core. Quantiles use nearest rank over the
latest 240 valid samples, so the p50 of two samples is the lower one. These are
not physical exposure/contact-to-audio measurements. No sound is produced.

Camera interruption/disconnection stops the run with a message; reconnect and
restart explicitly. Stale landmarks are rejected using a 250 ms freshness limit,
evaluated on UI refresh and a 250 ms timer. With a responsive main thread a silent
camera can therefore take up to roughly 500 ms to clear; this is not a hard
real-time guarantee. Normal successful frames update the overlay up to 10 Hz.

## Tests and cloud limitations

On a Mac with a supported Swift toolchain, run `swift test --jobs 2`. The build
script does this before building the app. Tests cover shared observation validity,
anatomical joint topology, confidence/palm rules, timestamp ordering/freshness,
bounded numerical statistics, dropped-frame cadence and CPU delta calculations.
They do not instantiate cameras, AppKit, Vision, Mach metrics, or Logic.

The cloud toolchain resides outside the checkout:

```sh
export PATH="/workspace/scratch/tapdrum-toolchain/swift-6.0.3-RELEASE-ubuntu24.04/usr/bin:$PATH"
export CLANG_MODULE_CACHE_PATH=/workspace/scratch/tapdrum-clang-cache
export SWIFTPM_MODULECACHE_OVERRIDE=/workspace/scratch/tapdrum-swift-modules
swift test --scratch-path .build/linux --cache-path /workspace/scratch/tapdrum-swift-cache --config-path /workspace/scratch/tapdrum-swift-config --security-path /workspace/scratch/tapdrum-swift-security --jobs 2
```

The official 783,919,592-byte Linux archive was verified with the Swift 6.x release
signature, fingerprint `52BB7E3DE28A71BE22EC05FFEF80A866B47A981F`, using keys from the
official `swiftlang/swift-org-website` repository over HTTPS. Archive plus expanded
toolchain occupy about 3.3 GB in cloud scratch. This toolchain is not part of the
Mac app and does not provide Apple SDKs. A Linux `swift test` run cannot type-check
the native target. Syntax-only parsing is recorded separately in test results.

Complete [the live checklist](MILESTONE_1_CHECKLIST.md) before accepting Milestone
1 or requesting Milestone 2. No camera/audio recordings are needed or authorized.
