//
//  Illustration App
//  Created by Maic Lopez Saenz.
//


import SwiftUI


@main
struct IllustrationsApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}


struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "curlybraces")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Illustrations")
            Text("for")
                .font(.caption.italic())

            let trailing = Text("trailing")
                .font(.system(.title, design: .serif).italic())
            let closure = Text("{closure}")
                .font(.title.monospaced())
            Text("\(trailing) \(closure)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

