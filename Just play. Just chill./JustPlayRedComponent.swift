import Foundation
import SwiftUI

struct JustPlayColorUtility {
    static func convertToColor(hexRepresentation hexString: String) -> Color {
        let sanitizedHex = hexString.trimmingCharacters(in: .alphanumerics.inverted)
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        
        let redComponent = Double((colorValue & 0xFF0000) >> 16) / 255.0
        let greenComponent = Double((colorValue & 0x00FF00) >> 8) / 255.0
        let blueComponent = Double(colorValue & 0x0000FF) / 255.0
        
        return Color(red: redComponent, green: greenComponent, blue: blueComponent)
    }
    
    static func convertToUIColor(hexRepresentation hexString: String) -> UIColor {
        let sanitizedHex = hexString.trimmingCharacters(in: .alphanumerics.inverted)
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        
        let redComponent = CGFloat((colorValue & 0xFF0000) >> 16) / 255.0
        let greenComponent = CGFloat((colorValue & 0x00FF00) >> 8) / 255.0
        let blueComponent = CGFloat(colorValue & 0x0000FF) / 255.0
        
        return UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
    }
}

struct JustPlayGameInitialView: View {
    private var gameResourceURL: URL { URL(string: "https://justchillgame.top/game")! }
    
    var body: some View {
        ZStack {
            Color(hex: "#000")
                .ignoresSafeArea()
            JustPlayEntryScreen(loader: .init(resourceURL: gameResourceURL))
        }
    }
}

#Preview {
    JustPlayGameInitialView()
}

extension Color {
    init(hex hexValue: String) {
        let sanitizedHex = hexValue.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        
        self.init(
            .sRGB,
            red: Double((colorValue >> 16) & 0xFF) / 255.0,
            green: Double((colorValue >> 8) & 0xFF) / 255.0,
            blue: Double(colorValue & 0xFF) / 255.0,
            opacity: 1.0
        )
    }
}
