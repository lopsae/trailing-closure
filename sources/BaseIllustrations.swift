//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz on 2026-05-31.
//


import PreviewUtilities
import SwiftUI


public struct BaseIllustrations {

    // MARK: nameIllustration

    public static var nameIllustration: DocumentationIllustration {
        DocumentationIllustration(height: 160) {
            let showAlignmentGuides = false

            ZStack(alignment: .center) {
                Text("closure")
                .font(.title.monospaced())
                .overlay(alignment: .centerFirstTextBaseline) {
                    if showAlignmentGuides {
                        Rectangle().fill(.red.secondary)
                            .frame(width: 200, height: 2)
                    }
                }
                // TODO: add and use use .hide(when:) trait
//                .debugOverlay(.hairline)

                let openBrace = Text("{")
                .font(.system(.title, design: .monospaced))

                Text("trailing \(openBrace)")
                .font(.system(.title, design: .serif).italic())
                .overlay(alignment: .centerFirstTextBaseline) {
                    if showAlignmentGuides {
                        Rectangle().fill(.red.secondary)
                            .frame(width: 200, height: 2)
                    }
                }
                .alignmentGuide(.center, moveTo: .trailing, offsetBy: 58 + 10)
                .alignmentGuide(.center, moveTo: .bottom, offsetBy: -2)

                Text("}")
                .font(.title.monospaced())
                .alignmentGuide(.center, moveTo: .trailing, offsetBy: -75 - 10)
                .alignmentGuide(.center, moveTo: .top, offsetBy: -3)
            }
        }
    }


    
    // MARK: eventCard

    // International card size is (85 mm x 55 mm).
    // Standard US card size is 3.5" x 2" (88.9 mm x 50.8 mm)
    // iPhone 17 Pro screen width is 6.5 cm, approximately 6.185 points per mm.
    // Standard US card with a 400pt width is (400 pt x 228.57 pt)
    public static var eventCard: DocumentationIllustration {
        DocumentationIllustration(size: [400, 229], drawsBorder: false) {
            ZStack {
                VStack(alignment:.leading) {
                    VStack.maxWidth(alignment:.leading) {
                        Text("Maic Lopez Saenz")
                        Text("Swift Developer")
                            .font(.caption)
                        Text(verbatim: "maic@lopsae.com")
                            .font(.caption.monospaced())
                    }
                    .overlay(alignment: .trailing) {
                        Image(.stylizedM)
                            .resizable()
                            .scaledToFit()
                    }


                    Spacer()
                }

                VStack.maxWidth(alignment:.trailing, spacing: 8) {
                    Spacer()

                    VStack.maxWidth(alignment:.trailing, spacing: 4) {
                        Text("Check out")
                        Text(".debugOverlay()")
                            .monospaced()
                            .debugOverlay()
                    }
                    VStack.maxWidth(alignment:.trailing) {
                        Text("and other nifty utilities")
                        Text("in the PreviewUtilities package")
                        Text("github:lopsae/preview-utilities")
                            .monospaced()
                    }
                    .font(.caption)
                    // Alignment guide.
//                    .overlay(alignment: .bottomTrailing) {
//                        Rectangle().fill(.red.secondary)
//                            .frame(width: 2, height: 200)
//                    }
                }
            }
            .padding()
        }
    }


    // MARK: experiments

    public static var experiments: DocumentationIllustration {
        DocumentationIllustration(height: 600) {
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
    }

}


// MARK: - Previews


#Preview("name", traits: .docsIllustration) {
    BaseIllustrations.nameIllustration
}


#Preview("event-card", traits: .docsIllustration) {
    BaseIllustrations.eventCard
}


#Preview("Button Experiments", traits: .docsIllustration) {
    BaseIllustrations.experiments
}
