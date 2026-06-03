//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz on 2026-05-31.
//


import PreviewUtilities
import SwiftUI


public struct BaseIllustrations {

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


    // International card size is (85 mm x 55 mm).
    public static var eventCard: DocumentationIllustration {
        DocumentationIllustration(height: 200) {
            ZStack {
                VStack.maxWidth(alignment:.leading) {
                    Text("Maic Lopez Saenz")
//                    HStack(alignment: .firstTextBaseline, spacing: 4) {
//                        Image(systemName: "wrench.and.screwdriver.fill")
//                        Text("Swift Developer")
//                    }
//                    .font(.caption)
//
//                    HStack(alignment: .firstTextBaseline, spacing: 4) {
//                        Image(systemName: "envelope")
//                        Text(verbatim: "maic@lopsae.com")
//                    }
//                    .font(.caption.monospaced())

                    Text("Swift Developer")
                        .font(.caption)
                    Text(verbatim: "maic@lopsae.com")
                        .font(.caption.monospaced())

                    Spacer()
                }

                VStack.maxWidth(alignment:.trailing, spacing: 8) {
                    Spacer()

                    VStack.maxWidth(alignment:.trailing, spacing: 4) {
                        Text("Check out")
//                        HStack(spacing: .zero) {
//                            Text("view")
//                            Text(".debugOverlay()")
//                                .debugOverlay()
//                        }
//                        .monospaced()

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
                }
            }
            .padding()
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
