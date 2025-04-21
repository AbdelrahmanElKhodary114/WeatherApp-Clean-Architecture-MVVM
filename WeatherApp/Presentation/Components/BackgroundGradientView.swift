import SwiftUI

struct BackgroundGradientView: View {
    var colors: [Color] = [
        Color(red: 0.1, green: 0.1, blue: 0.2),
        Color(red: 0.2, green: 0.15, blue: 0.3)
    ]
    var startPoint: UnitPoint = .topLeading
    var endPoint: UnitPoint = .bottomTrailing
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            )
        }
    }
}

