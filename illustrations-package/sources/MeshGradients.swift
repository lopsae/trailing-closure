//
//  TrailingClosureIllustrations
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// Copied from FrameCutter project.
extension MeshGradient {

    static var wallOfIceAndFire: Self {
        MeshGradient(
            width: 4, height: 3,
            points: [
                [0.0, 0.0], [0.3, 0.0], [0.7, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.4, 0.8], [0.6, 0.2], [1.0, 0.5],
                [0.0, 1.0], [0.3, 1.0], [0.7, 1.0], [1.0, 1.0]
            ],
            colors: [
                .orange, .orange, .yellow, .yellow,
                .red, .red, .red, .red,
                .blue, .blue, .blue, .blue
            ]
        )
    }

}


#Preview("WallOfIceAndFire") {
    MeshGradient.wallOfIceAndFire
        .ignoresSafeArea()
}
