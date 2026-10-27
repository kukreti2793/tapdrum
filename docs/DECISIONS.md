# Decisions and proposals

Use explicit states: owner requirement, approved decision, proposed, deferred or
rejected. Do not turn a recommendation into an approved architectural decision.

| ID | Date | State | Decision / rationale |
| --- | --- | --- | --- |
| D-001 | 2026-10-27 | Owner requirement | Native camera-based tabletop percussion for Logic Pro supersedes earlier browser drum-pad suggestion |
| D-002 | 2026-10-27 | Owner requirement | Milestone 0 was the initial scope; later milestones require explicit approval. Superseded for active scope by D-015 |
| D-003 | 2026-10-27 | Owner requirement | First DAW path is a standalone MIDI controller plus existing Logic drum instrument; custom AU/sampler only after MIDI recording validation |
| D-004 | 2026-10-27 | Owner requirement | Local processing, no external percussion hardware baseline, honest contact estimates and measured latency, modular boundaries |
| D-005 | 2026-10-27 | Owner choice | Camera-only first; no recordings. No microphone capture/processing or video/audio diagnostic recording authorized |
| D-006 | 2026-10-27 | Approved direction | Owner approved the native Swift/SwiftUI, AVFoundation and replaceable Vision tracker proposal for M1. CoreMIDI remains M3; no MIDI code in M1 |
| D-007 | 2026-10-27 | Proposed | Keep a tracker adapter; evaluate MediaPipe only if evidence justifies its native integration/model cost; no parallel backend implementation now |
| D-008 | 2026-10-27 | Proposed | Temporal per-contact states, bounded latest-frame processing and explicit uncertainty; palm/base is a derived proxy |
| D-009 | 2026-10-27 | Proposed | Independent live trial labels under current privacy choice; exact event/physical latency remains unverified until a suitable method is separately agreed |
| D-010 | 2026-10-27 | Proposed | Channel 10 defaults and explicit same-pitch MIDI collision/retrigger policy; independent receiver must verify behavior |
| D-011 | 2026-10-27 | Deferred | AUv2 vs AUv3, sampler/model/sample assets, exact deployment matrix and distribution/signing choice await measured needs and relevant gates |
| D-012 | 2026-10-27 | Owner workflow | Feature branches/focused commits/PR review, no merge without owner approval, no destructive Git operations without authorization |
| D-013 | 2026-10-27 | Owner report | Logic Pro 10.7.2, Xcode 26.6, iOS 26.6.2 and original iPhone data cable supplied; installed tools/native compatibility still require checks |
| D-014 | 2026-10-27 | Research finding | Direct Apple docs verify proposed API surfaces and reported Xcode/macOS host-range pairing on paper; do not assume current Logic Virtual In documentation applies to 10.7.2 |
| D-015 | 2026-10-27 | Approved | Owner replied “approved. go ahead” to the Milestone 0 proposal and narrow Milestone 1 plan. Implement native camera preview, Vision hand tracking and diagnostics, keeping camera-only/no-recording. No merge or Milestone 2 approval is implied |
| D-016 | 2026-10-27 | Implementation choice | SwiftPM with tools 5.9/Swift 5 language mode, macOS 14 deployment floor for dedicated Continuity discovery; local app packaging/ad-hoc signing script, no external dependencies. Tested support still requires owner's Mac |
| D-017 | 2026-10-27 | Implementation choice | Single serial session/inference queue with late-frame discard, per-run delegate tokens, display throttled to 10 Hz, 250 ms freshness test evaluated on a 250 ms UI timer; no cross-frame identity guarantee |
| D-018 | 2026-10-27 | Validation boundary | Signed official Swift 6.0.3 Linux toolchain runs shared Core XCTest tests; Mac sources syntax-parsed only. No native build/hardware acceptance or paid hosted macOS CI assumed |
| D-019 | 2026-10-27 | Owner preference | Continue cloud development with owner-run Mac commands and pasted results. Do not propose local Codex/terminal-agent/Xcode-agent access again unless requested |
| D-020 | 2026-10-27 | Corrective implementation | First Mac compiler log shows inputPriority is unavailable on macOS. Remove the preset references, retain direct device format/frame-duration configuration, and make shutdown completion main-actor/sendable end-to-end; native rebuild pending |
| D-021 | 2026-10-27 | Owner trial preference / evidence boundary | Owner supplied an M1 trial recording, prefers that fixed camera angle and reports overlay cutoff 0.72. Requests necessary corrections/calibration and further progress. Recording exceeds 32 MiB and is unviewed; preserve preferences without fabricating findings or skipping validation. Supplied-clip review does not authorize automatic app recording |

Milestone 1 implementation is authorized. Target-Mac acceptance and approval to
advance beyond tracking remain required. No milestone acceptance is inferred from
implementation authorization.
