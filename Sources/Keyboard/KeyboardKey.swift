// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import UIKit
import Tonic

public enum KeyLabelMode {
    case none

    case lettersWhite
    case lettersBlack
    case lettersAll

    case lettersWhiteWithOctave
    case lettersBlackWithOctave
    case lettersAllWithOctave

    case onlyC
    case onlyMiddleC
    case onlyDo
    case onlyMiddleCDo
    case solfege
    
}
/// A default visual representation for a key.
public struct KeyboardKey: View {
    @State private var isPressed = false
    /// Initialize the keyboard key
    /// - Parameters:
    ///   - pitch: Pitch assigned to the key
    ///   - isActivated: Whether to represent this key in the "down" state
    ///   - text: Label on the key
    ///   - color: Color of the activated key
    ///   - isActivatedExternally: Usually used for representing incoming MIDI
    ///   - borderWidth: Width of border around each individual key
    ///   - borderColor: Color of borderWidth
    ///   - labelMode: How and what keys should be labeled
    ///   - hapticsOn: Whether haptics should be on or off
    ///   - hapticsStyle: Strength of haptics
    ///   - allowSliding: whether or not you can slide your fingers across keys to play them
    ///   - tapReleaseTime: How long after release from key is note off
    public init(pitch: Pitch,
                isActivated: Bool,
                text: String = "unset",
                whiteKeyColor: Color = .white,
                blackKeyColor: Color = .black,
                whitePressedColor: Color = .red,
                blackPressedColor: Color = .red,
                flatTop: Bool = false,
                alignment: Alignment = .bottom,
                isActivatedExternally: Bool = false,
                borderWidth: CGFloat = 0,
                borderColor: Color = Color.black,
                labelMode: KeyLabelMode = .none,
                hapticsOn: Bool = true,
                hapticsStyle: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
                allowSliding: Bool = true,
                tapReleaseTime: TimeInterval = 0.1)
    {
        self.pitch = pitch
        self.isActivated = isActivated
        if text == "unset" {
            self.text = KeyboardKey.label(for: pitch, mode: labelMode)
        } else {
            self.text = text
        }
            
    
        self.whiteKeyColor = whiteKeyColor
        self.blackKeyColor = blackKeyColor
        self.whitePressedColor = whitePressedColor
        self.blackPressedColor = blackPressedColor
        self.flatTop = flatTop
        self.alignment = alignment
        self.isActivatedExternally = isActivatedExternally
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.labelMode = labelMode
        self.hapticsOn = hapticsOn
        self.hapticsStyle = hapticsStyle
        self.allowSliding = allowSliding
        self.tapReleaseTime = tapReleaseTime
    }

    var pitch: Pitch
    var isActivated: Bool
    var whiteKeyColor: Color
    var blackKeyColor: Color
    var whitePressedColor: Color
    var blackPressedColor: Color
    var flatTop: Bool
    var alignment: Alignment
    var text: String
    var isActivatedExternally: Bool
    var borderWidth: CGFloat
    var borderColor: Color
    var labelMode: KeyLabelMode
    var hapticsOn: Bool
    var hapticsStyle: UIImpactFeedbackGenerator.FeedbackStyle
    var allowSliding: Bool
    var tapReleaseTime: TimeInterval
    
    var keyColor: Color {
        if isActivatedExternally || isActivated {
            return isWhite ? whitePressedColor : blackPressedColor
        }
        return isWhite ? whiteKeyColor : blackKeyColor
    }

    var isWhite: Bool {
        pitch.note(in: .C).accidental == .natural
    }

    var textColor: Color {
        return isWhite ? blackKeyColor : whiteKeyColor
    }

    func minDimension(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }

    func isTall(size: CGSize) -> Bool {
        size.height > size.width
    }

    // How much of the key height to take up with label
    func relativeFontSize(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.333
    }

    let relativeTextPadding = 0.05

    func relativeCornerRadius(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.125
    }

    func topPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .bottom ? relativeCornerRadius(in: size) : 0
    }

    func leadingPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .trailing ? relativeCornerRadius(in: size) : 0
    }

    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .bottom ? -relativeCornerRadius(in: size) :
            isWhite ? 0.5 : 0
    }

    func negativeLeadingPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .trailing ? -relativeCornerRadius(in: size) :
            isWhite ? 0.5 : 0
    }

    static func label(for pitch: Pitch, mode: KeyLabelMode) -> String {
        let note = pitch.note(in: .C)
        let letter = note.noteClass.description /// e.g. "C", "D#"
        let octave = "\(note.octave)"

        switch mode {
            case .none:
                return ""

            case .lettersWhite where note.accidental == .natural:
                return letter
            case .lettersBlack where note.accidental != .natural:
                return letter
            case .lettersAll:
                return letter

            case .lettersWhiteWithOctave where note.accidental == .natural:
                return letter + octave
            case .lettersBlackWithOctave where note.accidental != .natural:
                return letter + octave
            case .lettersAllWithOctave:
                return letter + octave

            case .onlyC:
                return letter == "C" ? "C" : ""
            case .onlyMiddleC:
                return (letter == "C" && note.octave == 4) ? "C" : ""
            case .onlyDo:
                return letter == "C" ? "Do" : ""
            case .onlyMiddleCDo:
                return (letter == "C" && note.octave == 4) ? "Do" : ""
            case .solfege:
                let solfegeMap = ["C": "Do", "D": "Re", "E": "Mi", "F": "Fa", "G": "Sol", "A": "La", "B": "Ti"]
                return solfegeMap[letter] ?? ""
            
            default:
                return ""
            
        }
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: alignment) {
                RoundedRectangle(cornerSize: CGSize(width: relativeCornerRadius(in: proxy.size), height: relativeCornerRadius(in: proxy.size)))
                    .foregroundColor(keyColor)
                    .padding(.top, topPadding(proxy.size))
                    .padding(.leading, leadingPadding(proxy.size))
                    .cornerRadius(relativeCornerRadius(in: proxy.size))
                    .padding(.top, negativeTopPadding(proxy.size))
                    .padding(.leading, negativeLeadingPadding(proxy.size))
                    .padding(.trailing, 0.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: relativeCornerRadius(in: proxy.size))
                            .inset(by: borderWidth / 2)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                if !text.isEmpty {
                    Text(text)
                        .font(.system(size: relativeFontSize(in: proxy.size)))
                        .foregroundColor(textColor)
                        .padding(relativeFontSize(in: proxy.size) / 3.0)
                }
            }
                .contentShape(Rectangle())
                .if(
                    allowSliding,
                    transform: { view in
                    view.gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let frame = proxy.frame(in: .global)
                                if frame.contains(value.location) {
                                    if !isPressed {
                                        isPressed = true
                                        if hapticsOn {
                                            let generator = UIImpactFeedbackGenerator(style: hapticsStyle)
                                            generator.impactOccurred()
                                        }
                                        //this is note on
                                    }
                                } else {
                                    if isPressed {
                                        isPressed = false
                                        //this is note off
                                    }
                                }
                            }
                        
                            .onEnded { _ in 
                                if isPressed {
                                    isPressed = false
                                    //this is note off
                                }         
                            }
                    )
                },
                
                elseTransform: { view in
                    view.onTapGesture{
                        isPressed = true
                        if hapticsOn {
                            let generator = UIImpactFeedbackGenerator(style: hapticsStyle)
                            generator.impactOccurred()
                        }
                        //note on
                        DispatchQueue.main.asyncAfter(deadline: .now() + tapReleaseTime) {
                            isPressed = false
                            //note off
                        }
                    }                  
                }
                )
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content,
        elseTransform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
}
