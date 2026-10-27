# Test and research results

Date: 2026-10-27. Current scope: approved Milestone 1 source implementation;
native Mac acceptance pending. Historical M0 research evidence is retained below.

## Milestone 1 — executed validation

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
| Native compile/capture/preview | **Unrun — Mac required** | App target deliberately excluded from Linux package; no xcodebuild or macOS SDK here |
| Tracking quality/resource values | **Unmeasured** | Preview alignment, chirality/mirroring, permissions/reconnection, Vision throughput, Mach CPU/footprint calls, thermal/pressure and soak tests require owner checklist |

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
