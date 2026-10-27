# Known issues and open questions

All items are open unless explicitly resolved. The M1 prototype is implemented
in source but has not been built/run on macOS; no native defect is concealed as
a passing test. Risks are not confirmed application defects.

| ID | Kind | Issue / next action |
| --- | --- | --- |
| K-01 | Research risk | Monocular contact/hover separation unproven; run controlled S1 only after M1 and approval |
| K-02 | Performance risk | Camera transport and reversal confirmation may exceed latency goals; measure rather than promise |
| K-03 | Hardware prerequisite | Logic/iOS/Xcode versions and original cable now owner-reported; mount/angle, installed active SDK and actual capture/Logic operation still unverified |
| K-04 | Environment limitation | Cloud is Linux without Apple SDKs/Logic/cameras; native compatibility and hardware validation require Mac |
| K-05 | Research access | Initial Apple block resolved in subsequent requests; official Google guide still blocked. Apple APIs and MediaPipe primary source reviewed; draft settings saved, publication not performed |
| K-06 | Privacy/measurement constraint | Camera-only/no-recordings chosen. Precise event truth and contact→audible latency lack an approved independent measurement method; do not claim them verified |
| K-07 | Tracking risk | Occluded tips, coupled fingers, palm proxy and hand-ID swaps unresolved; score all contacts separately |
| K-08 | Approval gate | M1 direction/implementation approved; macOS 14 floor chosen. Native acceptance pending; no M2 authorization or merge approval |
| K-09 | Integration risk | MIDI collisions, cleanup, Logic routing, instrument mapping and host lifecycle untested |
| K-10 | Dependency risk | MediaPipe native macOS packaging/acceleration, exact model size/license and resource cost unverified; not installed |
| K-11 | Future scope | AUv2/AUv3 choice, sampler, signing/notarization and supported release matrix deferred until later milestones |
| K-12 | Resolved Git delivery issue | Initial REST read failed; authenticated branch push and draft PR #1 creation/read subsequently succeeded. No credential request, merge or force push |
| K-13 | Native build prerequisite | Linux tests compile only Core. AppKit/AVFoundation/Vision/Darwin resource APIs, actor isolation, packaging/signing and TCC paths need the first real Xcode build; use build guide and return first errors |
| K-14 | Prototype limitation | Landscape/zero-rotation input only; explicit stop/select/start switching; handedness is frame-scoped estimate without stable IDs; verify mirror/resize/occlusion alignment on camera |
| K-15 | Validation limitation | Exact ≥95% usable-frame gate cannot be certified from casual live observation; no-recording constraint means independently unscorable metrics remain unverified |
| K-16 | Cloud persistence limitation | Installer draft rejected by approval service without reason. Safer start_skill saved for retained verified toolchain; install_script absent. Fresh reinstall/restoration not validated; no necessary current Core tests remain blocked |
| K-17 | Profiling prerequisite | CPU/physical footprint/thermal/pressure source exists but native calls and app/Logic contention are unmeasured; BGRA fallback overhead and first advertised format choice need profiling |

Resolved initial setup assumption: the repository is no longer remotely empty;
the owner's README commit was fetched before creating this documentation branch.
Apple documentation access and GitHub PR delivery were also subsequently verified;
the earlier access failures do not remain blockers for those completed operations.
