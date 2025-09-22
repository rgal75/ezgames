import SwiftUI
import Game2048

@main
struct Game2048ExampleApp: App {
    private let feature: any Game2048Interface = Game2048()
    
    var body: some Scene {
        WindowGroup {
            AnyView(feature.start())
        }
    }
}
