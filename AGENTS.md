# Working on TapDrum

TapDrum is a local, camera-based tabletop percussion controller for macOS and
Logic Pro. The browser drum-pad idea was superseded by the owner's native product
specification. Read [the product spec](docs/PRODUCT_SPEC.md) before proposing work.

At the beginning of each session:

1. Read this file, `docs/IMPLEMENTATION_PLAN.md`, `docs/PROGRESS.md`, and
   `docs/KNOWN_ISSUES.md`; consult `docs/ARCHITECTURE.md` for affected boundaries.
2. Inspect the branch, working tree, relevant history, and actual implementation.
   Report discrepancies between documentation and code before changing anything.
3. Identify the active milestone and state the objective, affected components,
   planned changes, risks, and prerequisites in plain language.

## Current scope and approval

- The owner explicitly approved proceeding on 2026-10-27. Active scope is
  **Milestone 1: native camera preview and hand tracking with diagnostics**.
- Implement only capture, two-hand/finger observations, confidence/handedness,
  preview/overlay and frame/resource diagnostics. No strike recognition, MIDI,
  sampler, plugin, microphone or recordings. Milestone 2 needs new approval after
  target-Mac tracking acceptance. Ask about significant architectural changes.
- Owner reports a 2020 M1 MacBook Pro, 8 GB, macOS 26.5.2, Logic Pro 10.7.2,
  Xcode 26.6, and iPhone 17 Pro on iOS 26.6.2 with an original data cable.
  Installation/SDK and native compatibility still need verification on the Mac.
  Linux checks cannot establish musical latency or working Logic integration.
- Use the existing checkout. Cloud tasks are isolated; do not create a worktree
  unless the owner explicitly requests one.

## Engineering and evidence

- Keep camera acquisition, tracking, calibration, strikes, mapping, MIDI, UI, and
  future audio rendering separate. Never run vision, camera operations, file I/O,
  or other blocking work on an audio render thread.
- Monocular pose/depth estimates are not verified physical contact. Palm base
  and strike velocity are estimates requiring labeled evaluation.
- Current owner choice is **camera-only first; no recordings**. No microphone
  processing or retained video/audio/raw landmark histories. Future changes need
  separate explicit opt-in. Never commit recordings, biometric data, or secrets.
- Prefer lightweight dependencies; explain model size/resource cost before large
  downloads. No paid services/cloud inference without approval.
- Follow `docs/TEST_PLAN.md`. Keep measured, estimated, failed, skipped, blocked,
  and unrun outcomes distinct. Never claim hardware, DAW, audio, or latency tests
  passed without execution evidence.

## Git and handoff

- Preserve existing work. Use small feature branches, focused commits, tests for
  implemented behavior, and descriptive pull requests. Never merge without owner
  approval. Do not force-push, delete branches, discard changes, or perform other
  destructive operations without explicit authorization.
- Tag only significant **tested** checkpoints. An approved plan is not a tested
  instrument. Consult `docs/DECISIONS.md` before changing architectural choices.
- At task end update progress, decisions, affected architecture, test results,
  known issues, and changelog. Report functionality/files changed, validation,
  limitations, and the next task. Repository documentation is durable memory.
