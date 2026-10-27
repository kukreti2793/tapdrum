# Known issues and open questions

All items are open unless explicitly resolved. The replacement M1 trial recording
was reviewed: native preview is running but its overlay is vertically reflected.
Source correction needs a native retest. This single-hand clip does not establish
full tracking/contact acceptance.

| ID | Kind | Issue / next action |
| --- | --- | --- |
| K-01 | Research risk | Monocular contact/hover separation unproven; run controlled S1 only after M1 and approval |
| K-02 | Performance risk | Camera transport and reversal confirmation may exceed latency goals; measure rather than promise |
| K-03 | Hardware prerequisite | Xcode/compiler/SDK evidenced; original iPhone runtime and fixed oblique view now seen. Updated native build, mount stability, camera transport and Logic operation remain unverified |
| K-04 | Environment limitation | Cloud is Linux without Apple SDKs/Logic/cameras; native compatibility and hardware validation require Mac |
| K-05 | Research access | Initial Apple block resolved in subsequent requests; official Google guide still blocked. Apple APIs and MediaPipe primary source reviewed; draft settings saved, publication not performed |
| K-06 | Privacy/measurement constraint | Camera-only/no-recordings chosen. Precise event truth and contact→audible latency lack an approved independent measurement method; do not claim them verified |
| K-07 | Tracking risk | Occluded tips, coupled fingers, palm proxy and hand-ID swaps unresolved; score all contacts separately |
| K-08 | Approval gate | M1 corrections and bounded M2 playing-area foundation authorized by trial request. Native alignment/area/strike acceptance open; no MIDI/plugin advancement or merge approval |
| K-09 | Integration risk | MIDI collisions, cleanup, Logic routing, instrument mapping and host lifecycle untested |
| K-10 | Dependency risk | MediaPipe native macOS packaging/acceleration, exact model size/license and resource cost unverified; not installed |
| K-11 | Future scope | AUv2/AUv3 choice, sampler, signing/notarization and supported release matrix deferred until later milestones |
| K-12 | Resolved Git delivery issue | Initial REST read failed; authenticated branch push and draft PR #1 creation/read subsequently succeeded. No credential request, merge or force push |
| K-13 | Native build prerequisite | First owner Xcode build failed; K-18/K-19 address reported diagnostics. Await rebuild, then validate Apple API behavior, packaging/signing and TCC. Linux Core tests are insufficient |
| K-14 | Prototype limitation | Landscape/zero-rotation input only; explicit stop/select/start switching; handedness is frame-scoped estimate without stable IDs; verify mirror/resize/occlusion alignment on camera |
| K-15 | Validation limitation | Exact ≥95% usable-frame gate cannot be certified from casual live observation; no-recording constraint means independently unscorable metrics remain unverified |
| K-16 | Cloud persistence limitation | Installer draft rejected by approval service without reason. Safer start_skill saved for retained verified toolchain; install_script absent. Fresh reinstall/restoration not validated; no necessary current Core tests remain blocked |
| K-17 | Profiling prerequisite | CPU/physical footprint/thermal/pressure source exists but native calls and app/Logic contention are unmeasured; BGRA fallback overhead and first advertised format choice need profiling |
| K-18 | Confirmed defect; source patched, rebuild pending | Capture setup referenced `.inputPriority`, explicitly unavailable in the Mac SDK. Removed both preset references; retain direct device format/rate configuration. Native success not yet confirmed |
| K-19 | Reported warning; source patched, rebuild pending | Shutdown completion was non-Sendable when handed to the main queue. Annotated `@MainActor @Sendable` through model/pipeline; main-queue dispatch now occurs at one boundary. Isolated strict type-check passes; Mac warning removal not yet confirmed |
| K-20 | Resolved transfer blocker | Replacement 29.8 MB, 30.3-second clip downloaded and sampled; review in TRIAL_2026_10_27.md. Earlier oversize upload was not viewed |
| K-21 | Interpretation constraint | Fixed oblique angle and 0.72 cutoff retained; cutoff is display filtering, not contact confidence. Native app runtime/one-hand preview now visually observed; exact build/tests and two-hand/strike accuracy not certified |
| K-22 | Confirmed display defect; patched-source retest needed | Overlay vertically reflected at rest in reviewed clip. Corrected lower-left projection against actual preview rectangle, with mirror/letterbox tests; no model accuracy gain claimed until native retest |
| K-23 | Timing prerequisite | Sampled PTS age ~53 ms before ~10 ms median inference; camera connection/buffering/clock meaning require controlled investigation. Not measured physical contact→sound latency |
| K-24 | Calibration prototype limitation | Four-corner image-area source implemented/tested; native clicks/grid/mirror/resize and invalidation unrun. No height/contact or per-contact rest/release yet. Camera movement during live capture requires manual reset |
| K-25 | Baseline constraint | Preserve 720p/30, detail and temporal sampling. No measured CPU/latency/accuracy improvement claimed for updates; owner clarified resolution change is optional only with supporting evidence |

Resolved initial setup assumption: the repository is no longer remotely empty;
the owner's README commit was fetched before creating this documentation branch.
Apple documentation access and GitHub PR delivery were also subsequently verified;
the earlier access failures do not remain blockers for those completed operations.
