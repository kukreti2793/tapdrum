# Known issues and open questions

Owner reports corrected overlay/area checks passed on 2026-10-28. Current M2
motion experiment has 48 passing Core tests; new native recognition build/accuracy
and profiling remain unverified. Owner now requires MIDI-only output: custom
sounds/sampler/AU are removed from scope. Historical issues are retained below;
current status takes precedence over prior pending notes.

| ID | Kind | Issue / next action |
| --- | --- | --- |
| K-01 | Research risk | Monocular contact/hover separation unproven; run controlled S1 for the authorized M2 experiment before MIDI |
| K-02 | Performance risk | Camera transport and reversal confirmation may exceed latency goals; measure rather than promise |
| K-03 | Hardware prerequisite | Owner reports calibration build/open/geometry passed; new recognition build, mount/transport stability and Logic operation remain unverified |
| K-04 | Environment limitation | Cloud is Linux without Apple SDKs/Logic/cameras; native compatibility and hardware validation require Mac |
| K-05 | Research access | Initial Apple block resolved in subsequent requests; official Google guide still blocked. Apple APIs and MediaPipe primary source reviewed; draft settings saved, publication not performed |
| K-06 | Privacy/measurement constraint | Camera-only/no-recordings chosen. Precise event truth and contact→audible latency lack an approved independent measurement method; do not claim them verified |
| K-07 | Tracking risk | Occluded tips, coupled fingers, palm proxy and hand-ID swaps unresolved; score all contacts separately |
| K-08 | Validation gate | Native alignment/area checks passed per owner, enabling planned bounded M2 motion experiment. Strike acceptance pending; no MIDI advancement or merge approval |
| K-09 | Integration risk | MIDI collisions, cleanup, Logic routing, instrument mapping and host lifecycle untested |
| K-10 | Dependency risk | MediaPipe native macOS packaging/acceleration, exact model size/license and resource cost unverified; not installed |
| K-11 | Scope correction | Custom AU/sampler removed by owner's MIDI-only instruction. App signing/notarization and supported release matrix still required later |
| K-12 | Resolved Git delivery issue | Initial REST read failed; authenticated branch push and draft PR #1 creation/read subsequently succeeded. No credential request, merge or force push |
| K-13 | Native build status | Owner now reports calibration build/open passed; new recognition build/API behavior needs Mac test. Broader permissions/signing/fault tests remain open |
| K-14 | Prototype limitation | Landscape/zero-rotation input only; explicit stop/select/start switching; handedness is frame-scoped estimate without stable IDs; verify mirror/resize/occlusion alignment on camera |
| K-15 | Validation limitation | Exact ≥95% usable-frame gate cannot be certified from casual live observation; no-recording constraint means independently unscorable metrics remain unverified |
| K-16 | Cloud persistence limitation | Installer draft rejected by approval service without reason. Safer start_skill saved for retained verified toolchain; install_script absent. Fresh reinstall/restoration not validated; no necessary current Core tests remain blocked |
| K-17 | Profiling prerequisite | Native spot diagnostics are available; sustained app/Logic contention remains unmeasured; BGRA fallback overhead and first advertised format choice need profiling |
| K-18 | Resolved per owner build report | Removed macOS-unavailable `.inputPriority`; direct device format/rate configuration retained. Owner reports later calibration build/open passed |
| K-19 | Patched; warning output not inspected | Completion uses `@MainActor @Sendable` and strict isolated check passes. Owner reports later build/open passed but did not supply warning output |
| K-20 | Resolved transfer blocker | Replacement 29.8 MB, 30.3-second clip downloaded and sampled; review in TRIAL_2026_10_27.md. Earlier oversize upload was not viewed |
| K-21 | Interpretation constraint | Fixed oblique angle and 0.72 cutoff retained; cutoff is display filtering, not contact confidence. Native app runtime/one-hand preview now visually observed; exact build/tests and two-hand/strike accuracy not certified |
| K-22 | Resolved per owner alignment report | Corrected lower-left projection; owner reports hand alignment, area clicks and mirror/resize passed. No model accuracy percentage implied |
| K-23 | Timing prerequisite | Sampled PTS age ~53 ms before ~10 ms median inference; camera connection/buffering/clock meaning require controlled investigation. Not measured physical contact→sound latency |
| K-24 | Calibration limitation | Native area/mirror/resize/Stop clearing passed per owner. Rest/lift references implemented experimentally but native controls unrun. No measured height/contact; camera movement still requires manual reset |
| K-25 | Baseline constraint | Preserve 720p/30, detail and temporal sampling. No measured CPU/latency/accuracy improvement claimed for updates; owner clarified resolution change is optional only with supporting evidence |
| K-26 | M2 feasibility risk | Reversal confirmation adds evidence delay and can mistake near-table hovering for contact. Test independent actual/no-contact labels before MIDI; no physical latency or real-time suitability claim |
| K-27 | M2 pose/identity limitation | References require fixed playing position, visible joints ≥0.72 and unique chirality. Undetected label swaps, coupled fingers, occlusion and palm-base proxy errors remain possible |
| K-28 | Current profiling prerequisite | Owner spot check: 30 fps, CPU 39.6%, PTS age 48.1 ms (percentile unspecified), no memory value. Recognition overhead and sustained enabled operation unmeasured |

Resolved initial setup assumption: the repository is no longer remotely empty;
the owner's README commit was fetched before creating this documentation branch.
Apple documentation access and GitHub PR delivery were also subsequently verified;
the earlier access failures do not remain blockers for those completed operations.
