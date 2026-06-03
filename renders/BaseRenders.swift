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

    @Test func trailingClosure() throws {
        try storage.renderAndStore("base", "trailing-closure") {
            BaseIllustrations.nameIllustration
        }
    }


    @Test func eventCard() throws {
        let resource = try IllustrationRenderer.render(
            nameComponents: ["base", "event-card"],
            scale: 5,
            colorSchemes: [.light]
        ) {
            BaseIllustrations.eventCard
        }
        try storage.store(resource: resource)
    }
}
