//
//  Trailing Closure Illustration App
//  Created by Maic Lopez Saenz.
//


@testable import IllustrationsApp

import PreviewUtilities
import SwiftUI
import Testing


@MainActor
struct IntricaciesOfCircularButtons {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try .init(
            filePath: #filePath,
            droppingComponents: 3, // filename, illustrations, illustration-app
            appendingComponents: ["illustrations", "intricacies-of-circular-buttons"]
        ) {
            // onImageStored
            cgImage, filename in
            Attachment.record(cgImage, named: filename, as: .png)
        }
    }


//    @Test func header() throws {
//        try storage.renderAndStore("header") {
//            // FIXME: Store into a sizing property.
//            DocumentationIllustration(size: [600 , 315], drawsBorder: false) {
//                RoundedRectangle(cornerRadius: 8)
//                .fill(.teal.gradient)
//                .frame(width: 360, height: 200)
//                // Illustration adornments.
//                .overlay(alignment: .trailing) {
//                    HStack(alignment: .top, spacing: 4) {
//                        Rectangle()
//                            .fill(.red.secondary)
//                            .frame(width: 2)
//                        Text("Debugging Caption")
//                            .font(.caption)
//                            .foregroundStyle(.tertiary)
//                            .frame(width: 100, alignment: .leading)
//                    }
//                    .padding(.leading, 8)
//                    .alignmentGuide(.trailing) { $0[.leading] }
//                }
//            }
//        }
//    }


    @Test func existingModifiers() throws {
        try storage.renderAndStore("existing-modifiers", strategy: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular, background: .fadedMoltenHorizon) {
                HStack {
                    let mountainsButton = Button("Mountains", systemImage: "mountain.2", action: {})

                    mountainsButton
                    .buttonStyle(.bordered) // FIXME: Seems like this cannot capture glass controls!

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
    }

}
