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
            }
        }
    }


    @Test func existingModifiersWithBorders() throws {
        try storage.renderAndStore("existing-modifiers-with-borders", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    let mountainsButton = Button(action: {}) {
                        Label { Text("Mountains") }
                        icon: { Image(systemName: "mountain.2").border(.mint.secondary, width: 4) }
                    }

                    mountainsButton
                    .labelStyle(.iconOnly)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.glass)
                    .border(.pink)

                    mountainsButton
                    .labelStyle(.iconOnly)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .border(.pink)
                }
                .font(.title)
            }
        }
    }


    struct FramedButtonStyle: ButtonStyle {
        let size: CGSize
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .labelStyle(.iconOnly)
            .frame(width: size.width, height: size.height)
        }
    }

    @Test func framedButtonStyle() throws {
        try storage.renderAndStore("framed-button-style", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    let size = CGSize(width: 60, height: 60)
                    Button("Leaf", systemImage: "leaf", action: {})
                    .buttonStyle(FramedButtonStyle(size: size))
                    .buttonBorderShape(.circle)

                    Button("Leaf", systemImage: "leaf", action: {})
                    .buttonStyle(FramedButtonStyle(size: size))
                    .glassEffect(.regular.interactive(), in: .circle)
                }
                .font(.title)
            }
        }
    }


    struct GlassFramedButtonStyle: ButtonStyle {
        let size: CGSize
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .labelStyle(.iconOnly)
            .frame(width: size.width, height: size.height)
            .glassEffect(.regular.interactive(), in: .circle)
        }
    }


    @Test func glassFramedButtonStyle() throws {
        try storage.renderAndStore("glass-framed-button-style", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    Button("Fish", systemImage: "fish", action: {})
                    Button("Hourglass", systemImage: "hourglass.badge.eye", action: {})
                    Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
                    Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
                }
                .buttonStyle(GlassFramedButtonStyle(size: .init(width: 60, height: 60)))
                .font(.title)
            }
        }
    }


    @Test func glassFramedButtonStyleAligned() throws {
        try storage.renderAndStore("glass-framed-button-style-aligned", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack(alignment: .firstTextBaseline) {
                    let alignmentGuideRect = Rectangle().fill(.pink.secondary).frame(width: 260, height: 2)
                    Button("Hourglass", systemImage: "hourglass.badge.eye", action: {})
                    Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
                    Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})

                    Button("Fish", systemImage: "fish", action: {})
                    .overlay(alignment: .topTrailing) { alignmentGuideRect }
                    .overlay(alignment: .trailingFirstTextBaseline) { alignmentGuideRect }
                    .overlay(alignment: .bottomTrailing) { alignmentGuideRect }
                }
                .buttonStyle(GlassFramedButtonStyle(size: .init(width: 60, height: 60)))
                .font(.title)
            }
        }
    }

}
