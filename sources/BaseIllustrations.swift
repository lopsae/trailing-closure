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

}


// MARK: - Previews


#Preview("name", traits: .docsIllustration) {
    BaseIllustrations.nameIllustration
}
