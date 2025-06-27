import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol JustPlayProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol JustPlayBackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Расширенная структура загрузки

struct JustPlayLoadingOverlay<Background: View>: View, JustPlayProgressDisplayable {
    let progress: Double
    let backgroundView: Background
    
    var progressPercentage: Int { Int(progress * 100) }
    
    init(progress: Double, @ViewBuilder background: () -> Background) {
        self.progress = progress
        self.backgroundView = background()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundView
                content(in: geo)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func content(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Zombie Survival Loading")
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .foregroundColor(.red)
                .shadow(color: .red.opacity(0.7), radius: 8, x: 0, y: 0)
                .padding(.bottom, 8)
            Text("Stay alive while we prepare your apocalypse...")
                .font(.system(size: 18, weight: .medium, design: .monospaced))
                .foregroundColor(.red.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
            progressSection(width: min(geometry.size.width * 0.7, 400))
            Spacer()
            Text("Loading \(progressPercentage)%")
                .font(.system(size: 20, weight: .medium, design: .monospaced))
                .foregroundColor(.red)
                .shadow(color: .red.opacity(0.7), radius: 4, x: 0, y: 0)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func progressSection(width: CGFloat) -> some View {
        VStack(spacing: 16) {
            JustPlayProgressBar(value: progress)
                .frame(width: width, height: 16)
        }
        .padding(20)
        .background(Color.black.opacity(0.55))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.red.opacity(0.7), lineWidth: 2)
        )
    }
}

// MARK: - Фоновые представления

extension JustPlayLoadingOverlay where Background == JustPlayZombieBackground {
    init(progress: Double) {
        self.init(progress: progress) { JustPlayZombieBackground() }
    }
}

struct JustPlayZombieBackground: View, JustPlayBackgroundProviding {
    func makeBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black, Color.red.opacity(0.2), Color.black]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var body: some View {
        makeBackground()
    }
}

// MARK: - Индикатор прогресса с анимацией

struct JustPlayProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.red.opacity(0.15))
                    .frame(height: geometry.size.height)
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.red, Color.red.opacity(0.7), Color.red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: CGFloat(value) * geometry.size.width, height: geometry.size.height)
                    .shadow(color: .red.opacity(0.7), radius: 8, x: 0, y: 0)
                    .animation(.linear(duration: 0.2), value: value)
            }
        }
    }
}

// MARK: - Превью

#Preview("Zombie Loading") {
    JustPlayLoadingOverlay(progress: 0.42)
}

#Preview("Zombie Loading Horizontal") {
    JustPlayLoadingOverlay(progress: 0.42)
        .previewInterfaceOrientation(.landscapeRight)
}

