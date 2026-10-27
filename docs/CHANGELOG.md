# Changelog

## Unreleased — 2026-10-27 — guided playing-area foundation

- Added session-only four-corner area selection, convex geometry validation,
  bidirectional perspective mapping, preview guides and projected fingertip counts.
- Reset area on capture/mode/device/stall changes; preserve through mirror/resize;
  make manual reset after camera movement explicit. No height/contact inference.
- Added nine passing geometry/state tests (25 Core total) and the native retest
  guide. Native updated build/click/render paths still need the owner's Mac.
- Preserve baseline 720p/30, frame analysis and raw confidence; no resolution
  shortcut, smoothing, model/download, recording, microphone or musical output.

## Unreleased — 2026-10-27 — reviewed trial and preview correction

- Reviewed the accessible 30-second trial; recorded one-hand iPhone 720p/30
  behavior, visible rolling diagnostics and limits in TRIAL_2026_10_27.md.
- Corrected vertical overlay registration with explicit lower-left projection;
  added six geometry regression tests. Raw Vision output remains unchanged.
- Remember overlay cutoff (default 0.72), make finger names optional and distinguish
  raw pose estimates from estimates with visible joints.
- Preserve 720p/30 and temporal sampling per owner priority; no resolution shortcut,
  inference throttle or smoothing added. Native retest remains required.

## Unreleased — 2026-10-27 — owner trial review pending

- Recorded owner-reported live trial, fixed camera-angle preference, overlay cutoff
  0.72 and request for necessary calibration/corrections and further progress.
- Recording transfer exceeds 32 MiB; no visual analysis or accuracy claim made.
  Confirmed from source that the cutoff filters display only. No app code changed.

## Unreleased — 2026-10-27 — first Mac compiler fix

- Removed the macOS-unavailable `inputPriority` capture preset exposed by the
  owner's first Xcode 26.6/Swift 6.3.3 build; keep direct camera format/rate setup.
- Made shutdown completion explicitly main-actor/Sendable across model and
  pipeline, with main-queue delivery at a single boundary.
- Re-ran ten Core tests successfully and checked native syntax plus the isolated
  callback contract under strict concurrency; native rebuild remains pending.
- Recorded the owner's manual Mac-command/pasted-output workflow preference,
  compiler evidence, known defects, retry instructions and acceptance boundary.

## Unreleased — 2026-10-27 — Milestone 1 prototype source

- Recorded owner approval for M1, retaining camera-only/no-recordings and later
  milestone/merge approval gates.
- Added dependency-free SwiftPM Core/App structure and native capture/Vision/UI
  source: camera/mode selection, preview/finger labels/palm proxy, confidence,
  mirroring and frame/resource diagnostics.
- Added permission/run-token handling, late-frame discard, frame freshness,
  interruption/disconnection messages and orderly asynchronous shutdown.
- Added ten passing Core XCTest cases, local Mac `.app` build/run scripts and
  camera-only bundle configuration; native builds and live camera tests remain unrun.
- Added Mac first-run/acceptance guides and updated architecture, requirements,
  technology choices, progress, known issues and evidence records.
- Saved retained-toolchain cloud startup instructions after automatic review
  rejected a full installer draft; no new publication or fresh restoration claim.

## Unreleased — 2026-10-27 — Milestone 0 planning

- Captured the owner's native camera/tabletop/MIDI/Logic product requirements,
  replacing the earlier browser drum-pad suggestion.
- Added persistent agent guidance, architecture/technology proposals, source
  evidence, risk register, hardware checklist and gated implementation plan.
- Defined camera-only strike feasibility, native tracking, independent MIDI,
  Logic recording/bounce, latency, privacy and later AU acceptance protocols.
- Recorded owner-reported hardware, pending toolchain details and the explicit
  camera-only/no-recording constraint.
- Saved research/API network requirements in the cloud environment draft.
- Completed direct Apple camera/Vision/CoreMIDI/AU, Logic guide and Xcode support
  research after initial access failures; recorded later owner version/cable
  answers and distinguished documentation support from native validation.
- Opened draft PR #1 on the documentation feature branch; no merge performed.
- No application source, model download, instrument build, hardware test or
  milestone advancement included. Architectural recommendations await review.
