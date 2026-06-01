//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz on 2026-05-31.
//


import PreviewUtilities
import SwiftUI


struct BaseIllustrations {

    @ViewBuilder
    static var nameIllustration: some View {
        DocumentationIllustration(height: 160) {
            Text("trailing { closure }")
                .font(.title)
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("name", traits: .docsIllustration) {
    BaseIllustrations.nameIllustration
}
