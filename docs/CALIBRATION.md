# Fixed-angle playing-area calibration prototype

Status: owner reports native build, overlay alignment, both hands, corner/grid,
mirror/resize and Stop clearing passed on 2026-10-28. Broader tracking/soak tests
remain open. The instructions below describe the area-only branch (25 Core tests).
For the active rest/lift and motion experiment (48 tests), use
[STRIKE_EXPERIMENT.md](STRIKE_EXPERIMENT.md). Neither establishes physical contact.

## Run this version

Quit TapDrum first. In the existing Mac checkout:

```sh
git fetch origin
git switch feat/fixed-angle-calibration
./scripts/run-macos.command
```

Keep the same camera angle and **1280×720 at 30 fps**. The existing resolution
baseline is deliberately preserved: accuracy, temporal sampling and low latency
take priority over speculative CPU savings. The original mode picker remains
available, but no lower-resolution preset, analysis throttle or smoothing is added.

The build script should run **25 Core tests**, build the native app and open it.
Only the Core build/tests and Mac source syntax have run in cloud. Report the
first native error if the build fails; no local agent access is required.

## Check the corrected overlay before calibration

1. Start the camera and place one hand on the table. Wrist markers should be at
   the wrist; tip markers and names should follow the corresponding fingertips.
   The old vertically reflected display must be gone before trusting area results.
2. Check both hands separately and together, slow movement, finger lifting,
   partial occlusion and return. The reviewed clip only established one-hand
   runtime, not full tracking accuracy. A mean confidence of 0.85 is not 85% accuracy.
3. Try preview mirroring and window resizing. Points must stay attached to image
   features. The cutoff defaults to 0.72 and is remembered; finger names can be
   hidden to reduce clutter. Neither setting changes Vision inference rate.

## Mark the playing area

1. Leave the camera fixed and live. Move hands aside enough to see the intended
   tabletop region. Scroll the right diagnostics panel if necessary.
2. Click **Set area** under **Playing area**.
3. In the preview, click four corners around a flat tabletop area in circular
   order: clockwise or counterclockwise. Choose a useful four-sided region;
   do not cross diagonally between corners. The app numbers the clicks.
4. A valid selection shows a blue outline and perspective midlines. Crossed,
   concave, repeated, collinear or numerically degenerate corners are rejected;
   start the four clicks again. Clicks in black letterbox bars are rejected.
5. Put fingertips over different parts of the region. The count describes
   fingertip estimates **projecting** inside it. A hovering fingertip may also
   project inside; no contact is inferred and no drum event or sound is produced.

The four points define a projective mapping to a unit square. Corner 1 is (0,0),
corner 2 is (1,0), corner 3 is (1,1), corner 4 is (0,1). These are local projected
positions, not centimetres, height, impact force or a measured 3D table plane.
The numerical tolerances in geometry validation are not strike sensitivity.

## Invalidation and limits

- The area is held only for the current capture run; no footage, trajectory or
  calibration file is saved. Stop/restart, device/mode changes, interruption or
  stale frames clear it. Re-mark the area after restarting.
- Mirroring/window resize retain the underlying unmirrored image points and must
  preserve alignment. These paths still need a real Mac check.
- Camera movement during live capture is **not automatically detected**. Press
  **Reset** and mark the region again after moving the camera, phone, crop or
  framing/effects. A fixed mount is an assumption, not a measured guarantee.
- The area-only branch has no rest/lift or temporal state machine. Those are now
  experimental on `feat/strike-recognition-experiment`; MIDI is still future.
  TapDrum generates no sounds and includes no sampler/custom sound plugin.

## Next owner feedback

Send text describing alignment after the fix, both-hand behavior, whether all
four clicks land where expected, invalid-corner recovery, mirror/resize behavior,
area clearing on Stop/stall, and current FPS/CPU/footprint/PTS-age values. Keep the
same mode for comparison. A short explicitly shared clip is optional; the app
still has no recording feature. Do not declare improved accuracy or reduced
latency without measurements.
