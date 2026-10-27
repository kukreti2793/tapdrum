# Feasibility assessment and risk register

Milestone 0 assessment: a native camera→MIDI experiment is plausible, but tabletop
strike recognition and musical responsiveness are **unproven**. This is a testable
research proposal, not a claim that the complete instrument is feasible.

| Risk | Why it matters | Smallest experiment and decision |
| --- | --- | --- |
| R-01 Contact vs hover | Monocular projected motion can look alike; inferred 3D is not physical contact | Labeled taps plus near-table no-contact reversals; compare precision/recall and false triggers. If separation fails, report a camera-only limitation before expanding scope |
| R-02 Sampling/transport latency | Frame interval and camera pipeline can consume the latency budget before inference | Enumerate/measure actual modes; compare wired and wireless iPhone with the same settings; do not assume either is faster |
| R-03 Self-occlusion and coupled fingers | Table contact hides tips; ring/little motions can follow neighboring fingers | Score every contact separately, especially chords and palm hits; do not hide weak contacts in an aggregate |
| R-04 Hand identity/mirroring | Left/right swaps route the wrong drum | Crossing/loss/reacquisition tests; anatomical labels independent of display mirroring; suppress uncertain identity |
| R-05 Palm/base interpretation | Wrist/MCP landmarks do not locate the actual contact patch | Treat a derived palm/base proxy as its own experiment and report separately; do not silently remove the requirement |
| R-06 Perspective/calibration | Image-space vertical motion need not point toward the table | Test oblique vs overhead views, rest/release references and moved cameras; invalidate unsuitable calibration |
| R-07 Resource contention | Vision competes with Logic on an 8 GB machine | Measure CPU, footprint, memory pressure, thermal state and audio overload with a fixed Logic session |
| R-08 Native/host compatibility | Cloud Linux cannot exercise Apple SDKs, TCC privacy or Logic routing; owner reports older Logic 10.7.2 with macOS 26.5.2 | Version reports and Xcode host-range documentation are available; build/run on actual Mac and test Logic there before claiming support or requesting version changes |
| R-09 Optional audio confirmation | Impacts may be confused with speech, other taps or drum playback | Separate opt-in experiment; test speaker feedback and attribution; no hidden microphone dependency |
| R-10 MIDI collisions/lifecycle | Both hands can map to identical notes; old offs may kill retriggers | Independent receiver, deterministic collision policy, fault tests and panic; verify host behavior |
| R-11 Evidence access | Apple access initially failed but later worked; Google guide remains blocked | Apple API docs and MediaPipe primary source are reviewed. Selected local SDK, model packaging/license and native behavior still need evaluation |

## Contact experiment

The detailed protocol and proposed numerical gates are in
[TEST_PLAN.md](TEST_PLAN.md). Test 12 contacts, slow and fast repeats, two-hand
alternation/chords, and negative hover/rest/lift motions in two separate sessions.
Tune only on the development split, lock parameters, then score held-out trials.
Ground truth must be independent of algorithm output. The owner selected
camera-only/no-recordings; use isolated live observer-labeled trials and disclose
unscorable fast/timing cases. Recording-based evaluation and microphone work are
not authorized. If a stronger measurement is separately approved later, record
annotation uncertainty; 30 fps footage cannot substantiate millisecond precision.

Current comparison: A, landmarks/temporal states; B, A plus selective motion
evidence. A future C, microphone confirmation, needs separate explicit permission
and is outside current scope. Keep A's outcome visible in any comparison.
A two-dimensional table region is useful, but does
not solve depth/contact by itself. Overhead views expose fingers better while
often hiding the vertical approach cue; an oblique view may reverse that trade-off.

If no camera-only condition separates taps from hover at useful precision and
recall, stop to review feasibility and a smaller supported scope with the owner.
Do not substitute gestures, external percussion hardware, or microphone-only
triggering for the product without approval.

## Performance benchmarks — proposed, not achieved

| Metric | Initial experiment target | Meaning |
| --- | --- | --- |
| Audible contact→sound latency | Median ≤30 ms, p95 ≤50 ms | Owner's aspiration; requires physical end-to-end evidence |
| Tracking throughput | Sustain actual camera rate at 30 fps minimum; test 60 fps if supported | Throughput does not establish low frame age or usable latency |
| Landmark inference duration | Provisional p50 ≤6 ms, p95 ≤12 ms at selected analysis resolution, two hands | Diagnostic allocation, not a benchmark result or guaranteed Vision capability |
| Mapping plus MIDI emission | Provisional p95 ≤2 ms, excluding pending Note Off lifetime | Measured after recognition, separate from camera/host delay |
| App footprint | Initial investigation budget ≤500 MiB physical footprint | Report peak/steady-state and memory pressure; revise using evidence |
| App CPU | Initial investigation budget ≤100% where one full core is 100% | Report instrument/tool convention, Logic workload and thermal state |
| Sustained operation | 30 minutes with fixed Logic test session; no crash, stuck owned notes or app-attributable audio overload | Not a substitute for longer release soak tests |

At 30 fps one frame is 33.3 ms; uniformly timed contact has an idealized wait
of 16.7 ms median and 31.7 ms p95 to the next frame before transport/inference.
At 60 fps these become 16.7 ms per frame, 8.3 ms median wait and 15.8 ms p95 wait.
If reversal confirmation needs one additional frame, add approximately a frame
interval. These are sampling calculations under stated assumptions, not camera
measurements or complete latency distributions. Exposure/readout, buffering,
wireless transport, inference and audible output add more delay. Prediction may
reduce delay but can produce false/early events; label it explicitly if studied.

For intuition only, a hypothetical 60 fps path with 8.3 ms sampling wait, 5 ms
camera transfer, 6 ms inference, 16.7 ms confirmation, 1 ms mapping/MIDI and 5 ms
audio totals about 42 ms. The assumed transfer/inference/audio values are not
observations; stage percentiles must not be added as if they were an end-to-end
percentile. This shows why the 30 ms median goal could fail even with fast code.

Use lower analysis resolution, bounded queues, selective processing, or a more
capable measured camera mode only when the accuracy/latency evidence supports
the trade-off. Retrospectively shifting recorded MIDI can improve editing but
does not improve what the player heard while performing.
