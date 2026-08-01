//
//  Trailing Closure Illustration App
//  Created by Maic Lopez Saenz.
//


@testable import IllustrationsApp

import PreviewUtilities
import SwiftUI
import Testing


@MainActor
struct IntricaciesOfCircularButtons {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try .init(
            filePath: #filePath,
            droppingComponents: 3, // filename, illustrations, illustration-app
            appendingComponents: ["illustrations", "intricacies-of-circular-buttons"]
        ) {
            // onImageStored
            cgImage, filename in
            Attachment.record(cgImage, named: filename, as: .png)
        }
    }


//    @Test func header() throws {
//        try storage.renderAndStore("header") {
//            // FIXME: Store into a sizing property.
//            DocumentationIllustration(size: [600 , 315], drawsBorder: false) {
//                RoundedRectangle(cornerRadius: 8)
//                .fill(.teal.gradient)
//                .frame(width: 360, height: 200)
//                // Illustration adornments.
//                .overlay(alignment: .trailing) {
//                    HStack(alignment: .top, spacing: 4) {
//                        Rectangle()
//                            .fill(.red.secondary)
//                            .frame(width: 2)
//                        Text("Debugging Caption")
//                            .font(.caption)
//                            .foregroundStyle(.tertiary)
//                            .frame(width: 100, alignment: .leading)
//                    }
//                    .padding(.leading, 8)
//                    .alignmentGuide(.trailing) { $0[.leading] }
//                }
//            }
//        }
//    }


    @Test func existingModifiers() throws {
        try storage.renderAndStore("existing-modifiers", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    let mountainsButton = Button("Mountains", systemImage: "mountain.2", action: {})

                    mountainsButton
                    .labelStyle(.iconOnly)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.glass)

                    mountainsButton
                    .labelStyle(.iconOnly)
                    .glassEffect(.regular.interactive(), in: .circle)
                }
                .font(.title)
            } // Illustration
        }
    }


    @Test func existingModifiersWithBorders() throws {
        try storage.renderAndStore("existing-modifiers-with-borders", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    let mountainsButton = Button(action: {}) {
                        Label { Text("Mountains") }
                        icon: {
                            Image(systemName: "mountain.2")
                            .border(.mint.secondary, width: 4) // Outline symbol frame.
                        }
                    }

                    mountainsButton
                    .labelStyle(.iconOnly)
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.glass)
                    .border(.pink) // Outline button frame.

                    mountainsButton
                    .labelStyle(.iconOnly)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.glass)
                    .border(.pink) // Outline button frame.

                    mountainsButton
                    .labelStyle(.iconOnly)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .border(.pink) // Outline button frame.
                }
                .font(.title)
            } // Illustration
        }
    }


    struct FramedButtonStyle: ButtonStyle {
        let length: CGFloat
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .labelStyle(.iconOnly)
            .frame(width: length, height: length)
        }
    }

    @Test func framedButtonStyle() throws {
        try storage.renderAndStore("framed-button-style", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    Button("Leaf", systemImage: "leaf", action: {})
                    .buttonStyle(FramedButtonStyle(length: 60))
                    .buttonBorderShape(.circle)  // Does not work with this style!
                    .border(.pink) // But the button frame is still a square.

                    Button("Leaf", systemImage: "leaf", action: {})
                    .buttonStyle(FramedButtonStyle(length: 60))
                    .glassEffect(.regular.interactive(), in: .circle)
                }
                .font(.title)
            } // Illustration
        }
    }


    struct GlassFramedButtonStyle: ButtonStyle {
        let length: CGFloat
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .labelStyle(.iconOnly)
            .frame(width: length, height: length)
            .glassEffect(.regular.interactive(), in: .circle)
        }
    }


    @Test func glassFramedButtonStyle() throws {
        try storage.renderAndStore("glass-framed-button-style", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    Button("Fish", systemImage: "fish", action: {})
                    Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
                    Button("Car", systemImage: "car.badge.gearshape", action: {})
                    Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
                }
                .buttonStyle(GlassFramedButtonStyle(length: 60))
                .font(.title)
            } // Illustration
        }
    }


    @Test func glassFramedButtonStyleAligned() throws {
        try storage.renderAndStore("glass-framed-button-style-aligned", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack(alignment: .firstTextBaseline) {
                    Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
                    Button("Car", systemImage: "car.badge.gearshape", action: {})
                    Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})

                    let alignmentGuideRect = Rectangle().fill(.pink.secondary).frame(width: 260, height: 2)
                    Button("Fish", systemImage: "fish", action: {})
                    // Alignment guide visualization.
                    .overlay(alignment: .topTrailing) { alignmentGuideRect }
                    .overlay(alignment: .trailingFirstTextBaseline) { alignmentGuideRect }
                    .overlay(alignment: .bottomTrailing) { alignmentGuideRect }
                }
                .buttonStyle(GlassFramedButtonStyle(length: 60))
                .font(.title)
            } // Illustration
        }
    }

}
