import SwiftUI

struct TileView: View {
    let value: Int
    let row: Int
    let col: Int
    
    var body: some View {
        Text("\(value)")
            .font(.title)
            .frame(width: 50, height: 50)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .padding(4)
            .background(Color.orange.opacity((sqrt(Double(value)) + 5) / 11))
            .foregroundColor(.white)
            .cornerRadius(8)
            .id("tile[\(row), \(col)]")
    }
}
