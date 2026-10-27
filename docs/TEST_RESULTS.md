# Test and research results

Date: 2026-10-27. Scope: Milestone 0 documentation/research only.

## Executed observations

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

## Not run

No application test suite exists. No Swift build, camera preview, hand inference,
calibration, strike classification, CoreMIDI send/receive, Logic recording/audio
bounce, AU validation, CPU/memory profile, or physical end-to-end latency test was
run. No footage/audio recordings or microphone processing were performed. No
models, application dependencies, or sample libraries were installed.

The 30/50 ms latency goals, accuracy thresholds, resource budgets and planned
milestone acceptance criteria are **unmeasured**. There is no instrument-readiness,
compatibility, publication, or fresh-cloud-task restoration claim.
