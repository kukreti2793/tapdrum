# Milestones and approval gates

Active work: **M2 camera-only motion feasibility**, following the owner's report
that native overlay/area checks passed. Rest/lift references and experimental
motion recognition are implemented in source; native recognition acceptance is
pending. Broader M1 fault/soak/quantitative tests remain open. Do not skip
validation or advance to MIDI without recognition evidence. Owner's 2026-10-28
scope correction removes custom sounds/sampler/AU from the roadmap: MIDI-only
TapDrum feeds a Logic software instrument track and the user's chosen drum plugin.
No delivery dates are promised before feasibility and toolchain checks.

| Milestone | Smallest deliverable | Required acceptance evidence | Exit/approval condition |
| --- | --- | --- | --- |
| 0 — Requirements/feasibility | Hardware inventory, comparison, proposed architecture, contact/latency experiments, risks and persistent docs | Documentation/research delivered; owner approved proceeding. Native feasibility still needs experiments | M1 authorized by “approved. go ahead”; no merge implied |
| 1 — Hand tracking | Capture/tracking and corrected overlay/area | Owner reports build, aligned landmarks, stable both hands, area/mirror/resize and Stop clearing passed. Broader C1/V1 and soak still open | Native geometry prerequisite satisfied for bounded M2 experiment; no quantitative accuracy or musical-latency claim |
| 2 — Strike recognition | Session-only area and per-contact rest/lift references; full-frame-rate approach/reversal state machines and bounded event diagnostics | 48 Core tests pass; new native build, live S1 contacts/hover, speed/duplicates and profiling pending | Trial request authorizes necessary calibration/progress. Recognition feasibility must be scored before MIDI; stop for review if contact/hover fails |
| 3 — MIDI controller | CoreMIDI transport, editable mappings/channel/velocity, note lifecycle, presets and independent receiver diagnostics | M1/P1/R1: receiver-observed events, simultaneous/repeated notes, no stuck owned notes on tested paths, preset failure tests | Independent MIDI verified; owner approves Logic test |
| 4 — Logic integration | MIDI recorded on a software instrument track; chosen compatible drum plugin supplies sound; Logic bounces audio stems | L1 owner-assisted recording/playback/bounce; T1 only with agreed measurement method; disclosed latency/accuracy limits | Recognizable editable pattern and owner acceptance; TapDrum generates no audio |
| 5 — Custom instrument removed | Superseded by owner's explicit MIDI-only instruction on 2026-10-28 | No custom sampler/AU deliverable or test required | Explicit scope change, not a silently skipped milestone |
| 6 — Optimization/release | Measured improvements, robust calibration/presets/errors, regression suite and release documentation | Held-out S1 regression, T1 under load if authorized, long-run R1, supported OS/Logic/camera/signing matrix | Owner accepts measured limitations and release scope |

## Current bounded task and next action

Next run [STRIKE_EXPERIMENT.md](STRIKE_EXPERIMENT.md) on the Mac. First calibrate
one index finger, then independently label actual contacts/no-contact reversals
and inspect counts, duplicates, misses and resource cost. Test other contacts,
both hands, uncertainty/reacquisition and gaps before held-out S1 scoring. Keep
720p/30 and raw inference timing; no speculative quality reduction. MIDI remains
later, all sound belongs to Logic's selected plugin. Frame-level accuracy and
physical latency remain unverified without independent evidence.

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
