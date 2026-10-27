# Requirements and traceability

All product requirements below are **unimplemented**. Acceptance references are
planned tests in [TEST_PLAN.md](TEST_PLAN.md); they are not passing results.

| ID | Required behavior | Milestone | Acceptance evidence |
| --- | --- | --- | --- |
| ENV-01 | Confirm actual Mac, macOS, Logic, Xcode and iPhone/iOS; record exact supported versions only after verification | 0–1 | H0 inventory, native build and hardware matrix |
| CAM-01 | Enumerate/select built-in and compatible Continuity cameras; show local preview | 1 | C1 live device/permission tests |
| CAM-02 | Enumerate actual format/frame-rate ranges, choose supported settings, optionally mirror display | 1 | C1 observed frame timing and coordinate tests |
| CAM-03 | Handle switching, denial/revocation, interruption, and disconnection without stale output | 1–3 | C1, R1 fault injection |
| VIS-01 | Estimate two hands, each finger, wrist/palm proxy, confidence and motion history | 1 | V1 labeled tracking checks |
| VIS-02 | Preserve anatomical hand/finger identity through mirroring and crossing; reject unknown/low-confidence identity | 1–2 | V1 crossing/occlusion evaluation |
| CAL-01 | Guide camera/table positioning, playing region, per-contact resting/release references, perspective handling | 2 | S1 calibration protocol |
| CAL-02 | Detect/invalidate unsuitable or moved calibration; require explicit recalibration | 2 | S1, R1 moved-camera tests |
| STR-01 | Emit distinct estimated strikes; reject hover, rest, lifting and accidental movements | 2 | S1 held-out precision/recall and negatives |
| STR-02 | Suppress duplicates; allow rapid repetitions, alternating fingers and feasible simultaneous contacts | 2 | S1 rate, duplicate and chord tests |
| STR-03 | Estimate palm/base contacts separately; publish their limitations separately | 2 | S1 palm-specific scores |
| MID-01 | Note On/Off, velocity, editable channel/note, simultaneous messages, diagnostics | 3 | M1 independent MIDI receiver |
| MID-02 | No stuck notes; lifecycle cleanup; explicit same-note collision/retrigger policy | 3 | M1, R1 lifecycle tests |
| MAP-01 | Twelve editable contact slots, defaults from product spec, per-contact sensitivity/retrigger thresholds | 3 | M1 mapping/validation tests |
| PRE-01 | Versioned preset save/load, validation, safe failure on corrupt data | 3 | P1 round-trip and failure tests |
| DAW-01 | Standalone CoreMIDI route to existing Logic instrument; record editable notes/velocities/timing | 4 | L1 manual recording and playback |
| DAW-02 | Bounce recorded performance to an audio track/file in Logic | 4 | L1 audible bounce evidence |
| AU-01 | Later compatible native instrument, polyphonic sample playback, kit/sample assignment, level and velocity control | 5 | A1 AU validation and host session tests |
| AU-02 | Host-safe lifecycle, state/preset restore, packaging/signing and installation | 5–6 | A1, release matrix |
| UX-01 | Preview/landmarks, calibration, mapping, routing, presets, MIDI/confidence/latency diagnostics and actionable errors | 1–6 | Milestone-specific manual tasks |
| PERF-01 | Measure capture→tracking→strike→MIDI→audible audio, median/p95, misses, false triggers and long-run stability | 1–6 | T1 and resource protocol |
| PRIV-01 | Local inference; no footage retention/transmission by default; explicit microphone and recording consent | All | D1 data-flow review and consent tests |
| REL-01 | Survive tracking loss, occlusion, camera loss, rapid play, Logic restart and orderly shutdown | 1–6 | R1 fault injection |
| ARCH-01 | Separate subsystems; no blocking/camera/inference work on audio render thread | All | Interface/design review and later profiling |
| CONT-01 | Maintain project memory, approval gates, focused branches/commits, test evidence and reviewable PRs | All | Documentation and Git review |

## Cross-cutting decisions still open

- Exact deployment target, SDK/tool versions and support matrix depend on H0.
- Vision is the recommended first candidate, not a finalized framework selection.
- Owner chose camera-only first with no recordings. Microphone-assisted
  confirmation and retained diagnostic footage/audio are not authorized.
- “Velocity” is a calibrated expressive estimate, not measured impact force.
- Proposed numeric feasibility thresholds need owner approval. Every contact,
  lighting/angle condition, and camera mode must be reported separately.
- No test outcome, hardware compatibility, or plugin approval is inferred from
  documentation checks. See [actual results](TEST_RESULTS.md).
