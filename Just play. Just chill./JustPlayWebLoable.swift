import SwiftUI
import Combine
import WebKit

// MARK: - Протоколы

protocol JustPlayWebLoadable: AnyObject {
    var state: JustPlayWebStatus { get set }
    func setConnectivity(_ available: Bool)
}

protocol JustPlayProgressMonitoring {
    func observeProgression()
    func monitor(_ webView: WKWebView)
}

// MARK: - Основной загрузчик веб-представления

final class JustPlayWebLoader: NSObject, ObservableObject, JustPlayWebLoadable, JustPlayProgressMonitoring {
    // MARK: - Свойства
    
    @Published var state: JustPlayWebStatus = .standby
    
    let resource: URL
    private var cancellables = Set<AnyCancellable>()
    private var progressPublisher = PassthroughSubject<Double, Never>()
    private var webViewProvider: (() -> WKWebView)?
    
    // MARK: - Инициализация
    
    init(resourceURL: URL) {
        self.resource = resourceURL
        super.init()
        observeProgression()
    }
    
    // MARK: - Публичные методы
    
    func attachWebView(factory: @escaping () -> WKWebView) {
        webViewProvider = factory
        triggerLoad()
    }
    
    func setConnectivity(_ available: Bool) {
        switch (available, state) {
        case (true, .noConnection):
            triggerLoad()
        case (false, _):
            state = .noConnection
        default:
            break
        }
    }
    
    // MARK: - Приватные методы загрузки
    
    private func triggerLoad() {
        guard let webView = webViewProvider?() else { return }
        
        let request = URLRequest(url: resource, timeoutInterval: 12)
        state = .progressing(progress: 0)
        
        webView.navigationDelegate = self
        webView.load(request)
        monitor(webView)
    }
    
    // MARK: - Методы мониторинга
    
    func observeProgression() {
        progressPublisher
            .removeDuplicates()
            .sink { [weak self] progress in
                guard let self else { return }
                self.state = progress < 1.0 ? .progressing(progress: progress) : .finished
            }
            .store(in: &cancellables)
    }
    
    func monitor(_ webView: WKWebView) {
        webView.publisher(for: \.estimatedProgress)
            .sink { [weak self] progress in
                self?.progressPublisher.send(progress)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Расширение для обработки навигации

extension JustPlayWebLoader: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleNavigationError(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleNavigationError(error)
    }
    
    private func handleNavigationError(_ error: Error) {
        state = .failure(reason: error.localizedDescription)
    }
}

// MARK: - Расширения для улучшения функциональности

extension JustPlayWebLoader {
    convenience init?(urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(resourceURL: url)
    }
}
