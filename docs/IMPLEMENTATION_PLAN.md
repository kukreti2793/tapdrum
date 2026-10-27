# Milestones and approval gates

Active work: **M1 correction and bounded M2 playing-area foundation**, requested
by the owner after the trial. The reviewed clip exposes an M1 overlay defect;
full target-Mac acceptance remains pending. Necessary guided image calibration is
implemented in parallel as explicitly requested, without claiming tracking gates
passed. Do not skip validation or advance to MIDI/plugins without approval.
No delivery dates are promised before feasibility and toolchain checks.

| Milestone | Smallest deliverable | Required acceptance evidence | Exit/approval condition |
| --- | --- | --- | --- |
| 0 — Requirements/feasibility | Hardware inventory, comparison, proposed architecture, contact/latency experiments, risks and persistent docs | Documentation/research delivered; owner approved proceeding. Native feasibility still needs experiments | M1 authorized by “approved. go ahead”; no merge implied |
| 1 — Hand tracking | Camera/observations/diagnostics implemented; reviewed runtime shows reflected overlay, corrected in source | M1 branch: 16 Core tests pass. Updated native projection/two-hand acceptance needs retest; first clip does not establish full accuracy | Native registration fix and C1/V1 remain open; owner explicitly requests necessary calibration progress |
| 2 — Strike recognition | First bounded step implemented: four-corner session-only projected playing area. Per-contact rest/release and temporal strike engine remain future | Calibration branch: 25 Core tests pass. Native clicks/grid/invalidation and then S1 contact/hover tests pending | Bounded area work authorized by trial request. No M2 acceptance/strike claim; validate alignment/area before further recognition and MIDI |
| 3 — MIDI controller | CoreMIDI transport, editable mappings/channel/velocity, note lifecycle, presets and independent receiver diagnostics | M1/P1/R1: receiver-observed events, simultaneous/repeated notes, no stuck owned notes on tested paths, preset failure tests | Independent MIDI verified; owner approves Logic test |
| 4 — Logic integration | One selected route to existing drum instrument; editable performance and audio bounce | L1 owner-assisted recording/playback/bounce; T1 only with agreed measurement method; disclosed latency/accuracy limits | Recognizable editable pattern and owner acceptance; explicit plugin approval required |
| 5 — Native instrument | Approved AU architecture, lightweight sample playback, kits/levels, plugin state and companion routing | A1 native AU validation, actual Logic load/restore/MIDI/audio/bounce, packaging checks | Host compatibility and instrument behavior verified before optimization/release |
| 6 — Optimization/release | Measured improvements, robust calibration/presets/errors, regression suite and release documentation | Held-out S1 regression, T1 under load if authorized, long-run R1, supported OS/Logic/camera/signing matrix | Owner accepts measured limitations and release scope |

## Current bounded task and next action

The owner's request to correct/calibrate and proceed authorizes the current
guided playing-area step. Next, run [CALIBRATION.md](CALIBRATION.md) on the Mac:
verify the corrected overlay, both hands/mirroring/resizing and all four corners,
then test reset and capture invalidation. Keep the original 720p/30 baseline and
raw inference timing; do not sacrifice accuracy/frame rate for speculative CPU
savings. Build per-contact rest/release/temporal recognition only after native
geometry is reliable. MIDI/AU/audio remain later. Strict frame-level percentages
and physical latency remain unverified without appropriate independent evidence.

## Reassessment rules

- Tracking success does not imply contact success. If contact-vs-hover fails,
  return to a documented feasibility decision; do not rush into MIDI/plugin work.
- If latency misses goals, identify camera/evidence/inference/audio contributions
  and present measured trade-offs. Prediction or MIDI timing correction must not
  be described as physical low-latency confirmation.
- Keep palm/finger requirements visible. Any reduced supported contact set or
  optional microphone dependency requires owner approval.
- If the toolchain/Logic combination is incompatible, propose supported choices
  before asking the owner to upgrade or install large dependencies.
- GitHub feature branches, focused commits and reviewable PRs hold each milestone.
  No merge without owner approval; tested significant checkpoints may be tagged
  after acceptance, never merely because planning documents exist.
