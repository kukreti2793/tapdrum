# Project progress and handoff

Updated: 2026-10-27. Active milestone: **0 — requirements and feasibility**.
Status: research/documentation prepared for review; architecture and implementation
approval pending. No application code, build target, installed model, or instrument exists.

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
- Primary MediaPipe source/license review, direct official Apple API/support/Logic
  documentation review, and explicit remaining Google-guide/native SDK limitations.
- Owner-reported hardware inventory: 2020 M1 MacBook Pro, 8 GB, macOS 26.5.2;
  iPhone 17 Pro 512 GB; subsequently Logic Pro 10.7.2, Xcode 26.6, iOS 26.6.2 and
  original data cable. Camera-only/no-recording choice applied. Official Xcode
  support table includes the reported host range; native operation is unverified.
- Environment research/API domain additions saved as a draft. No install/start
  script is needed for documentation-only work; native setup is not complete.

## Still required before architecture finalization / implementation

1. Remaining setup: camera mount/angle and native Xcode installation/active SDK
   verification. Do not repeat answered version/cable questions. Audio configuration
   can follow for M4.
2. Inspect the selected SDK/native tool activation; official Apple API research is
   complete for this proposal. Google guide access is still blocked, but its
   primary API/license sources were read; no MediaPipe deployment is selected.
3. Owner reviews the provisional architecture and feasibility criteria. Explicit
   approval is required to begin Milestone 1; this documentation does not imply it.
4. Later, run native builds and live hardware tests on the actual Mac. Linux
   documentation checks are not evidence of compatibility or instrument readiness.

The next recommended implementation task, **only after approval**, is a narrow
native capture/hand-tracking prototype with no strikes, MIDI, microphone, sampler,
plugin or recordings. Exact physical contact-to-audio latency has no approved
measurement method under the current no-recording constraint and remains open.

Draft [PR #1](https://github.com/kukreti2793/tapdrum/pull/1) is open from
`docs/milestone-0-feasibility` into `main`. Branch push and PR state were verified;
no merge or tested milestone tag was made. Final documentation validation and
delivery updates are recorded in `TEST_RESULTS.md`.

Read `TEST_RESULTS.md` for executed checks and Git delivery status; do not infer
tests or remote persistence from plans. Read `KNOWN_ISSUES.md` before continuing.
