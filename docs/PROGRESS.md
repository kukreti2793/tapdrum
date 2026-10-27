# Project progress and handoff

Updated: 2026-10-27. Active milestone: **1 — camera and hand tracking**.
Owner approved proceeding (“approved. go ahead”). Capture/tracking prototype
source and shared tests are implemented. After the first native build failure and
source correction, the owner now reports a live M1 trial. **The clip is now reviewed; a vertical overlay bug is patched in source and
tracking acceptance remains pending a native correction retest.**
No strikes, MIDI, sound engine, plugin or microphone is implemented.

## Current trial review — accessible recording inspected

Read [TRIAL_2026_10_27.md](TRIAL_2026_10_27.md) for the sampled evidence and exact
rolling diagnostics. The replacement 29.8 MB clip was inspected at 0, 3, …, 30 s,
with full-resolution checks at 6, 18, 30 s. It shows a running iPhone 720p/30
preview and one right-hand estimate at overlay cutoff 0.72. No two-hand/contact
acceptance or frame-level accuracy metric is established.

A persistent vertical overlay reflection is visible at rest. Corrected source
projects lower-left Vision points directly into the preview image rectangle,
with explicit mirroring/letterbox handling, plus six geometry tests. Raw model
output is unchanged. The cutoff is now remembered; new installs default to 0.72.
Finger names can be hidden, and zero-visible-joint pose estimates are labeled
honestly. Native correction validation remains pending on the owner's Mac.

Owner clarified that lower resolution was only a suggestion: accuracy, temporal
sampling and low latency take priority. Keep 720p/30; no reduction shortcut,
inference rate cap, smoothing or unmeasured CPU improvement. Current clip shows
~30 analyzed fps, ~10/14–15 ms Vision p50/p95, ~53 ms frame PTS age and ~0.43 core
CPU. Frame age is the timing concern to investigate separately from processing.

The request authorizes necessary calibration/progress after reviewing the trial.
Next bounded work is guided session-only playing-area geometry, without claiming
height/contact or skipping tracking/recognition acceptance. Supplied footage is
outside Git; no app recording or microphone is authorized.

## First Mac build diagnosis and correction

The owner prefers to continue here without granting a local agent terminal/Xcode
access. Supply small, specific commands for the owner to run and diagnose the
returned text output. Do not suggest connecting local Codex again unless asked.

The pasted `run-macos.command` output confirms Xcode 26.6 build 17F113, Apple Swift
6.3.3 and MacOSX26.5 SDK with an arm64 target. Compilation failed before tests or
app launch: `.inputPriority` is unavailable on macOS. Repeated diagnostics are
the same two source references, not eight independent defects. A separate warning
flagged the unannotated shutdown completion's transfer to the main queue.

Removed the unavailable preset and kept device `activeFormat`/frame-duration
configuration within the existing session transaction. Shutdown completions are
now `@MainActor @Sendable` end-to-end, dispatched once to the main queue after
capture stops. No warning suppression, framework changes or tool reinstall.

Native source parsing and an isolated strict-concurrency callback type-check
passed in cloud. The later owner-reported live trial suggests progress beyond
that failure, but its recording has not been inspected and the tested commit/
build output is unknown. Do not claim the exact compiler diagnostics, all native
tests, or signing/permissions were independently verified from that report alone.

## Current implementation and next task

- Branch: `feat/milestone-1-hand-tracking`, based on the unmerged M0 documentation
  branch. Keep M1 review separate; do not merge either PR without owner approval.
- Draft [PR #2](https://github.com/kukreti2793/tapdrum/pull/2) contains this M1
  implementation and targets the M0 branch for a focused diff. After an approved
  PR #1 merge, retarget #2 to main; do not merge M1 into the documentation branch.
- SwiftPM/Core/App separation with a macOS 14 deployment floor, tools 5.9/Swift 5
  language mode, no third-party packages/models. Source implements supported-mode
  camera selection, live preview/mirroring, two-hand Vision landmarks/finger labels,
  confidence/palm proxy, frame and CPU/footprint/thermal/pressure diagnostics.
- Serial capture/inference, late-frame discard, per-run delegate and permission
  tokens, confidence filtering, timestamp ordering and bounded numeric histories.
  Overlay freshness threshold is 250 ms with a 250 ms UI timer, not a hard deadline.
- Camera-only/no-recordings: no audio input, microphone permission, file recording,
  retained raw landmark trajectories, MIDI or network inference.
- Ten Core XCTest cases pass under a signature-verified official Swift 6.0.3 Linux
  toolchain; native source syntax parsed only. Plist/shell/platform-guard checks pass.
  Mac API type-checking and real-camera behavior cannot be established in cloud.
- Concrete Mac packaging/run scripts and a text-only acceptance checklist are in
  [BUILD_AND_RUN.md](BUILD_AND_RUN.md) and [MILESTONE_1_CHECKLIST.md](MILESTONE_1_CHECKLIST.md).

Next: owner builds/runs on the Mac, returns the first compiler/startup error or
the checklist's numerical/qualitative results; fix any native failures, then
evaluate C1/V1. Stable tracking acceptance and **new explicit approval** are
required before Milestone 2. Do not ask again for already supplied versions or cable.

## Reusable cloud setup

The verified Linux toolchain/archive/cache are retained under cloud scratch,
outside Git. A full installer draft was rejected by the approval service with
“ASB rejected the draft request” and no reason; no installer save was confirmed.
A narrower **start_skill save succeeded**, activating the retained verified
toolchain and running the ten Core tests without a new download. No install_script
was saved; no cloud services are needed. The installer helper was exercised
successfully on the current cached setup, but fresh-instance reinstall is not
claimed. Review/save the startup draft in environment settings and publish when
appropriate; this task did not publish or validate a newly restored task.

The current instance supports Core development/tests, not native instrument
acceptance. A missing toolchain after restoration remains a setup prerequisite;
never bypass signature checks or silently substitute native validation.

## Repository and task baseline

The local checkout initially had an unborn `work` branch and no files. A later
read found the owner's initial README commit on GitHub main:
`e60421f8e60815828a83a9ee12a8f63fc074476f`. Fetched that commit and created
`docs/milestone-0-feasibility`; no existing local changes were discarded.

The native product master prompt superseded the earlier approved browser pad
suggestion before any browser or native application implementation was created.
The initial task was limited to Milestone 0. Its proposal was subsequently approved
for narrow Milestone 1 implementation. See `DECISIONS.md` for owner constraints.

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
- Environment research/API domain additions were saved for M0. At M1 the startup
  activation instructions described above were saved; native setup remains unverified.

## Remaining native validation

1. Remaining setup: camera mount/angle and a successful native rebuild after the
   first compiler failure. Xcode/compiler/SDK are now evidenced by the owner's
   log; do not repeat answered version/cable questions. Audio configuration can
   follow for M4.
2. Inspect the selected SDK/native tool activation; official Apple API research is
   complete for this proposal. Google guide access is still blocked, but its
   primary API/license sources were read; no MediaPipe deployment is selected.
3. M1 implementation approval is recorded. Native acceptance is still required;
   do not confuse that approval with passed C1/V1 tests or permission for M2.
4. Later, run native builds and live hardware tests on the actual Mac. Linux
   documentation checks are not evidence of compatibility or instrument readiness.

Exact physical contact-to-audio latency has no approved measurement method under
the current no-recording constraint and remains open. Source for the approved
tracking prototype exists; do not recreate it from scratch next session.

Draft [PR #1](https://github.com/kukreti2793/tapdrum/pull/1) is open from
`docs/milestone-0-feasibility` into `main`. Branch push and PR state were verified;
no merge or tested milestone tag was made. Final documentation validation and
delivery updates are recorded in `TEST_RESULTS.md`.

Read `TEST_RESULTS.md` for executed checks and Git delivery status; do not infer
tests or remote persistence from plans. Read `KNOWN_ISSUES.md` before continuing.
