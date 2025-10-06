# Keyboard

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAudioKit%2FKeyboard%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/AudioKit/Keyboard)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAudioKit%2FKeyboard%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/AudioKit/Keyboard)

![keyboard-demo](https://user-images.githubusercontent.com/13122/188524839-3864fe14-cc34-4bab-852d-6c8b565e0f05.png)

*Based on [AudioKit Keyboard](https://github.com/AudioKit/Keyboard)*

Keyboard aims to be an easy-to-use musical keyboard with:

- multi-touch interface
- accurate note name labels on the piano keys given the musical key
- stylized keys in any color
- any number of notes, not just limited to octaves
- compatible with Swift Playgrounds

## Differences from AudioKit Keyboard

- `whiteKeyColor` and `blackKeyColor` to customize key colors
- `borderWidth` and `borderColor` for customizable border thickness and color
- `whitePressedColor`, `blackPressedColor`, and `pressedColor` for customization of the color shown on a pressed key
- `keyLabelMode` for flexible labeling (letters, octave numbers, solfege, etc.)

## Goals

- Good user interface
- Good performance. We rely on SwiftUI's drag gestures
  
## Install

Install using Swift Package Manager.
In Swift Playgrounds,
1. Add Swift Package
2. Paste `https://github.com/Kyle333-glitch/Keyboard` into the link field
