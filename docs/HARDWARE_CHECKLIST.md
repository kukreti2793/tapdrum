# Hardware inventory and owner-assisted checks

Last updated: 2026-10-27. These checks collect version/setup facts, not secrets.
No camera or microphone recording is requested or authorized.

## Known facts and remaining answers

| Item | Status / provenance |
| --- | --- |
| Computer | Owner reports MacBook Pro M1, 2020, 8 GB memory |
| macOS | Owner reports **26.5.2**; exact version/build not independently inspected |
| Xcode | Owner is downloading it; installed version, first launch and SDK pending |
| Logic Pro | Installed version not supplied; compatibility not verified |
| iPhone | Owner reports iPhone 17 Pro, 512 GB |
| iOS | Version not supplied; Continuity availability not verified |
| USB connection | Data-capable cable availability and wired operation unknown |
| Camera placement | Mount/angle and ability to see both hands/table unknown |
| Audio output | Built-in/wired/interface path, sample rate and Logic buffer unknown |
| Privacy | **Camera-only first; no recordings.** No microphone access or video/audio capture-to-disk experiments authorized |
| Cloud | Observed Linux x86_64, no `swift` or `xcodebuild` on PATH; cannot validate native APIs/Logic |

## H0: version checks (before architecture finalization)

Please report the Logic Pro version from **Logic Pro → About Logic Pro**, and the
iOS version from **Settings → General → About**. Once Xcode finishes downloading,
open it to complete Apple's normal first-run setup and report its version from
**Xcode → About Xcode**. Report whether a USB data cable and stable phone mount
are available. No Apple account credentials or device serial numbers are needed.

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
