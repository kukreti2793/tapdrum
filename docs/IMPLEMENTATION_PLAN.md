# Milestones and approval gates

Active milestone: **0 only**. Plans are not implementation. Do not begin the next
milestone until the owner explicitly approves; log approval and scope in decisions
and progress. Do not skip gates without documenting the reason and approval.
No delivery dates are promised before feasibility and toolchain checks.

| Milestone | Smallest deliverable | Required acceptance evidence | Exit/approval condition |
| --- | --- | --- | --- |
| 0 — Requirements/feasibility | Hardware inventory, source-backed comparison, provisional architecture, contact/latency experiments, risk register and persistent docs | H0 review; verified vs unavailable evidence clearly marked; no application source | Pending remaining hardware answers, official API verification, architecture review and explicit approval for M1 |
| 1 — Hand tracking | Native app opens selected camera, live preview/landmarks, two-hand identity/confidence and frame/resource diagnostics; no strikes or MIDI | C1/V1 on actual target Mac: permissions, supported formats, stability, crossing/occlusion, measured rate/age/resources | Owner evaluates stable live tracking and approves strike experiment |
| 2 — Strike recognition | Guided calibration, per-contact temporal states, estimated events, duplicate suppression and live numerical diagnostics | S1 controlled camera-only live labels; per-contact precision/recall, negatives, rapid/chord limits; timing explicitly unverified where necessary | Owner reviews feasibility and any failed/unsupported contacts before MIDI work |
| 3 — MIDI controller | CoreMIDI transport, editable mappings/channel/velocity, note lifecycle, presets and independent receiver diagnostics | M1/P1/R1: receiver-observed events, simultaneous/repeated notes, no stuck owned notes on tested paths, preset failure tests | Independent MIDI verified; owner approves Logic test |
| 4 — Logic integration | One selected route to existing drum instrument; editable performance and audio bounce | L1 owner-assisted recording/playback/bounce; T1 only with agreed measurement method; disclosed latency/accuracy limits | Recognizable editable pattern and owner acceptance; explicit plugin approval required |
| 5 — Native instrument | Approved AU architecture, lightweight sample playback, kits/levels, plugin state and companion routing | A1 native AU validation, actual Logic load/restore/MIDI/audio/bounce, packaging checks | Host compatibility and instrument behavior verified before optimization/release |
| 6 — Optimization/release | Measured improvements, robust calibration/presets/errors, regression suite and release documentation | Held-out S1 regression, T1 under load if authorized, long-run R1, supported OS/Logic/camera/signing matrix | Owner accepts measured limitations and release scope |

## Next bounded task after Milestone 0 approval

Create only the Milestone 1 capture/tracking skeleton using the agreed toolchain.
First prove camera permission, actual device formats and a live frame on the Mac;
then add the chosen tracker behind a narrow adapter. Keep camera-only/no-recording
constraints. Do not add MIDI, a sampler, AU target, microphone or data capture.
Choose minimum OS/framework versions after the pending inventory/API checks.

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
