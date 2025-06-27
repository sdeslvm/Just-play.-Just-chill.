import SwiftUI
import Foundation

struct JustPlayEntryScreen: View {
    @StateObject private var loader: JustPlayWebLoader

    init(loader: JustPlayWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            JustPlayWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                JustPlayProgressIndicator(value: percent)
            case .failure(let err):
                JustPlayErrorIndicator(err: err)
            case .noConnection:
                JustPlayOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct JustPlayProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            JustPlayLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct JustPlayErrorIndicator: View {
    let err: String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct JustPlayOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
