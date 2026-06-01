//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz on 2026-05-31.
//


import PreviewUtilities
import SwiftUI


public struct BaseIllustrations {

    public static var nameIllustration: DocumentationIllustration {
        DocumentationIllustration(height: 160) {
            Text("trailing { closure }")
                .font(.title)
        }
    }

}


// MARK: - Previews


#Preview("name", traits: .docsIllustration) {
    BaseIllustrations.nameIllustration
}
