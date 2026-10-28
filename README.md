# TapDrum

Camera-based MIDI percussion controller for Logic Pro.

The intended product lets a musician tap an ordinary tabletop with fingers and
palms, sending editable MIDI performances to a Logic Pro drum instrument.
Camera data will be processed locally. Physical contact recognition and musical
latency are research questions, not demonstrated capabilities.

**Status: owner reports native overlay/area checks passed; M2 camera-only motion
experiment implemented in source, awaiting native recognition tests.** Forty-eight
Core tests pass on Linux. TapDrum will generate MIDI only; Logic records editable
MIDI and the user's selected drum plugin supplies all sound and audio stems.
MIDI is not implemented yet. No TapDrum sampler/custom sound plugin is planned.
The native macOS
specification supersedes an earlier browser drum-pad suggestion.

## Try the tracking prototype on your Mac

See [the strike experiment guide](docs/STRIKE_EXPERIMENT.md),
[the Mac build/run guide](docs/BUILD_AND_RUN.md) and
[the area calibration guide](docs/CALIBRATION.md). With this feature branch
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

The owner approved M1, requested necessary calibration/progress and reports the
native geometry checks passed. The current motion experiment does not validate
physical contact or complete M2. Recognition must be evaluated before MIDI/Logic
integration. The owner's MIDI-only correction removes custom sounds/sampler/AU
from the roadmap; Logic and the chosen drum plugin handle audio.
