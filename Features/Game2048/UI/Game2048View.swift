import Foundation
import SwiftUI

public final class Game2048: Game2048Interface {
    public init() {}
    
    public func start() -> any View {
        Game2048View()
    }
}

struct Game2048View: View {
    var body: some View {
        Text("Game2048 Feature")
    }
}
