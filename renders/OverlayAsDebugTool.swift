//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz.
//


import TrailingClosureIllustrations

import PreviewUtilities
import SwiftUI
import Testing


struct OverlayAsDebugTool {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try .init(
            filePath: #filePath,
            droppingComponents: 2, // filename, renders
            appendingComponents: ["illustrations"]
        )
    }


    @Test func borderModifier() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "border-modifier",
            colorSchemes: [.light]
        ) {
            DocumentationIllustration(height: 160) {
                HStack(spacing: .zero) {
                    Circle().fill(.gray.tertiary)
                    Circle().fill(.green)

                    Circle().fill(.mint)
                    .frame(width: 120, height: 100)
                    .border(.red.secondary, width: 2) // Highlight the frame of this view.

                    Circle().fill(.teal)
                    Circle().fill(.gray.tertiary)
                }
                .padding(.horizontal)
            }
        }
    }


    @Test func overlayAsLabel() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "overlay-as-label",
            colorSchemes: [.light]
        ) {
            DocumentationIllustration(height: 160) {
                HStack(spacing: .zero) {
                    Circle().fill(.gray.tertiary)

                    Capsule()
                    .fill(.teal.secondary)
                    .frame(width: 200, height: 100)
                    .overlay(alignment: .trailing) { // Label this view.
                        Text("A `Capsule` Shape")
                        .font(.caption)
                    }

                    Circle().fill(.gray.tertiary)
                }
                .padding(.horizontal)
            }
        }
    }

}
