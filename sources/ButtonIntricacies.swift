//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz.
//

import SwiftUI

// For "The Intricacies of glass circle buttons"


#Preview("Experiments") {
    ZStack {
        MeshGradient.wallOfIceAndFire
        .ignoresSafeArea()

        VStack {
            Button(
                "Glass Regular",
                systemImage: "envelope.badge.shield.half.filled",
                action: {}
            )
            .buttonStyle(.glass)

            Button(
                "Glass Prominent",
                systemImage: "envelope.badge.shield.half.filled",
                action: {}
            )
            .buttonStyle(.glassProminent)

            Button(
                "Capsule",
                systemImage: "envelope.badge.shield.half.filled",
                action: {}
            )
            .buttonBorderShape(.capsule)
            .buttonStyle(.glassProminent)

            Button(
                "Glass Prominent",
                systemImage: "envelope.badge.shield.half.filled",
                action: {}
            )
            .labelStyle(.iconOnly)
            .buttonBorderShape(.capsule)
            .buttonStyle(.glassProminent)

            Button(
                "Glass Prominent",
                systemImage: "envelope.badge.shield.half.filled",
                action: {}
            )
            .labelStyle(.iconOnly)
            .buttonBorderShape(.circle)
            .buttonStyle(.glassProminent)

            Button(
                "Glass Prominent",
                systemImage: "envelope.badge.shield.half.filled",
                action: {}
            )
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .padding(8)
            .debugOverlay(.hairline)
            .glassEffect(.regular.interactive())

            Button(
                "Glass Prominent",
                systemImage: "envelope.badge.shield.half.filled",
                action: {}
            )
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .frame(squareOf: 15, alignment: .centerLastTextBaseline)
            .frame(squareOf: 44, alignment: .center)
            .debugOverlay(.hairline)
            .glassEffect(.regular.interactive())

            HStack(alignment: .firstTextBaseline) {
                Label("Label", systemImage: "circle")

                Button(
                    "Glass Prominent",
                    systemImage: "envelope.badge.shield.half.filled",
                    action: {}
                )
                .font(.title)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .frame(squareOf: 15, alignment: .centerLastTextBaseline)
                .frame(squareOf: 44, alignment: .center)
                .debugOverlay(.hairline)
                .glassEffect(.regular.interactive())

                Button(
                    "Glass Prominent",
                    systemImage: "envelope.badge.shield.half.filled",
                    action: {}
                )
                .font(.title)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
        //                .frame(squareOf: 15, alignment: .centerLastTextBaseline)
                .frame(squareOf: 44, alignment: .center)
                .debugOverlay(.hairline)
                .glassEffect(.regular.interactive())
            }
        }
    }

}
