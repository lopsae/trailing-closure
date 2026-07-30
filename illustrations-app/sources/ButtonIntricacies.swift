//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import SwiftUI


// Drawing Board for The Intricacies of Circular Buttons.


#Preview("DrawingBoard", traits: .docsIllustration) {
    DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
        HStack {
            let mountainsButton = Button("Mountains", systemImage: "mountain.2", action: {})

            mountainsButton
            .buttonStyle(.glass)

            mountainsButton
            .labelStyle(.iconOnly)
            .buttonStyle(.glass)

            mountainsButton
            .labelStyle(.iconOnly)
            .buttonBorderShape(.circle)
            .buttonStyle(.glass)
        }
        .padding(.horizontal)
    }
}


#Preview("Symbols", traits: .docsIllustration) {
    DocumentationIllustration(sizing: .regular) {
        HStack {
            Image(systemName: "hourglass.badge.eye")
            .debugAlignmentGuide(.centerFirstTextBaseline)
            .border(.mint)

            Image(systemName: "envelope.badge.shield.half.filled")
            .debugAlignmentGuide(.centerFirstTextBaseline)
            .border(.mint)

            Image(systemName: "lock.open.trianglebadge.exclamationmark.fill")
            .debugAlignmentGuide(.centerFirstTextBaseline)
            .border(.mint)
        }
        .font(.largeTitle)
        .padding(.horizontal)
    }
}


#Preview("Experiments", traits: .background(PrettyMesh.wallOfIceAndFire)) {
    Button(
        "Glass Regular",
        systemImage: "envelope.badge.shield.half.filled",
        action: {}
    )
    .buttonStyle(.glass)

    Button(
        "Glass Prominent",
        systemImage: "envelope.badge.shield.half.filled",
        action: {}
    )
    .buttonStyle(.glassProminent)

    Button(
        "Capsule",
        systemImage: "envelope.badge.shield.half.filled",
        action: {}
    )
    .buttonBorderShape(.capsule)
    .buttonStyle(.glassProminent)

    Button(
        "Glass Prominent",
        systemImage: "envelope.badge.shield.half.filled",
        action: {}
    )
    .labelStyle(.iconOnly)
    .buttonBorderShape(.capsule)
    .buttonStyle(.glassProminent)

    Button(
        "Glass Prominent",
        systemImage: "envelope.badge.shield.half.filled",
        action: {}
    )
    .labelStyle(.iconOnly)
    .buttonBorderShape(.circle)
    .buttonStyle(.glassProminent)

    Button(
        "Glass Prominent",
        systemImage: "envelope.badge.shield.half.filled",
        action: {}
    )
    .labelStyle(.iconOnly)
    .buttonStyle(.plain)
    .padding(8)
    .debugOverlay(.hairline)
    .glassEffect(.regular.interactive())

    Button(
        "Glass Prominent",
        systemImage: "envelope.badge.shield.half.filled",
        action: {}
    )
    .labelStyle(.iconOnly)
    .buttonStyle(.plain)
    .frame(squareOf: 15, alignment: .centerLastTextBaseline)
    .frame(squareOf: 44, alignment: .center)
    .debugOverlay(.hairline)
    .glassEffect(.regular.interactive())

    HStack(alignment: .firstTextBaseline) {
        Label("Label", systemImage: "circle")

        Button(
            "Glass Prominent",
            systemImage: "envelope.badge.shield.half.filled",
            action: {}
        )
        .font(.title)
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .frame(squareOf: 15, alignment: .centerLastTextBaseline)
        .frame(squareOf: 44, alignment: .center)
        .debugOverlay(.hairline)
        .glassEffect(.regular.interactive())

        Button(
            "Glass Prominent",
            systemImage: "envelope.badge.shield.half.filled",
            action: {}
        )
        .font(.title)
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
//                .frame(squareOf: 15, alignment: .centerLastTextBaseline)
        .frame(squareOf: 44, alignment: .center)
        .debugOverlay(.hairline)
        .glassEffect(.regular.interactive())
    }
}


struct GlassCirclePaddingStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.iconOnly)
            .font(.title)
            .border(.red)
            .padding()
            .border(.green)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .glassEffect(.regular.interactive(), in: .circle)
    }
}

#Preview("GlassCirclePaddingStyle", traits: .background(PrettyMesh.wallOfIceAndFire.opacity(0.5))) {
    Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
    .buttonStyle(GlassCirclePaddingStyle())

    Button("Star", systemImage: "star", action: {})
    .buttonStyle(GlassCirclePaddingStyle())

    HStack(alignment: .firstTextBaseline) {
        Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
        .buttonStyle(GlassCirclePaddingStyle())

        Button("Star", systemImage: "star", action: {})
        .buttonStyle(GlassCirclePaddingStyle())

        Label("Label", systemImage: "circle")
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(200), .anchor(.trailing))
    }

}


struct GlassCircleFramedStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.iconOnly)
            .font(.title)
            .frame(squareOf: 36)
            .border(.red)
            .padding()
            .border(.green)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .glassEffect(.regular.interactive(), in: .circle)
    }
}


#Preview("GlassCircleFramedStyle", traits: .background(PrettyMesh.wallOfIceAndFire.opacity(0.5))) {
    HStack(alignment: .firstTextBaseline) {
        Button("Star", systemImage: "star", action: {})
            .buttonStyle(GlassCircleFramedStyle())

        Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
            .buttonStyle(GlassCircleFramedStyle())

        Label("FirstBaseline", systemImage: "app.grid")
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(150), .anchor(.trailing))
    }
}


struct GlassCircleBaselinedStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "circle")
        .font(.title)
        .opacity(0.0)
        .overlay(alignment: .centerFirstTextBaseline) {
            configuration.label
            .labelStyle(.iconOnly)
            .font(.title)
        }
        .border(.red)
        .frame(squareOf: 60)
        .border(.green)
        .opacity(configuration.isPressed ? 0.5 : 1)
        .glassEffect(.regular.interactive(), in: .circle)
    }
}


#Preview("GlassCircleBaselinedStyle", traits: .background(PrettyMesh.wallOfIceAndFire.opacity(0.5))) {
    HStack(alignment: .firstTextBaseline) {
        Button("Star", systemImage: "star", action: {})
            .buttonStyle(GlassCircleBaselinedStyle())

        Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
            .buttonStyle(GlassCircleBaselinedStyle())

        Label("FirstBaseline", systemImage: "circle")
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(150), .anchor(.trailing))
    }
}


struct BaselineFramed: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "circle")
        .font(.title)
        .opacity(0.5)
        .overlay(alignment: .centerFirstTextBaseline) {
            configuration.icon
            .font(.title)
        }
        .border(.red)
        .frame(squareOf: 60)
        .border(.green)
    }
}

#Preview("BaselineFramed", traits: .background(PrettyMesh.wallOfIceAndFire.opacity(0.5))) {
    VStack {
        Label("Title 1", systemImage: "star")
            .glassEffect()
        Label("Title 2", systemImage: "square")
        Label("Title 3", systemImage: "circle")

    }
    .labelStyle(BaselineFramed())
}


struct GlassCircleLabelBaselineStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .labelStyle(BaselineFramed())
        .opacity(configuration.isPressed ? 0.5 : 1)
        .glassEffect(.regular.interactive(), in: .circle)
    }
}


#Preview("GlassCircleLabelBaselineStyle", traits: .background(PrettyMesh.wallOfIceAndFire.opacity(0.5))) {
    @Previewable @Namespace var namespace
    HStack(alignment: .firstTextBaseline) {
        Button("Star", systemImage: "star", action: {})
            .buttonStyle(GlassCircleLabelBaselineStyle())

        Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
            .buttonStyle(GlassCircleLabelBaselineStyle())

        Label("FirstBaseline", systemImage: "circle")
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(150), .anchor(.trailing))
    }

    HStack(alignment: .firstTextBaseline) {
        GlassEffectContainer {
            HStack(alignment: .firstTextBaseline) {
                Button("Star", systemImage: "star", action: {})
                    .labelStyle(BaselineFramed())
                    .glassEffect(.regular.interactive())
                    .glassEffectUnion(id: "union", namespace: namespace)

                Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
                    .labelStyle(BaselineFramed())
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive())
                    .glassEffectUnion(id: "union", namespace: namespace)
            }
        }

        Label("FirstBaseline", systemImage: "circle")
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(150), .anchor(.trailing))
    }
}


struct GlassShapeLabelBaselineStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let buttonShape = ButtonBorderShape.buttonBorder
        configuration.label
        .labelStyle(BaselineFramed())
        .opacity(configuration.isPressed ? 0.5 : 1)
        .glassEffect(.regular.interactive(), in: buttonShape)
    }
}


#Preview("GlassShapeLabelBaselineStyle", traits: .background(PrettyMesh.wallOfIceAndFire.opacity(0.5))) {
    @Previewable @Namespace var namespace
    HStack(alignment: .firstTextBaseline) {
        Button("Star", systemImage: "star", action: {})
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(GlassShapeLabelBaselineStyle())


        Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
            .buttonStyle(GlassShapeLabelBaselineStyle())
            .buttonBorderShape(.roundedRectangle)

        Label("FirstBaseline", systemImage: "circle")
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(150), .anchor(.trailing))
    }
}


// TODO: Move to preview-utilities after it matures more.

struct BackgroundPreviewModifier<Background: View>: PreviewModifier {

    let background: Background

    func body(content: Content, context _: ()) -> some View {
        ZStack {
            background.ignoresSafeArea()
            VStack { content }
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    static func background(_ content: some View) -> PreviewTrait {
        let backgroundModifier = BackgroundPreviewModifier(background: content)
        return .modifier(backgroundModifier)
    }

}
