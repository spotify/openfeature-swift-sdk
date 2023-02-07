import Foundation

/// A global singleton which holds base configuration for the OpenFeature library.
/// Configuration here will be shared across all ``Client``s.
public class OpenFeatureAPI {
    // TODO: We use DispatchQueue here instead of being an actor to not lock into new versions of Swift
    private let contextQueue = DispatchQueue(label: "dev.openfeature.api.context")
    private let providerQueue = DispatchQueue(label: "dev.openfeature.api.provider")
    private let hookQueue = DispatchQueue(label: "dev.openfeature.api.hook")

    private var _provider: FeatureProvider?
    public var provider: FeatureProvider? {
        get {
            return self._provider
        }
        set {
            self.providerQueue.sync {
                self._provider = newValue
            }
        }
    }

    private var _evaluationContext: EvaluationContext?
    public var evaluationContext: EvaluationContext? {
        get {
            return self._evaluationContext
        }
        set {
            self.contextQueue.sync {
                self._evaluationContext = newValue
            }
        }
    }

    private(set) var hooks: [AnyHook] = []

    /// The ``OpenFeatureAPI`` singleton
    static public let shared = OpenFeatureAPI()

    public init() {
    }

    public func getProviderMetadata() -> Metadata? {
        return self.provider?.metadata
    }

    public func getClient() -> Client {
        return OpenFeatureClient(openFeatureApi: self, name: nil, version: nil)
    }

    public func getClient(name: String?, version: String?) -> Client {
        return OpenFeatureClient(openFeatureApi: self, name: name, version: version)
    }

    public func addHooks(hooks: AnyHook...) {
        hookQueue.sync {
            self.hooks.append(contentsOf: hooks)
        }
    }

    public func clearHooks() {
        hookQueue.sync {
            self.hooks.removeAll()
        }
    }
}
