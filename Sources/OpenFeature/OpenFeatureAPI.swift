import Foundation

/// A global singleton which holds base configuration for the OpenFeature library.
/// Configuration here will be shared across all ``Client``s.
public class OpenFeatureAPI {
    private var _provider: FeatureProvider?
    private var _evaluationContext: EvaluationContext = MutableContext()
    private(set) var hooks: [AnyHook] = []

    /// The ``OpenFeatureAPI`` singleton
    static public let shared = OpenFeatureAPI()

    public init() {
    }

    public func setProvider(provider: FeatureProvider) async {
        await self.setProvider(provider: provider, initialContext: nil)
    }

    public func setProvider(provider: FeatureProvider, initialContext: EvaluationContext?) async {
        await provider.initialize(initialContext: initialContext ?? self._evaluationContext)
        self._provider = provider
        guard let newEvaluationContext = initialContext else {
            return
        }
        self._evaluationContext = newEvaluationContext
    }

    public func getProvider() -> FeatureProvider? {
        return self._provider
    }

    public func clearProvider() {
        self._provider = nil
    }

    public func setEvaluationContext(evaluationContext: EvaluationContext) async {
        await getProvider()?.onContextSet(oldContext: self._evaluationContext, newContext: evaluationContext)
        self._evaluationContext = evaluationContext
    }

    public func getEvaluationContext() -> EvaluationContext? {
        return self._evaluationContext
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
        self.hooks.append(contentsOf: hooks)
    }

    public func clearHooks() {
        self.hooks.removeAll()
    }
}
