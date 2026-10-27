# Research evidence and open verification

Research date: 2026-10-27. No native experiments have been run. A retrieved source
establishes only the facts it actually contains, not musical performance.

## Retrieved primary sources

MediaPipe repository revision inspected:
`7c0ddec593580937fad5fcbcb792ad4fcbc3b67d` (resolved with native Git).

| Source | Verified observation | Limits |
| --- | --- | --- |
| [HandLandmarker C++ API](https://github.com/google-ai-edge/mediapipe/blob/7c0ddec593580937fad5fcbcb792ad4fcbc3b67d/mediapipe/tasks/cc/vision/hand_landmarker/hand_landmarker.h) | Image/video/live-stream modes; configurable hand count defaults to one; three confidence thresholds; asynchronous callback; monotonically increasing millisecond timestamps required for video/live stream | No M1 latency, accuracy, distribution or native Swift integration guarantee |
| [Result structure](https://github.com/google-ai-edge/mediapipe/blob/7c0ddec593580937fad5fcbcb792ad4fcbc3b67d/mediapipe/tasks/cc/vision/hand_landmarker/hand_landmarker_result.h) | Handedness classifications, normalized landmarks and world-landmark results | World-landmark output is not a verified table plane/contact sensor |
| [Hand graph](https://github.com/google-ai-edge/mediapipe/blob/7c0ddec593580937fad5fcbcb792ad4fcbc3b67d/mediapipe/tasks/cc/vision/hand_landmarker/hand_landmarker_graph.cc) | Separate detector/landmark graph, tracking/reuse, model bundle configuration and multiple-hand processing | Source existence does not prove a supported native macOS package or delegate |
| [README](https://github.com/google-ai-edge/mediapipe/blob/7c0ddec593580937fad5fcbcb792ad4fcbc3b67d/README.md) | On-device intent; links to Android/iOS/Python/web setup and lower-level framework | iOS setup is not proof of macOS deployment support |
| [Repository license](https://github.com/google-ai-edge/mediapipe/blob/7c0ddec593580937fad5fcbcb792ad4fcbc3b67d/LICENSE) | Apache License 2.0 | Selected model assets and all redistributed dependencies still need their own license/provenance review |

The downloaded primary files were read over verified HTTPS. Their local research
copies and SHA-256 manifest are under `/workspace/scratch/tapdrum-m0-research`,
outside the project. This scratch directory is not project memory; the pinned
links and findings above are the durable evidence. No model was downloaded.

The legacy `docs/solutions/hands.md` was also retrieved, but it identifies itself
as a legacy solution and redirects readers to current documentation. It is not
used as the basis for a new legacy Hands API implementation.

## Secondary API corroboration

The .NET macOS bindings were retrieved from `dotnet/macios` main, whose head
resolved during this research to `4f41b3187b275b7c8a5537e652bfc00874db53be`.
They are a secondary source, not Apple's selected SDK or official documentation.
They corroborate the presence of candidate API surfaces only:

- [Vision binding](https://github.com/dotnet/macios/blob/4f41b3187b275b7c8a5537e652bfc00874db53be/src/vision.cs):
  hand-pose request, finger/wrist joint names, maximum hand count, recognized
  points and chirality.
- [AVFoundation binding](https://github.com/dotnet/macios/blob/4f41b3187b275b7c8a5537e652bfc00874db53be/src/avfoundation.cs):
  capture device types, frame durations, sample-buffer delegate and late-frame
  discard configuration.
- [Audio Unit binding](https://github.com/dotnet/macios/blob/4f41b3187b275b7c8a5537e652bfc00874db53be/src/audiounit.cs):
  render/resource lifecycle and full-state persistence surfaces.

Do not infer minimum macOS versions, sandbox behavior, model accuracy, or
performance from these bindings. Verify the installed Xcode SDK before use.

## Official documentation awaiting access/SDK verification

Requests to the following pages failed with proxy tunnel `403 Forbidden` in the
current cloud runtime, including a recheck after saving domain requirements:

- [Apple Vision hand-pose request](https://developer.apple.com/documentation/vision/vndetecthumanhandposerequest)
  and its documentation JSON endpoint.
- [Apple Continuity Camera support](https://support.apple.com/en-us/102546).
- [Google Hand Landmarker guide](https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker).

Additional official research entry points are listed below as **unread targets**,
not verified citations for specific behavior:

| Topic | Official entry point | Verification needed |
| --- | --- | --- |
| Camera capture | [AVFoundation](https://developer.apple.com/documentation/avfoundation) | Capture session/discovery, actual formats/frame-rate ranges, source clock, interruptions, permission descriptions/entitlements, Continuity discovery keys for chosen SDK |
| Vision | [Vision](https://developer.apple.com/documentation/vision) | Deployment availability, chirality/revisions, confidence semantics, orientation, two-hand request and available optical flow |
| MIDI | [CoreMIDI](https://developer.apple.com/documentation/coremidi) | Virtual source vs destination APIs, protocol selection, send/receive direction, host timestamps and lifecycle |
| Audio Unit | [AUAudioUnit](https://developer.apple.com/documentation/audiotoolbox/auaudiounit) | AUv2/AUv3 instrument lifecycle, MIDI input/state, host/extension restrictions and render-thread contract |
| Logic recording | [Logic Pro user guide](https://support.apple.com/guide/logicpro/welcome/mac) | Input filtering/routing, instrument selection, editable MIDI recording, latency settings and bounce on owner's version |
| Toolchain | [Xcode support](https://developer.apple.com/support/xcode/) | Exact macOS host, SDK, compiler and deployment compatibility |

The environment draft now includes `developer.apple.com`, `support.apple.com`,
`ai.google.dev`, and `api.github.com`, preserving the package-manager preset.
Draft saving succeeded but did not change runtime access or publish. The owner
can review/save settings and publish the environment; then retry affected reads.
No network denial is interpreted as a missing GitHub token. Native Git reads
already work; GitHub API access is a separately blocked operation.

## Research conclusion and next questions

Native capture + replaceable hand tracking + temporal recognition + CoreMIDI is
the smallest useful proposed architecture. Evidence does **not** settle contact
detection, camera transport latency, supported deployment versions, or host
integration. Complete official Apple API verification and target-Mac inventory
before finalizing choices. Camera-only/no-recording instructions currently rule
out microphone experiments and recorded labeled footage; use the live protocol
and state which timing/accuracy conclusions remain unavailable.
