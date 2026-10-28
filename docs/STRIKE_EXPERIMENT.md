# Milestone 2 — camera-only motion experiment

Status: source implemented; 48 Core tests pass in cloud. The new native build,
reference controls, recognition accuracy and resource impact need the owner's Mac.
Prior overlay/area checks passed in the owner's report on 2026-10-28. This does
not complete tracking soak/occlusion tests or establish physical contact accuracy.

## Run

Quit TapDrum. In your existing checkout:

```sh
git fetch origin
git switch feat/strike-recognition-experiment
git pull --ff-only
./scripts/run-macos.command
```

The script should run 48 Core tests before building/opening the Mac app. Stop and
share the first error if it fails. No local agent, new dependency or recording is
needed. Keep the fixed camera angle, 1280×720/30 fps, normal lighting and overlay
cutoff 0.72. Do not change resolution while comparing this version's performance.

## Learn one contact first

1. Start the camera; check alignment as before. Set four playing-area corners
   around the tabletop in circular order. Include enough image margin that both
   resting and lifted fingertip estimates project inside the region.
2. Scroll the diagnostics panel to **Strike experiment**. Choose the estimated
   hand label matching the overlay and **Index**. Keep the hand in this playing
   position for the experiment. Mirroring changes display only.
3. Place that fingertip on the table, wrist still. Click **Learn rest** and hold
   steadily until the status says the rest reference was learned (at least 0.5 s
   and 12 usable samples). Button movement can disturb the hand: use the other
   hand for the mouse and wait for the status before proceeding.
4. Lift only the selected finger clearly, without moving the wrist/turning the
   hand. Click **Learn lifted** and hold steadily until ready. If the lift is too
   small/noisy or pose changed, follow the message and retry. No reference files
   or footage are saved. Learning a reference pauses all detection.
5. Click **Enable detection**. Lift and briefly hold the finger to arm it. Watch
   **Rest 0 → lifted 1** and the state. Tap and lift with a natural brief rebound.
   The selected event count and timestamped entries should increment once per
   recognized approach/reversal. A slow placement or a hit held on the table may
   intentionally produce no event; note that limitation rather than changing the
   trial labels. No MIDI or sound is produced yet.
6. Pause detection before clearing counts or changing the experiment. Learn other
   finger/hand slots in the same way; already learned references remain for the
   capture run. Enable detection again to test calibrated contacts together.
   There are 12 slots, not a claim that all 12 work accurately on a real camera.

Palm is a separate experiment: select **Palm proxy**, learn palm resting and then
lifted with the entire palm/hand. It uses the five-anchor center proxy's absolute
image motion, not a measured palm-base patch. Finger motion is wrist-relative and
palm-size-normalized. Keep palm results separate from finger results.

## First live trial without recordings

Start with one calibrated index finger and then the other hand. Use a live
observer if available. Keep actual contact/no-contact labels independent of the
counter; do not relabel a missed tap as hovering to improve the result.

- Perform 20 isolated deliberate taps about one second apart. For each, note
  whether the selected count rose by exactly one, zero, or more than one and
  whether another contact triggered. Report actual completed taps and misses,
  duplicates and attribution errors, not just a final total.
- Try 30 seconds each of rest, lifting, hovering, and near-table no-contact
  down/up reversals. Report extra events for each condition. A near-contact
  reversal can be visually indistinguishable from a real hit: failure here is
  a feasibility finding, not permission to move straight to MIDI.
- Hide/reveal the hand during approach, move outside the area, and test loss and
  reacquisition. No impact should be manufactured on reacquisition; a fresh lift
  must arm it again. Moving the playing position requires learning references
  again; moving the camera requires resetting the area too.
- Then try alternating fingers and two calibrated contacts together. Record
  observed problems; fast/chord precision remains unverified when live labels
  cannot establish exactly what happened. Full held-out scoring is in
  [TEST_PLAN.md](TEST_PLAN.md), not satisfied by this short first trial.
- Stop/restart capture and change area: detection, references, counters and recent
  events must clear. Mirror/resize must preserve calibration. Test disconnect
  recovery if practical. Never continue output from an old run/revision.

Send results as text. Also report analyzed FPS, Vision p50/p95, Recognition p50/p95,
PTS→callback p50/p95, CPU, physical footprint, thermal state and any dropped/failure
counts. The recognition timing includes the calibration/disabled path in its
rolling window; compare enabled steady-state values after at least 240 frames.
The frame counter should advance near the analysis rate even though UI refresh is
10 Hz. Native CPU/memory increases are unmeasured until this test.

## Algorithm and evidence limits

The initial fixed experimental rules are deliberately interpretable:

| Rule | Current experiment value |
| --- | --- |
| Required input confidence | Each used joint ≥0.72, separate from the overlay slider |
| Reference window | ≥0.5 s and ≥12 consecutive usable samples; 4 s overall timeout |
| Rest/lift separation | ≥0.12 normalized palm-size units for fingers; ≥0.012 image units for palm; ≥6× observed reference noise |
| Release | Projected level ≥0.65 for ≥25 ms |
| Approach | Toward rest at ≥3 calibrated spans/second |
| Candidate | Level ≤0.2, within the reference corridor |
| Confirmation | Reverse ≥0.08 spans above the local minimum within 120 ms |
| Repeat | ≥60 ms since last event and a new credible release; no time-only retrigger |
| Lost sample / gap | Missing/uncertain input or >100 ms gap disarms; >250 ms source gap invalidates area/references |

Pose-scale/orientation, wrist-position and perpendicular-motion gates reject
repositioning. A tilted camera's lift direction is learned from the two
references; image vertical is not assumed to mean height. Fixed position,
visibility and hand identity are assumptions, not guaranteed tracking. Unknown
or duplicate handedness suppresses a contact; undetected unique-label swaps are
still a risk. Automatic camera-motion detection is not implemented.

Events contain a per-experiment ID, calibration version, hand/contact, source
candidate/confirmation timestamps, host recognition time, peak normalized
approach speed, and input-joint confidence. Source and host timestamps are distinct
clock domains. The UI shows only the latest five; memory retains at most 32 and
aggregate counts for 12 slots. Reference collection keeps streaming sums and
noise estimates, and detectors keep a previous scalar/candidate extremum. No raw
trajectories, video/audio files, disk event log or network output are created.

**Reversal wait** measures source-frame evidence delay, not physical latency.
It may add one or more frames to camera/analysis delay. Recognition duration is
CPU-path time, not contact-to-sound time; candidate timestamping cannot undo the
wait. No real-time drumming suitability, precision/recall, end-to-end latency or
force estimate is claimed. Camera-only hover discrimination remains unproven.

After successful held-out recognition tests, the next milestone is MIDI-only
output to a Logic Pro software instrument track. Logic and the chosen drum plugin
provide all sounds and audio-stem bouncing; TapDrum will not include a sampler or
custom sound instrument under the owner's 2026-10-28 scope correction.
