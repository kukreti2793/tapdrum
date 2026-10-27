# TapDrum

Camera-based virtual percussion instrument for Logic Pro.

The intended product lets a musician tap an ordinary tabletop with fingers and
palms, sending editable MIDI performances to a Logic Pro drum instrument.
Camera data will be processed locally. Physical contact recognition and musical
latency are research questions, not demonstrated capabilities.

**Status: Milestone 0 — feasibility and planning. No application source, runnable
instrument, build system, or native hardware validation exists yet.** The native
macOS specification supersedes an earlier browser drum-pad suggestion.

## Start here

- [Product specification](docs/PRODUCT_SPEC.md) and [requirements](docs/REQUIREMENTS.md)
- [Feasibility assessment](docs/FEASIBILITY.md) and [research evidence](docs/RESEARCH.md)
- [Proposed architecture](docs/ARCHITECTURE.md) and [technology comparison](docs/TECH_STACK.md)
- [Milestones and approval gates](docs/IMPLEMENTATION_PLAN.md)
- [Test protocol](docs/TEST_PLAN.md) and [actual results](docs/TEST_RESULTS.md)
- [Current progress](docs/PROGRESS.md), [known issues](docs/KNOWN_ISSUES.md),
  [decisions](docs/DECISIONS.md), and [changelog](docs/CHANGELOG.md)
- [Mac information and manual checks](docs/HARDWARE_CHECKLIST.md)
- [Instructions for future development sessions](AGENTS.md)

## Development environment

The current cloud workspace is Linux x86_64. It supports documentation and Git
work, but does not have Apple's macOS frameworks, Xcode, or Logic Pro. There are
no dependencies to install or services to start for Milestone 0. Native builds,
camera tests, CoreMIDI tests, and Logic Pro recording require the owner's Mac.
Owner reports a 2020 M1 MacBook Pro with 8 GB, macOS 26.5.2, and an iPhone 17 Pro;
Xcode is downloading. No macOS/Logic/Xcode version is claimed supported until
verified there. The first experiment is camera-only, without recordings.

The provisional direction is a native standalone controller feeding an existing
Logic drum instrument. A custom sampler or Audio Unit is deferred until MIDI
recording works. The owner must answer the hardware questions and explicitly
approve Milestone 1 before application implementation starts.
