# Test and research results

Updated: 2026-10-28. Current scope: M2 camera-only motion feasibility.
New native recognition acceptance pending. Historical evidence is retained below.

## Current recognition experiment validation — 2026-10-28

- **48 Core XCTest cases passed, zero failed/skipped:** existing 25 + nine
  `StrikeDetectorTests` + fourteen `StrikeExperimentTests`. Synthetic cases cover
  rest/hover/lift, approach/reversal, bounded confirmation, repeat/refractory,
  confidence/identity/pose loss and reacquisition, invalid/old/gapped clocks,
  all twelve reference slots, noisy/tiny separation, oblique motion, region and
  perpendicular-motion rejection, simultaneous contacts with stable ordering,
  palm proxy, pause/clear semantics, calibration versions and bounded events.
- **Regression found and fixed:** initial repeat test emitted 23 of 45 synthetic
  taps: cooldown gating discarded the first released sample. Release observation
  now starts immediately while arming still waits for both stable release and
  refractory completion. The 45-hit test passes, with 32-event memory cap. The
  first failed run also exposed an unsafe test force-unwrap after a failed count;
  the test now uses XCTUnwrap and reports a failure instead of crashing.
- **Passed:** Core type-check with Swift 5 mode, strict concurrency complete,
  warnings as errors; native files syntax-parse only. Linux has no Apple SDK.
- **Passed:** Bash syntax for build/run scripts, camera-only plist inspection,
  all 21 Markdown files and 52 local links, and Git diff whitespace checks.
- **Unrun:** updated native build/UI interactions, camera-derived precision/recall,
  contact/hover discrimination, rapid/chord accuracy, resource overhead, physical
  latency, MIDI receiver or Logic tests. Synthetic event counts are not accuracy.
- Baseline remains 720p/30 with raw Vision output unchanged; no inference throttle,
  smoothing, new dependency, microphone, recording or sound output introduced.
- **Delivery verified:** implementation `f59e0ea` pushed on
  `feat/strike-recognition-experiment`; draft PR #4 OPEN/isDraft=true, base
  `feat/fixed-angle-calibration`. Remote main remains `e60421f`; no merge/tag.

## Owner-reported native geometry check — 2026-10-28

Following the calibration branch run instructions, owner reports build/open,
hand alignment, stable both hands, four corners/grid, mirror/resize and area
clearing on Stop all passed. FPS clarified as **30**, not 330; CPU **39.6%** of one
core; PTS age **48.1 ms**, percentile not specified; memory not observed. Exact
commit/build output was not supplied. These are manual spot checks, not an
independent quantitative two-hand/occlusion/soak or contact-to-audio measurement.
Native geometry prerequisite is satisfied for the bounded recognition experiment.

## Historical resume verification — 2026-10-28

- **Passed:** all 25 existing Core XCTest cases, zero failures/skips, rerun on
  checkpoint `6ffa08e` with the retained Swift 6.0.3 Linux toolchain and writable
  caches. No dependency download or application source change was needed.
- **Verified:** local branch `feat/fixed-angle-calibration` matched its GitHub
  remote checkpoint; working tree was clean before the resume documentation.
- **Pending:** owner results for updated native build, overlay registration,
  four-corner clicks, both hands, mirror/resize and calibration invalidation.
  No new camera, strike, MIDI, Logic or physical latency test was performed.
- Environment publication remains unconfirmed; running the retained toolchain
  does not establish a fresh installation or a published snapshot.

## Historical calibration branch validation — before owner retest

- **25 Core XCTest cases passed, 0 failed, 0 skipped:** original 10, six preview
  projection tests and nine playing-area geometry/state tests. The latter cover
  affine/perspective mappings, 25 grid round-trips, both windings, outside points,
  invalid contours, four-click completion/retry/reset and mirrored letterboxed
  click recovery. These are deterministic geometry tests, not labeled vision tests.
- Mac sources syntax-parse. Actual updated Mac build, AppKit image-rectangle
  projection, clicks/guide rendering, mirror/resize and lifecycle invalidation
  remain **unrun**. No raw camera data, model, external package or audio dependency
  added. No resolution/FPS/inference-rate/smoothing change made.
- Calibration is session-only projected 2D geometry. No height, physical contact,
  strike precision/recall, force/velocity, MIDI or audible latency is validated.

Next owner procedure is [CALIBRATION.md](CALIBRATION.md). Do not promote the
successful original runtime or these Core tests to native acceptance of new code.

Calibration branch pushed and draft PR #3 opened against the M1 branch. No merge
or tested milestone tag made. Cloud startup instructions for the retained verified
toolchain and 25 tests were saved and persistence confirmed; no publication/new
restored-task validation or fresh install is claimed.

## Replacement trial reviewed; preview correction awaiting native retest

See [TRIAL_2026_10_27.md](TRIAL_2026_10_27.md). Replacement upload: 29,824,670 bytes,
H.264, 1280×800 screen capture, duration 30.3167 s, no audio stream. Eleven sampled
frames and three full-resolution frames reviewed. Running iPhone 720p/30 preview
observed with cutoff 0.72; persistent vertical skeleton reflection identified.
At 6/18/30 s: ~30 analyzed fps, 0 displayed drops, 1 rejected, 0 Vision failures;
Vision p50 9.5–10.0 ms/p95 14.3–14.6 ms; PTS age p50 52.9–53.3 ms. CPU 42.2–45.1%
of one core; footprint 80.1–80.5 MiB; thermal nominal; last pressure event Warning.
These are sampled rolling displays, not distributions or contact-to-sound timing.

Source correction uses lower-left normalized projection into the actual image
rectangle; native retest pending. Six projection tests added; no model smoothing,
confidence rewriting, resolution reduction or inference throttling. All 16 current
Core XCTest cases passed with 0 failures/skips. No footage or
extracted images committed. Earlier transfer failure below is historical.

## Historical first upload — recording review was blocked

The owner reports running a trial with overlay confidence 0.72 and prefers to keep
the camera at the angle shown in a supplied screen recording. The user requests
review, necessary corrections/calibration, and further progress.

- **Blocked:** the file download tool rejects the .mov as exceeding its 32 MiB
  transfer limit. No local video was retrieved, no frames extracted and no visual
  findings, diagnostics or accuracy measurements are available from it.
- **Owner-reported only:** the live trial occurred. Commit, build/test completion,
  camera/mode, FPS, resource values, alignment and identity stability are unknown;
  do not promote them to independently reviewed passing outcomes.
- **Source inspection:** 0.72 is an overlay display cutoff. Vision continues to
  return its observations; low-scoring points/segments/palm anchors are hidden.
  The value neither calibrates contact geometry nor establishes 72% accuracy.
- **No code change/tests rerun:** evidence does not yet justify a tracking or
  calibration correction. Only project records were updated; existing ten-test
  results remain historical evidence, not new trial validation.

Request a 10–20 second export under 32 MB (for example 720p) that retains the hand
preview, overlay and diagnostics, ideally showing both rest and movement. A few
screenshots can support static alignment review but cannot establish temporal
tracking quality. Do not commit supplied footage or enable a recording feature.

## Historical first Mac build — failed before the later running trial

The owner supplied the output from `./scripts/run-macos.command` on the M1 Mac.
It reports Xcode 26.6 build 17F113, Apple Swift 6.3.3
(`swiftlang-6.3.3.1.3 clang-2100.1.1.101`), an arm64 macOS target and
`MacOSX26.5.sdk`. This is owner-provided execution evidence, not a cloud-native run.

- **Failed:** compilation during `swift test` stopped because
  `AVCaptureSession.Preset.inputPriority` is explicitly unavailable on macOS.
  Eight repeated error messages refer to the same two preset references.
- **Warning:** a non-Sendable shutdown completion was converted to the main
  queue's actor-isolated Sendable block; this warning was repeated four times.
- The final `error: fatalError` is the build failure summary. No Core test counts,
  Release build, app launch, signing or camera validation completed in this log.
- **Source corrected:** removed the preset guard/assignment; retained direct
  `activeFormat`/frame durations. Shutdown completion is explicitly
  `@MainActor @Sendable` through both layers and dispatched once at the pipeline
  boundary. Apple documentation and the pasted SDK header confirm the platform
  mismatch; no checks were disabled or warnings suppressed.
- **Cloud regression:** all ten existing Core XCTest cases passed (0 failed/
  skipped), all eight native source files syntax-parse, and an isolated GCD
  callback handoff type-check passed with `-swift-version 5
  -strict-concurrency=complete -warnings-as-errors` under Swift 6.0.3. The latter
  verifies only the callback contract, not AppKit/AVFoundation or the full app.
- **Unrun:** owner Mac rebuild after this patch. The compiler error/warning are
  addressed in source but their removal on Apple Swift 6.3.3 is not yet confirmed.

Next: update the existing feature checkout with `git pull --ff-only` and rerun
`./scripts/run-macos.command`. No new clone, tool reinstall, cache deletion or
local agent access is required. Raw user build logs/home paths are not committed.

## Historical initial M1 validation — before projection/calibration updates

| Check | Outcome | Evidence / boundary |
| --- | --- | --- |
| Official Linux Swift toolchain | Verified and usable | Swift 6.0.3 Ubuntu 24.04 x86_64 archive used on Debian 13 cloud; detached release signature verified, expected fingerprint `52BB7E3DE28A71BE22EC05FFEF80A866B47A981F`; official Swift website repository keys over HTTPS |
| Core build and tests | **10 XCTest cases passed, 0 failed, 0 skipped** | Five observation/topology/confidence/palm/coordinate tests, five timing/freshness/statistics/cadence/CPU tests. Swift Testing footer separately reports zero tests; it is not the XCTest suite |
| Native source syntax | Passed parse only | `swiftc -frontend -parse Sources/TapDrumApp/*.swift`; does not type-check Apple frameworks, SwiftUI or Darwin APIs |
| App property list | Parsed and inspected | Python plistlib; bundle executable and macOS 14 floor match, camera purpose present, no microphone/library permission declaration |
| Build/run shell scripts | Syntax check passed | `bash -n scripts/build-macos.sh scripts/run-macos.command`; not a native build/signing test |
| Linux platform guard | Expected refusal verified | Build script exits 1 with macOS requirement, creates no fake `.app` bundle; this is expected behavior, not a native test failure |
| Documentation validation | Passed | All 18 Markdown files and 39 local links checked; fences/newlines/whitespace valid; tracked diff whitespace check clean |
| Installer repeatability on current cache | Passed | Helper reverified release fingerprint, reused installed toolchain and ran all ten tests; no fresh restored instance tested |
| Swift cache setup | Initial setup failure resolved | Default compiler cache pointed outside writable roots. Supported cache/module/config/security paths moved to cloud scratch; tests then built and passed without changing HOME |
| Reusable environment config | start_skill saved; installer draft rejected | Full installer/start draft received `ASB rejected the draft request`, no detailed reason and no save. Subsequent retained-toolchain startup-only draft saved successfully; no install_script or publication claim |
| Native compile/capture/preview | **Owner compile failed; patched-source rebuild pending** | Failure and SDK details above. Linux still excludes the app target; app launch/camera tests remain unrun |
| Tracking quality/resource values | **Unmeasured** | Preview alignment, chirality/mirroring, permissions/reconnection, Vision throughput, Mach CPU/footprint calls, thermal/pressure and soak tests require owner checklist |
| M1 Git review delivery | Draft PR #2 opened | Feature branch pushed; stacked on unmerged M0 branch for focused review. No merge or accepted milestone tag; source/doc commits remain reviewable |

Core command was run from `/workspace/tapdrum` with the retained Swift toolchain
and writable compiler/module/config/security caches described in
[BUILD_AND_RUN.md](BUILD_AND_RUN.md). Tests exited zero with all ten intended
XCTest cases executed. They do not test real camera frames or native integrations.

M1 remains unaccepted. There are no strike, MIDI, Logic, audio or AU implementations
to validate, and no physical contact→sound latency claim. No microphone, footage
recording or retained raw landmark trajectories were used. No paid macOS CI run
or native build is implied by this report.

## Historical Milestone 0 observations

| Check | Outcome | Evidence / limit |
| --- | --- | --- |
| Initial local Git inspection | Observed empty/unborn checkout | No HEAD, files, local refs or changes at initial inspection |
| Initial remote Git read | Succeeded, then remote was empty | Authenticated read returned no refs; no token request needed |
| Later remote read/fetch | Passed | Owner README commit `e60421f8e60815828a83a9ee12a8f63fc074476f` on main; fetched and based feature branch on it |
| Existing work preservation | Passed at branch creation | Clean working tree before switching; README retained/expanded |
| Runtime identification | Observed | Linux x86_64; `swift` and `xcodebuild` absent from PATH; not a target Mac |
| Owner hardware inventory | Owner-reported, native checks pending | M1/2020/8 GB, macOS 26.5.2, Logic 10.7.2, Xcode 26.6, iPhone 17 Pro 512 GB/iOS 26.6.2, original data cable; mount and active SDK not checked |
| MediaPipe primary sources | Retrieved and inspected | Pinned C++ API/result/graph/README/license; verified HTTPS, source SHA and local content hashes; no model inference run |
| Apple API secondary sources | Retrieved and inspected | .NET bindings corroborated candidate surfaces; subsequently superseded for core findings by direct Apple documentation |
| Apple official source access | Initially blocked, later succeeded | Vision, camera formats/late-frame handling/Continuity/privacy, CoreMIDI direction/timestamps, AU lifecycle/state, Logic MIDI/bounce and Xcode support pages retrieved and relevant sections inspected |
| Xcode/macOS documentation match | Documented host-range match, not execution | Xcode 26.6 row lists host macOS 26.2–26.x, macOS 26.5 SDK and Swift 6.3; owner-reported OS is inside that range |
| Google official guide access | Still blocked at latest check | ai.google.dev guide returned proxy tunnel 403; primary MediaPipe repository sources were accessible |
| GitHub repository API read | Initial REST read failed | `gh api repos/kukreti2793/tapdrum` returned Forbidden; later PR creation/read worked without new credentials |
| Environment network draft save | Confirmed saved | Research/API domains added, package-manager preset preserved; publication required and not performed. Later runtime access was independently tested |
| Documentation consistency/link checks | Passed | All 16 Markdown files checked; 26 local links resolve; required inventory, fenced blocks, whitespace and documentation-only change scope verified |
| Git commit/push/PR delivery | Passed for initial documentation delivery | Commit `6f362cd` pushed to feature branch; draft PR #1 created and queried OPEN/isDraft=true, base main, head docs/milestone-0-feasibility. Follow-up documentation records the later source/version findings |
| Main branch preservation | Verified at PR check | Remote main remained `e60421f8e60815828a83a9ee12a8f63fc074476f`; no merge, force push or branch deletion |

## Historical Milestone 0 unrun checks

At M0 no application test suite existed. No Swift build, camera preview, hand inference,
calibration, strike classification, CoreMIDI send/receive, Logic recording/audio
bounce, AU validation, CPU/memory profile, or physical end-to-end latency test was
run. No footage/audio recordings or microphone processing were performed. No
models, application dependencies, or sample libraries were installed.

The 30/50 ms latency goals, accuracy thresholds, resource budgets and planned
milestone acceptance criteria are **unmeasured**. There is no instrument-readiness,
compatibility, publication, or fresh-cloud-task restoration claim.
