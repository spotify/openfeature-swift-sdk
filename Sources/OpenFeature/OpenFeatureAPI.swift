import Foundation

/// A global singleton which holds base configuration for the OpenFeature library.
/// Configuration here will be shared across all ``Client``s.
public class OpenFeatureAPI {
    private var _provider: FeatureProvider?
    private var _context: EvaluationContext?
    private(set) var hooks: [any Hook] = []

    /// The ``OpenFeatureAPI`` singleton
    static public let shared = OpenFeatureAPI()

    public init() {
    }

    public func setProvider(provider: FeatureProvider) async {
        await self.setProvider(provider: provider, initialContext: nil)
    }

    public func setProvider(provider: FeatureProvider, initialContext: EvaluationContext?) async {
        await provider.initialize(initialContext: initialContext ?? self._context)
        self._provider = provider
        guard let newEvaluationContext = initialContext else {
            return
        }
        self._context = newEvaluationContext
    }

    public func getProvider() -> FeatureProvider? {
        return self._provider
    }

    public func clearProvider() {
        self._provider = nil
    }

    public func setEvaluationContext(evaluationContext: EvaluationContext) async {
        await getProvider()?.onContextSet(oldContext: self._context, newContext: evaluationContext)
        // A provider evaluation reading the global ctx at this point would fail due to stale cache.
        // To prevent this, the provider should internally manage the ctx to use on each evaluation, and
        // make sure it's aligned with the values in the cache at all times. If no guarantees are offered by
        // the provider, the application can expect STALE resolves while setting a new global ctx
        self._context = evaluationContext
    }

    public func getEvaluationContext() -> EvaluationContext? {
        return self._context
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

    public func addHooks(hooks: (any Hook)...) {
        self.hooks.append(contentsOf: hooks)
    }

    public func clearHooks() {
        self.hooks.removeAll()
    }
}
