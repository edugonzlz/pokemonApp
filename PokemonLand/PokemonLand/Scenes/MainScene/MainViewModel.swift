import SwiftUI
import Combine

protocol MainViewModelProtocol: ObservableObject {
    var networkConnected: Bool { get }
}

class MainViewModel: MainViewModelProtocol {

    @Published var networkConnected: Bool = true

    private let reachabilityManager: ReachabilityManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(reachabilityManager: ReachabilityManagerProtocol = ReachabilityManager.shared) {
        self.reachabilityManager = reachabilityManager
        networkMonitor()
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
