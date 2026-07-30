//
//  Trailing Closure Illustration App
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import SwiftUI


@MainActor
extension DocumentationIllustration.Background {

    public static let fadedMoltenHorizon: Self = .view {
        PrettyMesh.moltenHorizon
            .rotated()
            .applying(opacities: [
                .red:    0.8,
                .yellow: 0.3,
                .orange: 0.5
            ])
    }

}
