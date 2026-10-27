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
| Owner hardware inventory | Partial, owner-reported | M1/2020/8 GB, macOS 26.5.2, iPhone 17 Pro 512 GB, Xcode downloading; remaining details unknown |
| MediaPipe primary sources | Retrieved and inspected | Pinned C++ API/result/graph/README/license; verified HTTPS, source SHA and local content hashes; no model inference run |
| Apple API secondary sources | Retrieved and inspected | .NET bindings corroborate candidate API surfaces only; not SDK or official Apple semantic verification |
| Apple/Google official guide access | Blocked | Proxy tunnel 403 on developer.apple.com, support.apple.com, ai.google.dev; retry after saved draft still blocked |
| GitHub repository API read | Blocked | `gh api repos/kukreti2793/tapdrum` returned Forbidden; this does not establish missing Git authentication |
| Environment network draft save | Confirmed saved | Required research/API domains added; publication required; not applied runtime access |
| Documentation consistency/link checks | Passed | All 16 Markdown files checked; 26 local links resolve; required inventory, fenced blocks, whitespace and documentation-only change scope verified |
| Git commit/push/PR delivery | Pending | Update after actual outcomes; do not assume Git API/push shares read access |

## Not run

No application test suite exists. No Swift build, camera preview, hand inference,
calibration, strike classification, CoreMIDI send/receive, Logic recording/audio
bounce, AU validation, CPU/memory profile, or physical end-to-end latency test was
run. No footage/audio recordings or microphone processing were performed. No
models, application dependencies, or sample libraries were installed.

The 30/50 ms latency goals, accuracy thresholds, resource budgets and planned
milestone acceptance criteria are **unmeasured**. There is no instrument-readiness,
compatibility, publication, or fresh-cloud-task restoration claim.
