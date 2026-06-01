//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz.
//


import TrailingClosureIllustrations

import PreviewUtilities
import SwiftUI
import Testing


struct BaseRenders {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try .init(
            filePath: #filePath,
            droppingComponents: 2, // filename, renders
            appendingComponents: ["illustrations"]
        )
    }

    @Test func simpleTraits() throws {
        try storage.renderAndStore("examples", "simple-traits") {
            BaseIllustrations.nameIllustration
        }
    }
}
