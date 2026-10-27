# Technology comparison

Status: recommendations for evaluation, not final choices or measured results.
See [RESEARCH.md](RESEARCH.md) for source access limits and evidence levels.

## Hand tracking

| Candidate | Integration and outputs | Performance/limitations | Licensing and decision |
| --- | --- | --- | --- |
| Apple Vision hand pose | Official docs: VN hand-pose request available macOS 11+, chirality macOS 12+, maximum hand count defaults to two; selected SDK/revision still needs checking | No extra downloaded model expected; M1 two-hand throughput, occlusion stability and tabletop pose accuracy unmeasured. Sparse landmarks do not measure table contact or palm pressure | System framework under Apple SDK terms; no bundled third-party model proposed. **Recommended first experiment**, pending owner approval and native validation |
| MediaPipe Hand Landmarker | Official C++ Tasks API exposes handedness, normalized/world landmarks, confidence thresholds and asynchronous timestamped operation; two hands must be configured explicitly | Requires a model bundle and integration/dependency work. Relative/world model estimates are not calibrated contact depth. Native macOS distribution/acceleration must be proven; iOS package support does not prove macOS support | Repository Apache-2.0 verified; exact model asset/dependency licenses and redistribution terms still require review. **Comparison fallback**, not installed |
| Optical flow / classical image processing | Can add local motion cues or camera-motion checks without replacing the tracker | Lighting/texture/occlusion sensitive; cannot independently label all fingers or prove contact; full-frame flow adds cost | Prefer Apple APIs if suitable; introducing OpenCV would require a specific algorithm, dependency/license review and profile. **Selective experiment only** |
| Custom Core ML hand/contact model | Potential native inference with a selected converted/trained model | Requires labeled dataset, conversion/accuracy evaluation and maintenance; no evidence it outperforms existing candidates | Model/data license and training budget unknown. **Defer unless measured gaps justify it** |

No candidate has been benchmarked on the owner's Mac. Do not rank accuracy,
memory, GPU/Neural Engine use, or latency from marketing claims. Compare the same
camera, images, two-hand workload, and held-out labels before changing backends.

## Platform and integration

| Concern | Proposed first approach | Alternatives and unresolved details |
| --- | --- | --- |
| Native application | Swift, SwiftUI with AppKit bridges only when needed | Owner reports Xcode 26.6; official table lists macOS 26.2–26.x host, macOS 26.5 SDK, Swift 6.3 compiler. Native installation/build and app deployment target remain unverified; no project created |
| Camera | AVFoundation capture and discovery, runtime format enumeration | Continuity baseline macOS 13+/iOS 16+/iPhone XR+; dedicated continuityCamera device type macOS 14+. Wired/wireless latency must be measured. No universal frame-rate/resolution guarantee |
| Calibration/math | Small native module using standard math facilities | Homography only for on-plane coordinates; depth/reversal require separate evidence |
| Strike classification | Small temporal state machines and bounded histories | Optical-flow or audio fusion only after labeled comparison |
| MIDI | CoreMIDI virtual source, optional selected destination | Official docs verify source publication via MIDIReceivedEventList and destination send via MIDISendEventList, with host-clock timestamps. MIDI 1.0 semantics first; SDK/receiver tests still required. IAC is diagnostic fallback |
| Initial sounds | Existing Logic drum instrument | Kit note maps/voice behavior must be checked; no sample licensing/downloads now |
| Persistence | Versioned validated local settings/presets | Exact storage format and migration policy at Milestone 3 |
| Tests | Native unit tests plus replay fixtures and manual Mac/Logic protocols | Swift Testing vs XCTest chosen against installed toolchain; Linux is not a native integration runner |
| Packaging | Native app first; signing/notarization for distribution later | App Sandbox, privacy descriptions/entitlements and camera behavior must be verified on target; no distribution claim now |
| Custom instrument | Compare AUv2 and AUv3 at Milestone 5 | AUv2 has a long macOS host history; AUv3 has extension lifecycle constraints. Neither is selected or implemented; host compatibility needs actual tests |

## Resource policy

No ML models, package dependencies, SDKs, or sample libraries are downloaded for
Milestone 0. Retrieved research source text is outside the checkout. Before any
later model download, record exact version, verified origin/hash, compressed and
installed size, license, expected memory/runtime cost, and purpose. Preserve TLS,
signature and checksum verification. No paid service or cloud inference.
