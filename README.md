# TapDrum

Camera-based virtual percussion instrument for Logic Pro.

The intended product lets a musician tap an ordinary tabletop with fingers and
palms, sending editable MIDI performances to a Logic Pro drum instrument.
Camera data will be processed locally. Physical contact recognition and musical
latency are research questions, not demonstrated capabilities.

**Status: reviewed tracking trial; overlay correction and guided playing-area
calibration implemented in source, native retest pending.** Twenty-five shared
Core tests pass on Linux. The initial app is visibly running in the owner trial.
Strike recognition, MIDI and sound are later milestones. The native macOS
specification supersedes an earlier browser drum-pad suggestion.

## Try the tracking prototype on your Mac

See [the Mac build/run guide](docs/BUILD_AND_RUN.md) and
[the calibration/retest guide](docs/CALIBRATION.md). With this feature branch
checked out and Xcode installed, run from the repository directory:

```sh
./scripts/run-macos.command
```

The script runs tests, builds and locally signs `.build/TapDrum.app`, then opens
it. Click **Start camera** to request camera access. It does not request the
microphone, save footage, produce sound, or send MIDI. The script targets macOS
14+; actual Apple Silicon compatibility must still be verified on the owner's
Mac. There is no prebuilt or notarized application release yet.

## Start here

- [Product specification](docs/PRODUCT_SPEC.md) and [requirements](docs/REQUIREMENTS.md)
- [Feasibility assessment](docs/FEASIBILITY.md) and [research evidence](docs/RESEARCH.md)
- [Proposed architecture](docs/ARCHITECTURE.md) and [technology comparison](docs/TECH_STACK.md)
- [Milestones and approval gates](docs/IMPLEMENTATION_PLAN.md)
- [Test protocol](docs/TEST_PLAN.md) and [actual results](docs/TEST_RESULTS.md)
- [Reviewed trial and diagnostic samples](docs/TRIAL_2026_10_27.md)
- [Current progress](docs/PROGRESS.md), [known issues](docs/KNOWN_ISSUES.md),
  [decisions](docs/DECISIONS.md), and [changelog](docs/CHANGELOG.md)
- [Mac information and manual checks](docs/HARDWARE_CHECKLIST.md)
- [Instructions for future development sessions](AGENTS.md)

## Development environment

The current cloud workspace is Linux x86_64. A signature-verified Swift 6.0.3
toolchain supports the shared Core tests; Apple's macOS frameworks, Xcode, and
Logic Pro are unavailable here. The package deliberately excludes the app target
on Linux. Native builds/camera tests require the owner's Mac; MIDI and Logic
integration are not implemented. There are no third-party package dependencies,
downloaded models or sample libraries.
Owner reports a 2020 M1 MacBook Pro with 8 GB, macOS 26.5.2, Logic Pro 10.7.2,
Xcode 26.6, and iPhone 17 Pro on iOS 26.6.2 with an original data cable. No
macOS/Logic/Xcode version is claimed tested until verified there. The first
experiment is camera-only, without recordings.

The owner approved M1 and requested corrections/calibration after the trial. The standalone controller is intended to feed an
existing Logic drum instrument in later milestones. A custom sampler or Audio
Unit remains deferred until MIDI recording works. The current guided area step
does not validate physical contact or complete M2. Corrected tracking and region
interaction need a native retest before strike recognition progresses.
