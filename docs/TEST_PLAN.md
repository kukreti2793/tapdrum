# Test plan and acceptance protocols

Status: planned, not executed. Numerical gates below are **proposals for owner
review**, not measured results or newly imposed product guarantees. Active scope
is Milestone 0. Do not start implementation to run these tests without approval.

## Evidence rules and current privacy boundary

For each run record app commit/build, exact OS/SDK/device versions, camera
mode/angle/lighting, tracker/revision, calibration/threshold settings, Logic/audio
configuration if used, commands/procedure, counts, failures and uncertainties.
Separate environment failures from product defects. Report blocked, unrun,
failed, skipped and passed checks distinctly; no empty test suite is a pass.

The owner selected **camera-only first; no recordings**. Do not write or retain
video/audio recordings, enable microphone processing, or store raw landmark trajectories.
Use ephemeral frames and live display only. Numerical trial labels, aggregate
counts/resource timings and non-sensitive test configuration can document live
tests; do not treat these as captured camera/audio datasets.

No synthetic fixture establishes vision accuracy. No software timestamp alone
establishes physical contact or audible-output time. If an acceptance criterion
cannot be measured under the current constraints, mark it **unverified**, explain
why, and request a separate experiment decision. Never relax it silently.

## H0 — inventory and feasibility review (Milestone 0)

- Confirm [hardware inventory](HARDWARE_CHECKLIST.md) and distinguish owner reports
  from independent inspection. Verify selected deployment APIs in official docs
  and the installed SDK. Compare Vision and MediaPipe integration/licensing.
- Produce risk register, proposed contracts, strike experiment, latency budget,
  phased plan and explicit unresolved questions. Check documentation links.
- Acceptance: owner has enough evidence to approve a narrow Milestone 1; all
  unsupported claims are marked, and no application code was created.
- Hardware answers, blocked Apple documentation and owner approval remain pending.

## C1/V1 — capture and tracking (Milestone 1)

On the target Mac, build with the recorded toolchain. Verify camera permissions
granted/denied, absent devices, device selection, format selection and invalid
format rejection. Test disconnect, reconnect and switching without stale frames
or crashes. Show preview, landmarks, confidence, left/right/unknown identity,
actual frame intervals, dropped frames and frame age. Mirroring affects display
only. Two hands, crossing, partial occlusion and lost/reacquired hands need tests.

Proposed initial tracking protocol: 60 seconds each of static spread fingers,
slow articulation and hand crossing under normal lighting; separately test dim
lighting and the intended tabletop pose. Count frames with usable required joints
and hand-ID errors. Suggested gate: both hands usable on ≥95% of expected visible
frames in the controlled setup and no unexplained left/right mapping changes.
Report unusable joints/contacts, confidence thresholds and all weaker conditions.

Profile at least 10 minutes at each available candidate mode, then a 30-minute
selected-mode soak. Record achieved capture/analysis FPS, capture-to-analysis
age, inference p50/p95, peak/steady physical footprint, CPU convention, thermal
state and memory pressure. Initial budgets are in [FEASIBILITY.md](FEASIBILITY.md).
Do not select a mode only because its frame rate is higher if tracking fails.
Acceptance: stable live two-hand tracking on the actual Mac with disclosed limits;
no strike recognition, MIDI, or musical-latency claim at this milestone.

## S1 — camera-only strike feasibility (Milestone 2)

### Live, non-recording protocol currently allowed

1. Calibrate playing region, camera orientation, rest/release references and
   image-space approach cues. Test a moved camera and an invalid region. Do not
   call the region a measured 3D plane or contact sensor.
2. Separate development and held-out evaluation by session/recalibration. Tune
   thresholds only on development trials, lock settings, then begin evaluation.
3. With an independent live observer where possible, perform isolated randomized
   contact/no-contact trials. The observer labels whether real contact occurred
   without using detector output. Use sufficiently spaced trials to attribute
   each event to one trial; near-surface no-contact reversals must be included.
4. For each of the 12 contacts, aim for 30 actual isolated strikes at a slow rate
   and 30 at a faster rate in the held-out session (720 positives if all contacts
   are feasible). Record actual completed counts rather than scheduled intent.
5. Include at least 10 minutes of negative activity: hovering, resting, lifting,
   repositioning, neighboring-finger motion, crossing and occlusion/reacquisition.
   Include near-surface reversals deliberately resembling taps. An observer marks
   ambiguous contact trials unscorable; do not count them as correct rejections.
6. Measure controlled repeat patterns around 2, 4, 6 and 8 strikes/second per
   tested contact, with 10-second blocks where feasible. Add 30 independently
   observed two-contact chord trials and two-hand alternating patterns. Rate and
   chord attribution that an observer cannot establish live remain unverified.
7. Repeat supported configurations with oblique/overhead views, lighting changes
   and partial occlusion. Keep every camera/mode/contact result separate.

Isolated trials support contact-level confusion counts and duplicate suppression
without retaining footage. Live human labels have limitations. Precise per-event
timing, ambiguous fast patterns, and exact simultaneous-contact attribution
cannot be certified from cue timing, intent, or manual reaction timestamps.

### Proposed scoring and gate

- A true positive is one correctly attributed strike in an independently labeled
  actual-contact trial. Additional events in that trial are duplicate false
  positives. A missed contact is a false negative; an event in a no-contact trial
  is a false positive. Wrong hand/contact is an attribution error (a false
  positive for the wrong target and false negative for the intended target).
- Report precision `TP/(TP+FP)`, recall `TP/(TP+FN)`, false triggers/minute during
  negative activity, duplicate events/actual strikes, wrong-contact rate, sample
  counts and ambiguous/unscorable counts. Report pooled and per-contact results;
  small samples need uncertainty intervals, not claims of perfect reliability.
- Proposed exploratory gate: ≥95% precision and ≥90% recall for each scored
  contact in controlled isolated trials; ≤1 false trigger/minute of negatives;
  ≤1% duplicate-event rate. Report rapid/chord performance separately. These
  thresholds are preliminary feasibility gates, not final musician-quality goals.
- Report palm/base separately. Any required contact failing the gate remains
  unresolved; do not claim all-finger support from successful index-finger trials.
- If independent labeling is unavailable, mark accuracy estimates preliminary.
  Stop for owner review if camera-only contact/hover discrimination fails.

### Optional stronger protocol — NOT currently authorized

Only after separate owner permission, use short local diagnostic clips with
independent contact labels (and an appropriate reference view/timing method).
Predefine frame rate, timing uncertainty, one-to-one same-hand/contact event
matching, a proposed ±75 ms accuracy matching window, and duplicate/unmatched
rules before evaluation. Such an accuracy window is not the latency target.
Keep tuning/evaluation sessions separate; do not tune on held-out labels.
Recorded sequence replay should reproduce event counts on pinned settings.

Microphone fusion, if ever approved, is a separate A/B experiment with speaker
feedback/noise tests. It is not part of the current camera-only acceptance test.

## M1/P1/R1 — independent MIDI and reliability (Milestone 3)

Run automated tests against synthetic strike streams, not camera timing:

- All twelve default/editable mappings, note/channel boundaries and malformed
  values; velocity clamp and sensitivity monotonicity; Note On velocity never zero.
- Correct Note On/Off bytes/order and simultaneous distinct notes at an independent
  MIDI receiver. Capture receiver observations, not merely sender logs.
- Same-note same-batch coalescing, repeated-note lifecycle, stale-off cancellation,
  route generation, stop/panic, tracking loss and camera loss. Test Logic restart
  later. Do not promise orderly cleanup after a crash; verify receiver recovery.
- Rapid alternation and out-of-order/stale timestamps; no unbounded event queue.
- Preset round-trip, invalid/corrupt/unknown-version files, atomic save failure,
  note/channel/sensitivity validation, calibration invalidation after device changes.

Acceptance: independent receiver verifies mappings, velocities, timing order and
cleanup; no outstanding owned notes after tested lifecycle paths; clear handling
of invalid presets/routes. Pure tests are not CoreMIDI transport validation.

## L1 — Logic Pro recording and bounce (Milestone 4)

1. Record exact Logic/macOS/app versions, selected single MIDI route, instrument,
   drum map, output device, sample rate, I/O buffer, low-latency mode and load.
2. Verify endpoint visibility and input filtering on that Logic version. Select a
   known drum software instrument and check representative note assignments.
3. Record a simple recognizable pattern (for example kick/snare/hi-hat for four
   bars), including alternating, simultaneous, soft/loud and repeated strikes.
4. Inspect editable note pitches, starts, lengths and velocities in Logic. Compare
   event counts with independent app/receiver counters; inspect duplicate routes.
5. Play back with the controller stopped and bounce to audio. Listen and confirm
   that the MIDI pattern produces the expected drum performance in the bounce.
6. Restart Logic/reselect routing; test stop/panic and camera loss during play.

Acceptance: owner verifies recognizable editable MIDI, playback and audio bounce,
with exact configurations and observed problems documented. A MIDI activity meter
alone is not acceptance. Timing quality is evaluated separately below.

## T1 — physical end-to-end latency

Current status: **unrun and no approved independent measurement method**. Camera
processing durations can be measured live, but do not measure tabletop contact or
audible sound. With no recordings/microphone and no independent physical timing
instrumentation agreed, the ≤30/50 ms audible goals cannot be verified.

For a separately approved measurement experiment, define independent physical
contact reference and audible-output observation on a common clock, along with
calibration/error bounds. Avoid circular use of predicted strike times as truth.
An acoustic tap vs speaker/headphone-output reference requires permission and
careful acoustic-path correction; high-speed footage needs recording consent and
adequate frame timing. No extra percussion hardware is required to play the
baseline instrument; optional laboratory measurement equipment is a separate
validation choice.

Collect ≥200 scorable hits per selected condition, raw numerical deltas and
quantile method. Report median, p95, maximum, missed/early events and measurement
uncertainty, with source frame age, inference, recognition evidence delay, MIDI
and audio portions where independently observable. Do not sum stage percentiles
as an observed end-to-end percentile. Test built-in/wired/wireless where actually
available, then repeat under the fixed Logic workload. No winner is assumed.

## D1/A1 — privacy and later instrument/release tests

Privacy review: local-only processing; no frame/audio files, telemetry/network
egress or hidden microphone activation; denied permission/revocation paths and
explicit controls if recording is separately added later. Do not retain raw
landmarks in routine test reports.

Milestone 5 only: unit-test sample voices, velocity, polyphony, sample/state loads
off the render thread, kit/preset persistence and bounded render work. Validate
with the appropriate Apple AU validator and actual Logic loading, rescan, session
save/restore, offline bounce, reload and failure paths. AUv3 extension and AUv2
component behavior require their own tests. Distribution testing includes the
chosen signing/notarization/installation route on recorded supported versions.
Milestone 6 adds long-run regression, camera/host faults and resource/latency
comparisons. No AU or distribution tests are currently runnable.
