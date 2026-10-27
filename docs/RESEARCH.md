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

## Official Apple documentation retrieved and inspected

Apple's sites initially returned proxy tunnel 403. Later live checks succeeded;
the documentation JSON and support articles below were retrieved and read.
This supersedes the earlier Apple-access blocker. Copies are in the research
scratch directory. Documentation is not a substitute for native execution.

| Source | Verified finding | Remaining validation |
| --- | --- | --- |
| [VNDetectHumanHandPoseRequest](https://developer.apple.com/documentation/vision/vndetecthumanhandposerequest), [maximumHandCount](https://developer.apple.com/documentation/vision/vndetecthumanhandposerequest/maximumhandcount), [chirality](https://developer.apple.com/documentation/vision/vnhumanhandposeobservation/chirality) | VN hand pose is documented from macOS 11, chirality from macOS 12; maximum hand count defaults to two and selection is ordered by relative hand size | Selected SDK/request revision, real two-hand tabletop accuracy, confidence handling and throughput |
| [Continuity Camera support](https://support.apple.com/en-us/102546) | Wired/wireless operation; macOS 13+, iOS 16+, iPhone XR+; shared Apple Account with 2FA, nearby Wi-Fi/Bluetooth, USB trust for wired use; interruptions can pause capture | Actual account/device configuration, available modes and measured transport latency; no latency guarantee in source |
| [Continuity developer sample](https://developer.apple.com/documentation/avfoundation/supporting-continuity-camera-in-your-macos-app), [dedicated device type](https://developer.apple.com/documentation/avfoundation/avcapturedevice/devicetype-swift.struct/continuitycamera) | Discovery/preferred-camera observation and connection changes; dedicated continuityCamera type documented from macOS 14 | Older sample uses externalUnknown and includes microphone capture; do not run unchanged under camera-only consent. Check modern SDK discovery/privacy configuration |
| [Video data output](https://developer.apple.com/documentation/avfoundation/avcapturevideodataoutput), [late-frame handling](https://developer.apple.com/documentation/avfoundation/avcapturevideodataoutput/alwaysdiscardslatevideoframes), [format frame-rate ranges](https://developer.apple.com/documentation/avfoundation/avcapturedevice/format/videosupportedframerateranges) | Delegate access to frames; default late-frame discard; buffering old frames can increase memory; per-format frame-rate ranges; warning against unnecessary BGRA conversion | Actual device modes, native pixel format/tracker compatibility, source clock/exposure meaning and frame age |
| [Capture authorization](https://developer.apple.com/documentation/avfoundation/requesting-authorization-to-capture-and-save-media), [camera purpose string](https://developer.apple.com/documentation/bundleresources/information-property-list/nscamerausagedescription) | Explicit camera authorization and privacy-purpose configuration are part of capture setup | App signing/sandbox/entitlement configuration, denied/revoked paths on target OS; no microphone request in first prototype |
| [Virtual source creation](https://developer.apple.com/documentation/coremidi/midisourcecreatewithprotocol(_:_:_:_:)), [source publication](https://developer.apple.com/documentation/coremidi/midireceivedeventlist(_:_:)), [destination sending](https://developer.apple.com/documentation/coremidi/midisendeventlist(_:_:_:)), [MIDITimeStamp](https://developer.apple.com/documentation/coremidi/miditimestamp) | Create app-owned virtual source then publish via MIDIReceivedEventList; destination sends use MIDISendEventList; timestamp uses mach_absolute_time host clock; protocol-aware source/event APIs documented macOS 11+ | Correct MIDI 1.0 protocol/event encoding, receiver evidence, persistent endpoint identity, cleanup and Logic 10.7.2 behavior |
| [AUAudioUnit](https://developer.apple.com/documentation/audiotoolbox/auaudiounit), [extension template](https://developer.apple.com/documentation/avfaudio/creating-an-audio-unit-extension), [render contract](https://developer.apple.com/documentation/audiotoolbox/auinternalrenderblock), [document state](https://developer.apple.com/documentation/audiotoolbox/auaudiounit/fullstatefordocument) | AUAudioUnit hosts v2/v3, including extension process options; an Instrument accepts MIDI and produces audio; rendering receives time-ordered events; document state supports host persistence | Actual Logic compatibility, sandbox/lifecycle, sample loading, real-time safety and signing; no camera-in-plugin assumption justified |
| [Logic inter-app MIDI guide](https://support.apple.com/guide/logicpro/record-midi-messages-from-another-music-app-lgcp9f309701/mac), [bounce guide](https://support.apple.com/guide/logicpro/bounce-a-project-to-an-audio-file-lgcp785a41c3/mac) | Current guide documents a Logic Pro Virtual In destination and rendering software-instrument tracks to audio files | Current guide is not version-specific proof for the owner's 10.7.2. App-owned CoreMIDI source, exact input controls, editable recording and bounce must be tested there |
| [Xcode support table](https://developer.apple.com/support/xcode/) | Retrieved Xcode 26.6 row lists macOS Tahoe 26.2–26.x host, macOS 26.5 SDK and Swift 6.3 compiler | Reported macOS 26.5.2 is within the documented host range; installed/active tools and native build remain unverified |

The exact minimal deployment target is not chosen merely from the oldest one of
these APIs. All selected calls, the actual target OS and distribution needs must
be checked together. Nothing here certifies Logic 10.7.2 on macOS 26.5.2.

## Remaining source/network limitations

The [Google Hand Landmarker guide](https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker)
still returned proxy tunnel 403 at the latest check. Its primary repository
API/license sources above were accessible; native macOS packaging, model terms
and acceleration remain future evaluation tasks, not established capabilities.

The environment draft includes `developer.apple.com`, `support.apple.com`,
`ai.google.dev`, and `api.github.com`, preserving the package-manager preset.
Saving was confirmed and requires publication; saving itself does not execute
scripts, apply settings or publish. Current Apple and GitHub PR operations were
independently checked after the initial failures. A GitHub REST read initially
failed, but authenticated branch push and draft PR creation subsequently
succeeded without new credentials. No token was requested.

## Research conclusion and next questions

Native capture + replaceable hand tracking + temporal recognition + CoreMIDI is
the smallest useful proposed architecture. Evidence does **not** settle contact
detection, camera transport latency, supported deployment versions, or host
integration. Core Apple API research and owner version reports are now available;
verify selected APIs and tool activation on the target Mac before implementation.
Camera-only/no-recording instructions currently rule
out microphone experiments and recorded labeled footage; use the live protocol
and state which timing/accuracy conclusions remain unavailable.
