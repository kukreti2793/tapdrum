# Technology comparison

Status: owner reports native capture/overlay/area spot checks passed. M2 motion
experiment source and 48 Core tests implemented; native recognition validation
pending. MIDI is future. Sound generation/custom AU are outside corrected scope.
See [RESEARCH.md](RESEARCH.md) for source access limits and evidence levels.

## Hand tracking

| Candidate | Integration and outputs | Performance/limitations | Licensing and decision |
| --- | --- | --- | --- |
| Apple Vision hand pose | Implemented VN adapter sets maximumHandCount=2, explicit joint mapping/chirality. Official docs: hand pose macOS 11+, chirality macOS 12+; app floor is 14 | No app-downloaded model; target-Mac throughput/accuracy unmeasured. Sparse landmarks do not prove contact/palm pressure | System framework. **Approved M1 candidate implemented**, owner reports native build/tracking spot checks passed; exhaustive validation pending |
| MediaPipe Hand Landmarker | Official C++ Tasks API exposes handedness, normalized/world landmarks, confidence thresholds and asynchronous timestamped operation; two hands must be configured explicitly | Requires a model bundle and integration/dependency work. Relative/world model estimates are not calibrated contact depth. Native macOS distribution/acceleration must be proven; iOS package support does not prove macOS support | Repository Apache-2.0 verified; exact model asset/dependency licenses and redistribution terms still require review. **Comparison fallback**, not installed |
| Optical flow / classical image processing | Can add local motion cues or camera-motion checks without replacing the tracker | Lighting/texture/occlusion sensitive; cannot independently label all fingers or prove contact; full-frame flow adds cost | Prefer Apple APIs if suitable; introducing OpenCV would require a specific algorithm, dependency/license review and profile. **Selective experiment only** |
| Custom Core ML hand/contact model | Potential native inference with a selected converted/trained model | Requires labeled dataset, conversion/accuracy evaluation and maintenance; no evidence it outperforms existing candidates | Model/data license and training budget unknown. **Defer unless measured gaps justify it** |

No candidate has been benchmarked on the owner's Mac. Do not rank accuracy,
memory, GPU/Neural Engine use, or latency from marketing claims. Compare the same
camera, images, two-hand workload, and held-out labels before changing backends.

## Platform and integration

| Concern | Proposed first approach | Alternatives and unresolved details |
| --- | --- | --- |
| Native application | SwiftPM, Swift tools 5.9/Swift 5 mode, SwiftUI/AppKit, macOS 14 deployment floor | Owner reports Xcode 26.6; official table lists macOS 26.2–26.x host, macOS 26.5 SDK, Swift 6.3 compiler. Owner reports calibration build/open passed; new recognition build and release installation remain unverified |
| Camera | AVFoundation capture and discovery, runtime format enumeration | Continuity baseline macOS 13+/iOS 16+/iPhone XR+; dedicated continuityCamera device type macOS 14+. Wired/wireless latency must be measured. No universal frame-rate/resolution guarantee |
| Calibration/math | Core convex quadrilateral/homography plus streaming per-contact rest/lift means and noise | Projected positions, not metric depth/contact. Native area checks passed per owner; reference controls still need native tests |
| Strike classification | Implemented per-contact timestamped approach/reversal with fresh-release and uncertainty suppression; bounded scalar state/counters | Native recognition/hover accuracy and cost unmeasured. Optical flow requires evidence; audio fusion excluded by current camera-only choice |
| MIDI | CoreMIDI virtual source, optional selected destination | Official docs verify source publication via MIDIReceivedEventList and destination send via MIDISendEventList, with host-clock timestamps. MIDI 1.0 semantics first; SDK/receiver tests still required. IAC is diagnostic fallback |
| All sounds | User-chosen compatible Logic drum plugin | TapDrum sends MIDI only; Logic records editable MIDI and bounces plugin audio to stems. No sample libraries or app sound engine |
| Persistence | Versioned validated local settings/presets | Exact storage format and migration policy at Milestone 3 |
| Tests | XCTest: 48 cases pass (25 prior + 9 detector + 14 experiment) under verified Swift 6.0.3 Linux; Core strict concurrency type-check | Mac source syntax parsed only. Owner reports earlier geometry checks passed; new recognition UI/build/hardware tests pending. No recording/replay feature |
| Packaging | Local `.app` bundle/ad-hoc signing procedure implemented in build script | Script has syntax/platform-guard checks in Linux; owner reports native build/open passed. Detailed signing/TCC failure paths remain unverified. No sandbox/notarized distribution claim |
| Custom instrument | Removed by owner on 2026-10-28 | No sampler/AU deliverable; all drum sounds belong to the chosen Logic plugin |

## Resource policy

No ML models, third-party package dependencies, Apple SDKs or sample libraries
were downloaded. For M1 Core validation only, an official 784 MB signed Linux
Swift toolchain was downloaded/verified outside the checkout (about 3.3 GB with
archive/extracted files). It is not a Mac application dependency. Before any
later model download, record exact version, verified origin/hash, compressed and
installed size, license, expected memory/runtime cost, and purpose. Preserve TLS,
signature and checksum verification. No paid service or cloud inference.
