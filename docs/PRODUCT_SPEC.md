# Product specification

Status: owner reports native overlay/area checks passed; M2 motion experiment
implemented in source, awaiting native validation and contact/hover scoring.
Updated: 2026-10-28. Working name: **TapDrum**. “VisionDrum” in the supplied workflow
is treated as a descriptive placeholder; final product naming is undecided.

## Purpose and user experience

Create a local, camera-based **MIDI-only percussion controller** for Apple Logic
Pro. Owner scope correction on 2026-10-28 supersedes the earlier custom sound
instrument requirement: TapDrum does not synthesize or play drum audio and will
not include a sampler/custom AU instrument. The musician plays an ordinary tabletop using both hands,
individual fingers, and palm/base contacts. It must feel like percussion rather
than a gesture-driven computer interface.

The intended workflow is: open Logic Pro and the companion app; choose a built-in
or compatible iPhone camera; position it to see both hands and the table;
calibrate; assign notes and sensitivity; choose a MIDI route and drum kit; play;
record editable MIDI on a Logic software instrument track; choose any compatible
drum plugin there; edit notes, velocities, and timing in Logic; then bounce its
audio to stems using Logic. A stem is rendered audio, not the editable MIDI track.
The app must explain tracking or calibration problems clearly.

Owner reports a 2020 M1 MacBook Pro with 8 GB unified memory, macOS 26.5.2, and
iPhone 17 Pro 512 GB. The owner subsequently supplied Logic Pro 10.7.2, Xcode
26.6, iOS 26.6.2 and an original iPhone data cable. Xcode installation/active SDK,
full compatibility and mount stability remain to be checked. A running Continuity
trial was reviewed; the owner subsequently reports a successful corrected native
build/overlay/area check. These
reports are not independently verified compatibility evidence. Apple Silicon is
the initial target; no wider support is promised.

## Scope

- Built-in and compatible Continuity Camera capture, selection, preview, optional
  mirroring, supported format selection, and connection-loss handling.
- Local two-hand/finger landmark tracking, confidence and identity diagnostics,
  approximate palm center/base estimation, and occlusion handling.
- Guided tabletop/playing-position calibration, perspective handling, camera
  movement detection, and explicit recalibration when assumptions become invalid.
- Distinct, confidence-gated strike events with retrigger suppression, repeat
  support, and simultaneous contacts where feasible.
- Configurable MIDI notes, channel, velocity/sensitivity, reliable note lifetimes,
  activity diagnostics, and saved presets for twelve hand/contact combinations.
- The user's chosen Logic drum plugin is the sole sound engine. TapDrum sends
  MIDI only; recording/editing and audio-stem bouncing happen inside Logic.
- UI for capture, overlays, calibration, mapping, routing, presets, errors, and
  timing/resource diagnostics. Function takes priority over visual complexity.

Default assignments apply to each hand independently:

| Contact | Default sound label | MIDI note |
| --- | --- | --- |
| Palm/base estimate | Heavy kick | 36 |
| Thumb | Alternative kick | 35 |
| Index | Closed hi-hat | 42 |
| Middle | Snare | 38 |
| Ring | Open hi-hat | 46 |
| Little finger | Clap | 39 |

These are convenient drum-map defaults; actual sounds depend on the selected
instrument. All mappings remain editable. Channel 10 is a proposed default.

## Constraints and honesty

Monocular pose cannot prove physical contact or impact force. A tabletop
homography rectifies points already on the table; it does not measure finger
height. Camera-only remains the baseline. Optional local microphone confirmation
is a possible future experiment needing permission, not a hidden baseline
dependency. The owner selected **camera-only first; no recordings** for the
initial work; no microphone experiments or diagnostic recordings are authorized.

End-to-end median ≤30 ms and p95 ≤50 ms are aspirations. Report actual camera,
recognition, MIDI, and audible-output timing even when targets fail. No end-to-end latency
or strike-accuracy measurements exist yet.

No cloud inference, footage transmission, or recording by default. Any diagnostic
recording must be explicit, local, bounded, and deletable. Never place heavy work
on a real-time audio thread. Keep resource usage compatible with an 8 GB Mac
running Logic; demonstrate this with measurements rather than model claims.

Build incrementally. Tracking and image-area checks passed in the owner's limited
native report; broader fault/soak/quantitative tracking tests remain open. M2
rest/lift references and estimated motion events are implemented experimentally,
with no native recognition or physical-contact accuracy claim. MIDI is still
unimplemented and gated by recognition evidence. See
[the implementation plan](IMPLEMENTATION_PLAN.md).
