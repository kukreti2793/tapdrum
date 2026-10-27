# Decisions and proposals

Use explicit states: owner requirement, approved decision, proposed, deferred or
rejected. Do not turn a recommendation into an approved architectural decision.

| ID | Date | State | Decision / rationale |
| --- | --- | --- | --- |
| D-001 | 2026-10-27 | Owner requirement | Native camera-based tabletop percussion for Logic Pro supersedes earlier browser drum-pad suggestion |
| D-002 | 2026-10-27 | Owner requirement | Milestone 0 only now; no application source and no later milestone without explicit approval |
| D-003 | 2026-10-27 | Owner requirement | First DAW path is a standalone MIDI controller plus existing Logic drum instrument; custom AU/sampler only after MIDI recording validation |
| D-004 | 2026-10-27 | Owner requirement | Local processing, no external percussion hardware baseline, honest contact estimates and measured latency, modular boundaries |
| D-005 | 2026-10-27 | Owner choice | Camera-only first; no recordings. No microphone capture/processing or video/audio diagnostic recording authorized |
| D-006 | 2026-10-27 | Proposed | Evaluate native Swift/SwiftUI, AVFoundation, Vision and CoreMIDI first to minimize integration/dependency cost; exact deployment target pending |
| D-007 | 2026-10-27 | Proposed | Keep a tracker adapter; evaluate MediaPipe only if evidence justifies its native integration/model cost; no parallel backend implementation now |
| D-008 | 2026-10-27 | Proposed | Temporal per-contact states, bounded latest-frame processing and explicit uncertainty; palm/base is a derived proxy |
| D-009 | 2026-10-27 | Proposed | Independent live trial labels under current privacy choice; exact event/physical latency remains unverified until a suitable method is separately agreed |
| D-010 | 2026-10-27 | Proposed | Channel 10 defaults and explicit same-pitch MIDI collision/retrigger policy; independent receiver must verify behavior |
| D-011 | 2026-10-27 | Deferred | AUv2 vs AUv3, sampler/model/sample assets, exact deployment matrix and distribution/signing choice await measured needs and relevant gates |
| D-012 | 2026-10-27 | Owner workflow | Feature branches/focused commits/PR review, no merge without owner approval, no destructive Git operations without authorization |

No architecture or Milestone 1 implementation approval has been received.
