# DVDScreenSaver

DVDScreenSaver is a macOS Screen Saver bundle that recreates the classic bouncing DVD logo animation.

This repository already contains a complete Xcode screen saver target named `bouncesaver`, so maintainers can build and install directly without creating a new project.

## What It Does

- Renders a black background and a DVD logo image in each frame.
- Moves the logo diagonally and bounces off screen edges.
- Changes logo color when any wall collision occurs.
- Runs animation at 60 FPS.
- Scales movement speed based on view width so traversal time feels consistent across display sizes.

## Project Layout

- `bouncesaver/bouncesaverView.h`: Screen saver view interface and animation state properties.
- `bouncesaver/bouncesaverView.m`: Main animation logic, drawing code, collision handling, and color tinting.
- `bouncesaver/Info.plist`: Bundle metadata and principal class (`bouncesaverView`).
- `bouncesaver.xcodeproj/project.pbxproj`: Xcode target configuration, build settings, and resource inclusion.
- `dvdvideologo.png`: Logo asset loaded at runtime from the bundle.
- `LICENSE.txt`: Licensing terms.

## Build Requirements

- macOS
- Xcode with ScreenSaver framework available

The Xcode project currently targets macOS deployment target `10.12`.

## Build And Install

1. Open `bouncesaver.xcodeproj` in Xcode.
2. Select the `bouncesaver` target and build (Debug or Release).
3. Locate the built `bouncesaver.saver` product in Xcode's Products group.
4. In Finder, open the generated `.saver` bundle to install it.
5. Enable it in System Settings (or System Preferences on older macOS versions) under Screen Saver.

## Runtime Behavior Notes

- The logo image is loaded with:
	- resource name: `dvdvideologo`
	- extension: `png`
- Collision detection clamps position to bounds before reversing direction.
- On each collision, the image is recolored by drawing a random color with `NSCompositingOperationSourceAtop`.

## Maintainer Notes

- If the screen saver appears blank, verify `dvdvideologo.png` is included in target resources.
- `project.pbxproj` currently includes `.gitignore` in the Resources build phase. This is unnecessary for runtime and can be removed to keep the bundle clean.
- Position and speed properties in `bouncesaverView.h` are declared as `int`, while frame math uses `CGFloat` values. This can cause truncation and less smooth movement. Converting those properties to `CGFloat` is a good future cleanup.

## Troubleshooting

- After installation, if the saver does not appear immediately, reopen Screen Saver settings and reselect `bouncesaver`.
- If needed, remove and reinstall the `.saver` bundle from `~/Library/Screen Savers`.
