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


    @Test func header() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "header",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(size: [600 , 315], drawsBorder: false) {
                RoundedRectangle(cornerRadius: 8)
                .fill(.teal.gradient)
                .frame(width: 360, height: 200)
                // Illustration adornments.
                .overlay(alignment: .trailing) {
                    HStack(alignment: .top, spacing: 4) {
                        Rectangle()
                            .fill(.red.secondary)
                            .frame(width: 2)
                        Text("Debugging Caption")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .frame(width: 100, alignment: .leading)
                    }
                    .padding(.leading, 8)
                    .alignmentGuide(.trailing) { $0[.leading] }
                }
            }
        }
    }


    @Test func borderModifier() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "border-modifier",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                HStack(spacing: .zero) {
                    Circle().fill(.gray.tertiary)
                    Circle().fill(.green)

                    Circle().fill(.mint)
                    .frame(width: 120, height: 100)
                    .border(.red.secondary, width: 4) // Highlight the frame of this view.

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
            usesFullComponentName: false
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


    @Test func overlayAsBorder() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "overlay-as-border",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                HStack(spacing: .zero) {
                    Circle().fill(.gray.tertiary)

                    Capsule()
                    .fill(.teal.secondary)
                    .frame(width: 200, height: 100)
                    .overlay(alignment: .trailing) { // Border this view.
                        Rectangle()
                        .strokeBorder(.red.secondary, lineWidth: 4)
                    }

                    Circle().fill(.gray.tertiary)
                }
                .padding(.horizontal)
            }
        }
    }


    @Test func overlayAsGeometry() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "overlay-as-geometry",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                HStack(spacing: .zero) {
                    Circle().fill(.gray.tertiary)

                    Capsule()
                    .fill(.teal.secondary)
                    .frame(width: 200, height: 100)
                    .overlay { // Print geometry of this view.
                        GeometryReader { geometry in
                            Text("""
                                size: \(geometry.size.debugDescription)
                                safeAreaInsets: \(String(describing:geometry.safeAreaInsets))
                                """)
                            .font(.caption.monospacedDigit())
                        }
                    }

                    Circle().fill(.gray.tertiary)
                }
                .padding(.horizontal)
            }
        }
    }


    @Test func overlayOverflow() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "overlay-overflow",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                HStack(spacing: .zero) {
                    Circle().fill(.gray.tertiary)

                    Capsule()
                    .fill(.teal.secondary)
                    .frame(width: 200, height: 100)
                    .overlay(alignment: .bottomLeading) {
                        Text("A large `Capsule`")
                        .font(.largeTitle)
                        .fixedSize() // Force the label to overflow.
                    }
                    .border(.red.secondary, width: 4) // Note the frame is still just the capsule.


                    Circle().fill(.gray.tertiary)
                }
                .padding(.horizontal)
            }
        }
    }


    @Test func firstTextBaseline() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "first-text-baseline",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                Text("""
                    The fence we walked between the years
                    Did balance us serene
                    """
                )
                .overlay(alignment: .centerFirstTextBaseline) {
                    Rectangle()
                    .fill(.red.secondary)
                    .frame(width: 350, height: 4)
                }
            }
        }
    }


    @Test func multipleAlignments() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "multiple-alignments",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                Text("""
                    We ached and almost touched that stuff
                    Our reach was never quite enough
                    If only we had taller been
                    """
                )
                .alignmentGuide(.leading) { dimensions in
                    dimensions[.leading] + 22
                }
                .overlay(alignment: .centerLastTextBaseline) {
                    Rectangle() // Last Baseline indicator.
                    .fill(.red.secondary)
                    .frame(width: 350, height: 4)
                }
                .overlay(alignment: .leading) {
                    Rectangle() // Leading indicator.
                    .fill(.red.secondary)
                    .frame(width: 4, height: 100)
                }
                .border(.teal.tertiary, width: 2) // Note the frame is still just the text.
            }
        }
    }


    @Test func floatingContent() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "floating-content",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                RoundedRectangle(cornerRadius: 8)
                .fill(.teal.gradient)
                .stroke(.indigo.gradient, lineWidth: 4)
                .frame(width: 100, height: 100)
                .overlay(alignment: .trailingLastTextBaseline) {
                    Text("A `RoundedRectangle`\nwith fill and stroke")
                    .fixedSize()
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .alignmentGuide(.trailing) { $0[.leading] } // Floating alignment!
                }
            }
        }
    }


    @Test func illustrationExample() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "illustration-example",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                Text("""
                    In the green
                    of leaf
                    and promising
                    of peach
                    """
                )
                .font(.subheadline)
                .padding(.horizontal, 4)
                .frame(width: 160, height: 100, alignment: .trailing)
                .background {
                    RoundedRectangle(cornerRadius: 8).fill(.teal.secondary)
                }
                // Illustration adornments.
                .overlay(alignment: .trailing) {
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(.red.secondary)
                            .frame(width: 2)
                        Text("Notice `Text` multiline alignment defaults to `leading`")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 100, alignment: .leading)
                    }
                    .padding(.leading, 8)
                    .alignmentGuide(.trailing) { $0[.leading] }
                }
            }
        }
    }


    @Test func debugOverlayExample() throws {
        try storage.renderAndStore(
            "overlay-as-debug-tool", "debug-overlay-example",
            usesFullComponentName: false
        ) {
            DocumentationIllustration(height: 160) {
                HStack(spacing: .zero) {
                    Text("view")
                    Text(".debugOverlay()")
                        .debugOverlay(.size, .alignment(.outerBottomTrailing))
                }
                .monospaced()
            }
        }
    }

}
