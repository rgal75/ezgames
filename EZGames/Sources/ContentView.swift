import Game2048
import SwiftUI

public struct ContentView: View {
    private let game2048 = Game2048()

    public var body: some View {
        AnyView(game2048.start())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
