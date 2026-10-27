# Technology comparison

Status: native capture/Vision direction approved and implemented for M1; native
validation pending. Core tests run on Linux; later subsystems remain proposals.
See [RESEARCH.md](RESEARCH.md) for source access limits and evidence levels.

## Hand tracking

| Candidate | Integration and outputs | Performance/limitations | Licensing and decision |
| --- | --- | --- | --- |
| Apple Vision hand pose | Implemented VN adapter sets maximumHandCount=2, explicit joint mapping/chirality. Official docs: hand pose macOS 11+, chirality macOS 12+; app floor is 14 | No app-downloaded model; target-Mac throughput/accuracy unmeasured. Sparse landmarks do not prove contact/palm pressure | System framework. **Approved M1 candidate implemented**, native SDK/build validation pending |
| MediaPipe Hand Landmarker | Official C++ Tasks API exposes handedness, normalized/world landmarks, confidence thresholds and asynchronous timestamped operation; two hands must be configured explicitly | Requires a model bundle and integration/dependency work. Relative/world model estimates are not calibrated contact depth. Native macOS distribution/acceleration must be proven; iOS package support does not prove macOS support | Repository Apache-2.0 verified; exact model asset/dependency licenses and redistribution terms still require review. **Comparison fallback**, not installed |
| Optical flow / classical image processing | Can add local motion cues or camera-motion checks without replacing the tracker | Lighting/texture/occlusion sensitive; cannot independently label all fingers or prove contact; full-frame flow adds cost | Prefer Apple APIs if suitable; introducing OpenCV would require a specific algorithm, dependency/license review and profile. **Selective experiment only** |
| Custom Core ML hand/contact model | Potential native inference with a selected converted/trained model | Requires labeled dataset, conversion/accuracy evaluation and maintenance; no evidence it outperforms existing candidates | Model/data license and training budget unknown. **Defer unless measured gaps justify it** |

No candidate has been benchmarked on the owner's Mac. Do not rank accuracy,
memory, GPU/Neural Engine use, or latency from marketing claims. Compare the same
camera, images, two-hand workload, and held-out labels before changing backends.

## Platform and integration

| Concern | Proposed first approach | Alternatives and unresolved details |
| --- | --- | --- |
| Native application | SwiftPM, Swift tools 5.9/Swift 5 mode, SwiftUI/AppKit, macOS 14 deployment floor | Owner reports Xcode 26.6; official table lists macOS 26.2–26.x host, macOS 26.5 SDK, Swift 6.3 compiler. Native build/install remains unverified |
| Camera | AVFoundation capture and discovery, runtime format enumeration | Continuity baseline macOS 13+/iOS 16+/iPhone XR+; dedicated continuityCamera device type macOS 14+. Wired/wireless latency must be measured. No universal frame-rate/resolution guarantee |
| Calibration/math | Small native module using standard math facilities | Homography only for on-plane coordinates; depth/reversal require separate evidence |
| Strike classification | Small temporal state machines and bounded histories | Optical-flow or audio fusion only after labeled comparison |
| MIDI | CoreMIDI virtual source, optional selected destination | Official docs verify source publication via MIDIReceivedEventList and destination send via MIDISendEventList, with host-clock timestamps. MIDI 1.0 semantics first; SDK/receiver tests still required. IAC is diagnostic fallback |
| Initial sounds | Existing Logic drum instrument | Kit note maps/voice behavior must be checked; no sample licensing/downloads now |
| Persistence | Versioned validated local settings/presets | Exact storage format and migration policy at Milestone 3 |
| Tests | XCTest for dependency-free shared Core; ten tests passed with verified Swift 6.0.3 Linux toolchain | Native app syntax parsed only. No real-camera replay/recording fixtures; current privacy choice is no recordings. Mac integration runner still required |
| Packaging | Local `.app` bundle/ad-hoc signing procedure implemented in build script | Script has only syntax/platform-guard checks in Linux. Native build/signing/TCC unverified. No sandbox/notarized distribution claim |
| Custom instrument | Compare AUv2 and AUv3 at Milestone 5 | AUv2 has a long macOS host history; AUv3 has extension lifecycle constraints. Neither is selected or implemented; host compatibility needs actual tests |

## Resource policy

No ML models, third-party package dependencies, Apple SDKs or sample libraries
were downloaded. For M1 Core validation only, an official 784 MB signed Linux
Swift toolchain was downloaded/verified outside the checkout (about 3.3 GB with
archive/extracted files). It is not a Mac application dependency. Before any
later model download, record exact version, verified origin/hash, compressed and
installed size, license, expected memory/runtime cost, and purpose. Preserve TLS,
signature and checksum verification. No paid service or cloud inference.
