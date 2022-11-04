import Foundation
import Network
import Combine

public protocol ReachabilityManagerProtocol {
    func networkStatusPublisher() -> AnyPublisher<ReachabilityManager.NetworkStatus, Never>
}

public class ReachabilityManager: ReachabilityManagerProtocol {
    public enum NetworkStatus {
        case connected, disconnected
    }

    public static let shared = ReachabilityManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    private let networkStatusSubject = PassthroughSubject<ReachabilityManager.NetworkStatus, Never>()

    private init() {
        startMonitor()
    }

    public func networkStatusPublisher() -> AnyPublisher<ReachabilityManager.NetworkStatus, Never> {
        networkStatusSubject.eraseToAnyPublisher()
    }
}

// MARK: - Private
private extension ReachabilityManager {
    func startMonitor() {
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                self.networkStatusSubject.send(.connected)
            default:
                self.networkStatusSubject.send(.disconnected)
            }
        }
        monitor.start(queue: queue)
    }
}
