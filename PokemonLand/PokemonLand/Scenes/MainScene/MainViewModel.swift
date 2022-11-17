import SwiftUI
import Combine

protocol MainViewModelProtocol: ObservableObject {
    var tabItems: [TabItem] { get }
    var networkConnected: Bool { get }
    
    func setup()
    func getView(for item: TabItem) -> AnyView
}

class MainViewModel: MainViewModelProtocol {

    @Published var tabItems: [TabItem] = []
    @Published var networkConnected: Bool = true

    private let reachabilityManager: ReachabilityManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(reachabilityManager: ReachabilityManagerProtocol = ReachabilityManager.shared) {
        self.reachabilityManager = reachabilityManager
    }

    func setup() {
        networkMonitor()
        configureTabs()
    }

    func getView(for item: TabItem) -> AnyView {
        switch item.kind {
        case .list:
            return AnyView(ListViewStack())
        case .favorites:
            return AnyView(FavoritesListViewStack())
        }
    }
}

// MARK: - Private
private extension MainViewModel {
    func configureTabs() {
        tabItems = [.init(kind: .list), .init(kind: .favorites)]
    }

    func networkMonitor() {
        reachabilityManager.networkStatusPublisher()
            .receive(on: DispatchQueue.main)
            .sink { status in
                self.networkConnected = status == .connected
            }
            .store(in: &self.cancellables)
    }
}

