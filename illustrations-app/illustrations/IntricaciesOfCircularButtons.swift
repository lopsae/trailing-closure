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
            appendingComponents: ["docs", "assets", "img", "intricacies-of-circular-buttons"]
        ) {
            // onImageStored
            cgImage, filename in
            Attachment.record(cgImage, named: filename, as: .png)
        }
    }


    struct HeaderView: View {
        @Namespace var namespace
        var body: some View {
            GlassEffectContainer {
                HStack(alignment: .firstTextBaseline) {
                    Button("Cloud", systemImage: "smoke", action: {})
                    Button("Rain", systemImage: "drop", action: {})
                    Button("Wind", systemImage: "wind", action: {})

                    Button("Sun", systemImage: "sun.max", action: {})
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive())
                    .glassEffectUnion(id: "union", namespace: namespace)

                    Button("Moon", systemImage: "moon", action: {})
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive())
                    .glassEffectUnion(id: "union", namespace: namespace)
                }
                .labelStyle(BaselinedIconLabelStyle(length: 70))
                .buttonStyle(GlassBorderedButtonStyle())
                .font(.largeTitle)
            }
        }
    }


    @Test func header() throws {
        try storage.renderAndStore("header", strategy: .windowHierarchy) {
            // FIXME: Store into a sizing property.
            DocumentationIllustration(size: [600 , 315], drawsBorder: false, background: .fadedMoltenHorizon) {
                HeaderView()
            }
        }
    }


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
                    Button("Envelope",  systemImage: "envelope.badge.shield.half.filled", action: {})
                    Button("Hourglass", systemImage: "hourglass.badge.plus", action: {})
                    Button("Fish",      systemImage: "fish", action: {})
                    Button("Car",       systemImage: "car.badge.gearshape", action: {})
                    Button("Lock",      systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
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
                    Button("Envelope",  systemImage: "envelope.badge.shield.half.filled", action: {})
                    Button("Hourglass", systemImage: "hourglass.badge.plus", action: {})

                    Button("Fish", systemImage: "fish", action: {})
                    .drawAlignmentGuide(.top, length: 360)
                    .drawAlignmentGuide(.firstTextBaseline, length: 360)
                    .drawAlignmentGuide(.bottom, length: 360)

                    Button("Car",  systemImage: "car.badge.gearshape", action: {})
                    Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
                }
                .buttonStyle(GlassFramedButtonStyle(length: 60))
                .font(.title)
            } // Illustration
        }
    }


    @Test func symbolsInlineAlignment() throws {
        try storage.renderAndStore("symbols-inline-alignment", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular) {
                VStack {
                    let envelope  = Image(systemName: "envelope.badge.shield.half.filled")
                    let hourglass = Image(systemName: "hourglass.badge.plus")
                    let shell     = Image(systemName: "fossil.shell")
                    let car       = Image(systemName: "car.badge.gearshape")
                    let lock      = Image(systemName: "lock.open.trianglebadge.exclamationmark.fill")
                    Text("Regular \(envelope) \(hourglass) \(shell) \(car) \(lock) symbols")
                    .drawAlignmentGuide(.firstTextBaseline)

                    Text("Large \(envelope) \(hourglass) \(shell) \(car) \(lock) symbols")
                    .imageScale(.large)
                    .drawAlignmentGuide(.firstTextBaseline)

                    HStack(alignment: .firstTextBaseline) {
                        Button("Car", systemImage: "car.badge.gearshape", action: {})
                        Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
                            .drawAlignmentGuide(.firstTextBaseline, length: 300)
                        Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
                    }
                }
                .font(.title3)
            } // Illustration
        }
    }


    @Test func framedSymbolsWithBaselines() throws {
        try storage.renderAndStore("framed-symbols-with-baselines", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular) {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "envelope.badge.shield.half.filled")
                        .border(.green.secondary, width: 2)
                    Image(systemName: "hourglass.badge.plus")
                        .border(.green.secondary, width: 2)
                    Image(systemName: "fossil.shell")
                        .drawAlignmentGuide(.firstTextBaseline, length: 300)
                        .border(.green.secondary, width: 2)
                    Image(systemName: "car.badge.gearshape")
                        .border(.green.secondary, width: 2)
                    Image(systemName: "lock.open.trianglebadge.exclamationmark.fill")
                        .border(.green.secondary, width: 2)
                }
                .font(.title)
            } // Illustration
        }
    }


    @Test func defaultButtonSizing() throws {
        try storage.renderAndStore("default-button-sizing", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack(alignment: .firstTextBaseline) {
                    Button("Horizontal", systemImage: "guidepoint.horizontal", action: {})
                    Button("Vertical",   systemImage: "guidepoint.vertical", action: {})
                    Button("Rainbow",    systemImage: "rainbow", action: {})
                    Button("Bolt",       systemImage: "bolt", action: {})
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.glass)
                .font(.title)
            } // Illustration
        }
    }


    @Test func aligningOntoCircle() throws {
        try storage.renderAndStore("aligning-onto-circle", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular) {
                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    Image(systemName: "circle")
                        .foregroundStyle(.blue)
                    .overlay(alignment: .centerFirstTextBaseline) {
                        Image(systemName: "hourglass.badge.plus")
                        .border(.green.secondary, width: 2)
                    }
                    .border(.blue.secondary, width: 2)

                    Image(systemName: "circle")
                    .border(.blue.secondary, width: 2) // Blue size frame is the same for all symbols!
                    .drawAlignmentGuide(.firstTextBaseline, length: 200)

                    Image(systemName: "circle")
                    .foregroundStyle(.blue)
                    .overlay(alignment: .centerFirstTextBaseline) {
                        Image(systemName: "car.badge.gearshape")
                        .border(.green.secondary, width: 2)
                    }
                    .border(.blue.secondary, width: 2)
                }
                .font(.largeTitle)
            } // Illustration
        }
    }


    struct GlassBaselinedButtonStyle: ButtonStyle {
        let length: CGFloat
        func makeBody(configuration: Configuration) -> some View {
            Image(systemName: "circle")
            .hidden() // The circle symbol is never visible, but its layout size remains.
            .overlay(alignment: .centerFirstTextBaseline) {
                configuration.label
                .labelStyle(.iconOnly)
            }
            .frame(width: length, height: length)
            .glassEffect(.regular.interactive(), in: .circle)
        }
    }


    @Test func glassBaselinedButtonStyleAligned() throws {
        try storage.renderAndStore("glass-baselined-button-style-aligned", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack(alignment: .firstTextBaseline) {
                    Button("Envelope",  systemImage: "envelope.badge.shield.half.filled", action: {})
                    Button("Hourglass", systemImage: "hourglass.badge.plus", action: {})

                    Button("Seashell", systemImage: "fossil.shell", action: {})
                    .drawAlignmentGuide(.top, length: 360)
                    .drawAlignmentGuide(.firstTextBaseline, length: 360)
                    .drawAlignmentGuide(.bottom, length: 360)

                    Button("Car",  systemImage: "car.badge.gearshape", action: {})
                    Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
                }
                .buttonStyle(GlassBaselinedButtonStyle(length: 60))
                .font(.title)
            } // Illustration
        }
    }


    struct BaselinedIconLabelStyle: LabelStyle {
        let length: CGFloat
        func makeBody(configuration: Configuration) -> some View {
            Image(systemName: "circle")
            .hidden()
            .overlay(alignment: .centerFirstTextBaseline) {
                configuration.icon
            }
            .frame(width: length, height: length)
        }
    }


    @Test func baselinedLabelStyle() throws {
        try storage.renderAndStore("baselined-label-style", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack(alignment: .firstTextBaseline) {
                    Button("Flame",  systemImage: "flame", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .border(.pink.secondary, width: 2)

                    Button("Flame",  systemImage: "flame", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .buttonStyle(.plain) // To prevent button tint color.
                    .glassEffect(.regular.interactive())
                }
                .font(.title)
            } // Illustration
        }
    }

    struct GlassBorderedButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .glassEffect(.regular.interactive(), in: ButtonBorderShape.buttonBorder)
        }
    }

    @Test func glassBorderedButtonStyle() throws {
        try storage.renderAndStore("glass-bordered-button-style", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack(alignment: .firstTextBaseline) {
                    Button("Bird",  systemImage: "bird", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .buttonStyle(GlassBorderedButtonStyle())

                    Button("Ladybug",  systemImage: "ladybug", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .buttonStyle(GlassBorderedButtonStyle())
                    .buttonBorderShape(.roundedRectangle)

                    Button("Ant",  systemImage: "ant", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .buttonStyle(GlassBorderedButtonStyle())
                    .buttonBorderShape(.roundedRectangle(radius: .zero))
                }
                .font(.title)
            } // Illustration
        }
    }


    @Test func glassEffectUnionButtons() throws {
        try storage.renderAndStore("glass-effect-union-buttons", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                GlassEffectUnionButtonsView()
            } // Illustration
        }
    }

    struct GlassEffectUnionButtonsView: View {
        @Namespace var namespace
        var body: some View {
            GlassEffectContainer {
                HStack(alignment: .firstTextBaseline) {
                    Button("Tree", systemImage: "tree", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive())
                    .glassEffectUnion(id: "union", namespace: namespace)

                    Button("Carrot", systemImage: "carrot", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive())
                    .glassEffectUnion(id: "union", namespace: namespace)

                    Button("Rain", systemImage: "cloud.rain", action: {})
                    .labelStyle(BaselinedIconLabelStyle(length: 60))
                    .buttonStyle(GlassBorderedButtonStyle())
                }
                .font(.title)
            }
        }
    }


    @Test func circleCircularButton() throws {
        try storage.renderAndStore("circle-circular-button", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                Button("Circle",  systemImage: "circle", action: {})
                .labelStyle(BaselinedIconLabelStyle(length: 80))
                .buttonStyle(GlassBorderedButtonStyle())
                .font(.largeTitle)
            } // Illustration
        }
    }

}


private extension View {
    func drawAlignmentGuide(_ verticalAlignment: VerticalAlignment, length: CGFloat? = nil) -> some View {
        let alignment = Alignment(horizontal: .center, vertical: verticalAlignment)
        return self.overlay(alignment: alignment) {
            Rectangle()
            .fill(.red.secondary)
            .frame(width: length, height: 2)
        }
    }
}
