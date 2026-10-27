# Project progress and handoff

Updated: 2026-10-27. Active milestone: **0 — requirements and feasibility**.
Status: research/documentation prepared; finalization and implementation approval
pending. No application code, build target, installed model, or instrument exists.

## Repository and task baseline

The local checkout initially had an unborn `work` branch and no files. A later
read found the owner's initial README commit on GitHub main:
`e60421f8e60815828a83a9ee12a8f63fc074476f`. Fetched that commit and created
`docs/milestone-0-feasibility`; no existing local changes were discarded.

The native product master prompt superseded the earlier approved browser pad
suggestion before any browser or native application implementation was created.
This task is limited to Milestone 0. See `DECISIONS.md` for owner constraints.

## Prepared

- Product requirements and milestone traceability; persistent session guidance.
- Provisional native standalone architecture, tracker comparison, module contracts,
  contact/latency risks and future host-safe plugin boundary.
- Objective camera-only live trial protocol, proposed feasibility gates, privacy
  constraints, independent MIDI/Logic/latency test plans, and phased acceptance.
- Primary MediaPipe source/license review and secondary Apple API corroboration;
  blocked official Apple documentation is explicitly separated from verified facts.
- Owner-reported hardware inventory: 2020 M1 MacBook Pro, 8 GB, macOS 26.5.2;
  iPhone 17 Pro 512 GB; Xcode downloading. Camera-only/no-recording choice applied.
- Environment research/API domain additions saved as a draft. No install/start
  script is needed for documentation-only work; native setup is not complete.

## Still required before architecture finalization / implementation

1. Remaining inventory: Logic Pro/iOS versions, installed Xcode/SDK once ready,
   available data cable and camera mount. Audio configuration can follow for M4.
2. Read official Apple camera/Vision/CoreMIDI/AU and toolchain documentation or
   inspect the selected SDK; network access is currently blocked in cloud.
3. Owner reviews the provisional architecture and feasibility criteria. Explicit
   approval is required to begin Milestone 1; this documentation does not imply it.
4. Later, run native builds and live hardware tests on the actual Mac. Linux
   documentation checks are not evidence of compatibility or instrument readiness.

The next recommended implementation task, **only after approval**, is a narrow
native capture/hand-tracking prototype with no strikes, MIDI, microphone, sampler,
plugin or recordings. Exact physical contact-to-audio latency has no approved
measurement method under the current no-recording constraint and remains open.

Read `TEST_RESULTS.md` for executed checks and Git delivery status; do not infer
tests or remote persistence from plans. Read `KNOWN_ISSUES.md` before continuing.
