# Milestone 1 — owner-assisted native acceptance

Status: **not executed**. Approval to implement has been received; acceptance and
permission to advance have not. This is camera-only with no recordings, no
microphone, no MIDI, and no contact detection. Please send observations/numbers
and errors as text. Do not save video/audio or raw landmark trajectories.

## First useful check

1. Follow [BUILD_AND_RUN.md](BUILD_AND_RUN.md) using the feature branch. Note the
   commit (`git rev-parse --short HEAD`), `sw_vers`, `xcodebuild -version` and
   `xcrun --sdk macosx --show-sdk-version` outputs. The script should run 10 Core
   tests, finish a native Release build, verify the local signature, and open TapDrum.
2. Choose the built-in camera and start. Check that macOS asks only for Camera.
   After allowing it, confirm live preview and landmark alignment with one hand,
   then both hands. Check the finger names and each anatomical hand label.
3. After about a minute, report camera/mode, analyzed FPS, Vision p50/p95,
   PTS→callback p50/p95 or unavailable, dropped/rejected/failure counts, CPU,
   footprint, thermal/pressure values and whether tracking looks stable.

If build/startup fails, send the first meaningful error and surrounding output.
Do not treat a syntax check or the Core tests as successful native acceptance.

## Required C1/V1 follow-up

| Check | Procedure | Result to report |
| --- | --- | --- |
| Permission denial/recovery | Deny camera once if practical, inspect the message/settings action, enable it and retry | No crash; clear recovery; camera-only prompt |
| Formats and switching | Stop, change mode/device, restart; try only advertised 30/60 fps choices | Actual available modes, delivered cadence, clean restart and counters reset |
| Mirroring/alignment | Turn mirroring on/off; resize the window; move fingers to edges | Skeleton/finger labels stay on the same image features; anatomical labels remain correct |
| Tracking loss | Hide each hand, occlude tips, cross hands, then return | Old landmarks clear, no persistent ghost hand; identity errors and unusable contacts reported |
| Silent/interrupted camera | Pause/unlock/disconnect iPhone or interrupt capture | Clear error or stale-frame banner, landmarks clear, reconnect/restart works |
| Shutdown | Stop capture, restart, then quit/close last window during capture | Camera closes; app exits; no hang or post-stop overlays |
| Wired iPhone | Use stable landscape mount and original data cable/trust setup, repeat baseline | Detection/format availability, mount/angle, stable connection and diagnostics; do not infer latency superiority |
| Wireless iPhone | Only if available, compare same mode/view/lighting | Separate results; unavailable is a reported limitation |
| Resources/soak | Ten minutes per candidate mode, then 30 minutes on chosen mode; optionally compare a fixed Logic project open | Peak/steady footprint, CPU convention, thermal/memory-pressure changes, errors/drops/overloads |

For controlled tracking assessment, observe 60 seconds each of spread hands,
slow articulation and crossing in ordinary lighting and the intended tabletop
pose. Suggested target remains ≥95% usable visible frames with no unexplained
anatomical swaps; exact frame-level accuracy is not certified by casual live
observation without independent labels. Report live usability observations as
qualitative or preliminary, and mark exact percentages unverified if unscorable.

The implemented UI shows rolling numerical metrics, not a stored vision dataset
or cumulative per-joint accuracy score. Strict frame-level accuracy, true sensor
FPS, physical exposure latency and contact→sound latency remain unverified. Do
not claim the full tracking gate from a moving preview alone. Review the evidence
and any measurement limitations with the owner before advancing.

## Response template

```text
Commit / macOS build / active Xcode and SDK:
Build and 10 Core tests: passed / failed (first error)
Camera, mode, landscape angle/mount, wired/wireless confirmed or unknown:
Both hands / finger labels / mirror and resize alignment:
Tracking loss / crossing / disconnect / restart / quit observations:
Analyzed fps / Vision p50,p95 / PTS→callback p50,p95 or unavailable:
Dropped / rejected / Vision failures and run duration:
App CPU / peak footprint MiB / thermal / memory-pressure event:
Logic workload if open / audio overloads if observed:
Limitations and other errors:
```
