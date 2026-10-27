# Hardware inventory and owner-assisted checks

Last updated: 2026-10-27. These checks collect version/setup facts, not secrets.
No camera or microphone recording is requested or authorized.

## Known facts and remaining answers

| Item | Status / provenance |
| --- | --- |
| Computer | Owner reports MacBook Pro M1, 2020, 8 GB memory |
| macOS | Owner reports **26.5.2**; exact version/build not independently inspected |
| Xcode | Owner's build output confirms 26.6 build 17F113, Apple Swift 6.3.3, MacOSX26.5 SDK and arm64 target. Compilation started but failed on an application API error; corrected source awaits rebuild |
| Logic Pro | Owner reports 10.7.2; operation on the reported macOS and integration not verified |
| iPhone | Owner reports iPhone 17 Pro, 512 GB |
| iOS | Owner reports 26.6.2; actual Continuity operation not verified |
| USB connection | Owner has the original iPhone data cable; wired operation/trust and measured latency unverified |
| Camera placement | Mount/angle and ability to see both hands/table unknown |
| Audio output | Built-in/wired/interface path, sample rate and Logic buffer unknown |
| Privacy | **Camera-only first; no recordings.** No microphone access or video/audio capture-to-disk experiments authorized |
| Cloud | Observed Linux x86_64, no `swift` or `xcodebuild` on PATH; cannot validate native APIs/Logic |

## H0: version checks (before architecture finalization)

Logic/iOS/Xcode versions and the cable have now been supplied; do not repeatedly
ask for them. The first native compiler output now confirms the installed active
Xcode/compiler/SDK; the read-only commands below remain available if those tools
change. The remaining setup question is camera mounting/angle, plus a successful
native rebuild after correcting the capture preset error. No Apple account
credentials or device serial numbers are needed.

Apple's retrieved Xcode support table lists Xcode 26.6 as hosted on macOS Tahoe
26.2–26.x, with the macOS 26.5 SDK and Swift 6.3 compiler. The owner's reported
macOS falls within that documented host range. This is a documentation match,
not proof the installed Xcode works or that Logic 10.7.2 works on this macOS.
Do not upgrade/downgrade the owner's tools without discussing a demonstrated need.

Apple lists Continuity Camera webcam requirements as macOS Ventura 13+, iOS 16+
and iPhone XR or later, plus a shared Apple Account with two-factor authentication,
nearby devices with Wi-Fi/Bluetooth enabled, and USB trust for wired operation.
Reported hardware/OS meet the stated version baseline; account/configuration and
actual video capture still need live verification. Never request account secrets.

If comfortable using Terminal on the Mac, these read-only checks can supply the
exact OS and active toolchain details:

```sh
sw_vers
uname -m
xcode-select -p
xcodebuild -version
xcrun --sdk macosx --show-sdk-version
```

Run them separately; report errors as well as successes. `xcodebuild` before
installation/first-run setup may fail. Do not switch tools, install beta SDKs,
upgrade macOS/Logic, or change system privacy settings merely to silence an error.
We will select a compatible stable toolchain using the reported versions.

## After approval: live camera checks (Milestone 1)

1. Use a stable mount with both hands and the playing area visible. Avoid placing
   the phone where taps can knock it over. Try an oblique view as well as overhead.
2. Enumerate device formats in the future prototype; record advertised resolution
   and frame-rate ranges and actual received frame intervals. Do not assume 60 fps.
3. Compare built-in, wired iPhone and wireless iPhone only when available; use the
   same camera view, lighting and settings where possible. Confirm the operating
   connection rather than assuming a cable automatically selects wired transport.
   Apple's guide confirms wired and wireless operation, but gives no measured
   guarantee that either meets TapDrum's latency targets. Disable or account for
   framing/effects that alter calibration; do not assume camera images are fixed.
4. Test permissions, switching, occlusion and camera loss. Preview mirroring must
   not change which anatomical hand is labeled left/right.
5. Keep microphone and recording features off/absent. Report numerical counters
   and observations, not footage. Review any later request for recordings separately.

## After MIDI approval: Logic checks (Milestone 4)

Use an existing drum software instrument with a known note map. Use built-in or
wired output first; Bluetooth adds an unrelated output-latency variable. Report
the actual audio device, sample rate, I/O buffer size, low-latency mode and test
project load. Record a short editable MIDI pattern, inspect notes and velocities,
play it back, and bounce it to audio. Those steps require a future working app;
they have **not** been performed. Detailed L1 procedure is in
[TEST_PLAN.md](TEST_PLAN.md).
