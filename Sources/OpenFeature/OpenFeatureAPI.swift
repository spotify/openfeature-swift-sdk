import Foundation

/// A global singleton which holds base configuration for the OpenFeature library.
/// Configuration here will be shared across all ``Client``s.
public class OpenFeatureAPI {
    // TODO: We use DispatchQueue here instead of being an actor to not lock into new versions of Swift
    private let contextQueue = DispatchQueue(label: "dev.openfeature.api.context")
    private let providerQueue = DispatchQueue(label: "dev.openfeature.api.provider")
    private let hookQueue = DispatchQueue(label: "dev.openfeature.api.hook")

    private var _provider: FeatureProvider?

    private var _evaluationContext: EvaluationContext = MutableContext()
    public var evaluationContext: EvaluationContext {
        get {
            return self._evaluationContext
        }
        set {
            self.contextQueue.sync {
                getProvider()?.onContextSet(oldContext: self._evaluationContext, newContext: newValue)
                self._evaluationContext = newValue
            }
        }
    }

    private(set) var hooks: [AnyHook] = []

    /// The ``OpenFeatureAPI`` singleton
    static public let shared = OpenFeatureAPI()

    public init() {
    }

    public func getProvider() -> FeatureProvider? {
        return self._provider
    }

    public func setProvider(provider: FeatureProvider) {
        self.setProvider(provider: provider, initialContext: nil)
    }

    public func setProvider(provider: FeatureProvider, initialContext: EvaluationContext?) {
        self.contextQueue.sync {
            guard let newEvaluationContext = initialContext else {
                return
            }
            self._evaluationContext = newEvaluationContext
        }
        self.providerQueue.sync {
            self._provider = provider
            self._provider?.initialize(initialContext: initialContext ?? self._evaluationContext)
        }
    }

    public func clearProvider() {
        self.providerQueue.sync {
            self._provider = nil
        }
    }

    public func getProviderMetadata() -> Metadata? {
        return self.getProvider()?.metadata
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
