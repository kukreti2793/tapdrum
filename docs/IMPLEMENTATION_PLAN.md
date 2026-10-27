# Milestones and approval gates

Active milestone: **1**, explicitly approved on 2026-10-27. Source implementation
exists; target-Mac acceptance remains pending. Do not begin the next
milestone until the owner explicitly approves; log approval and scope in decisions
and progress. Do not skip gates without documenting the reason and approval.
No delivery dates are promised before feasibility and toolchain checks.

| Milestone | Smallest deliverable | Required acceptance evidence | Exit/approval condition |
| --- | --- | --- | --- |
| 0 — Requirements/feasibility | Hardware inventory, comparison, proposed architecture, contact/latency experiments, risks and persistent docs | Documentation/research delivered; owner approved proceeding. Native feasibility still needs experiments | M1 authorized by “approved. go ahead”; no merge implied |
| 1 — Hand tracking | Source implemented: camera selection/preview, two-hand/finger observations, confidence/palm proxy and frame/resource diagnostics; no strikes or MIDI | Ten Core tests pass on Linux. Native build and C1/V1 checks pending; follow BUILD_AND_RUN and MILESTONE_1_CHECKLIST | Owner evaluates stable live tracking and approves strike experiment; gate not yet passed |
| 2 — Strike recognition | Guided calibration, per-contact temporal states, estimated events, duplicate suppression and live numerical diagnostics | S1 controlled camera-only live labels; per-contact precision/recall, negatives, rapid/chord limits; timing explicitly unverified where necessary | Owner reviews feasibility and any failed/unsupported contacts before MIDI work |
| 3 — MIDI controller | CoreMIDI transport, editable mappings/channel/velocity, note lifecycle, presets and independent receiver diagnostics | M1/P1/R1: receiver-observed events, simultaneous/repeated notes, no stuck owned notes on tested paths, preset failure tests | Independent MIDI verified; owner approves Logic test |
| 4 — Logic integration | One selected route to existing drum instrument; editable performance and audio bounce | L1 owner-assisted recording/playback/bounce; T1 only with agreed measurement method; disclosed latency/accuracy limits | Recognizable editable pattern and owner acceptance; explicit plugin approval required |
| 5 — Native instrument | Approved AU architecture, lightweight sample playback, kits/levels, plugin state and companion routing | A1 native AU validation, actual Logic load/restore/MIDI/audio/bounce, packaging checks | Host compatibility and instrument behavior verified before optimization/release |
| 6 — Optimization/release | Measured improvements, robust calibration/presets/errors, regression suite and release documentation | Held-out S1 regression, T1 under load if authorized, long-run R1, supported OS/Logic/camera/signing matrix | Owner accepts measured limitations and release scope |

## Current bounded task and next action

The Milestone 1 source now exists with the approved native tracking approach and
a macOS 14 deployment floor. Next, build and test it on the owner's Mac using
[the build guide](BUILD_AND_RUN.md) and [live checklist](MILESTONE_1_CHECKLIST.md).
Fix native compile/startup issues before evaluating camera quality. Keep
camera-only/no-recording constraints. Do not add strikes, MIDI, a sampler, AU,
microphone or data capture. Do not label M1 accepted until hardware evidence is
reviewed. Strict frame-level usability percentages remain unverified if live
observation cannot score them under the no-recording constraint.

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
