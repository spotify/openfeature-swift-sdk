import Foundation
import os

public class OpenFeatureClient: Client {
    // TODO: We use DispatchQueue here instead of being an actor to not lock into new versions of Swift
    private let hookQueue = DispatchQueue(label: "dev.openfeature.client.hook")
    private let contextQueue = DispatchQueue(label: "dev.openfeature.client.context")

    private var openFeatureApi: OpenFeatureAPI
    private(set) var name: String?
    private(set) var version: String?

    private var _metadata: Metadata
    public var metadata: Metadata {
        return _metadata
    }

    private var _hooks: [any Hook] = []
    public var hooks: [any Hook] {
        return _hooks
    }

    private var hookSupport = HookSupport()
    private var logger = Logger()

    public init(openFeatureApi: OpenFeatureAPI, name: String?, version: String?) {
        self.openFeatureApi = openFeatureApi
        self.name = name
        self.version = version
        self._metadata = ClientMetadata(name: name)
    }

    public func addHooks(_ hooks: any Hook...) {
        self.hookQueue.sync {
            self._hooks.append(contentsOf: hooks)
        }
    }
}

extension OpenFeatureClient {
    // MARK: Generics
    public func getValue<T>(key: String, defaultValue: T) -> T where T: AllowedFlagValueType {
        getDetails(key: key, defaultValue: defaultValue).value
    }

    public func getValue<T>(key: String, defaultValue: T, options: FlagEvaluationOptions) -> T
    where T: AllowedFlagValueType {
        getDetails(key: key, defaultValue: defaultValue, options: options).value
    }

    public func getDetails<T>(key: String, defaultValue: T)
        -> FlagEvaluationDetails<T> where T: AllowedFlagValueType, T: Equatable
    {
        getDetails(key: key, defaultValue: defaultValue, options: FlagEvaluationOptions())
    }

    public func getDetails<T>(key: String, defaultValue: T, options: FlagEvaluationOptions)
        -> FlagEvaluationDetails<T> where T: AllowedFlagValueType, T: Equatable
    {
        evaluateFlag(
            flagValueType: T.flagValueType,
            key: key,
            defaultValue: defaultValue,
            options: options
        )
    }
}

extension OpenFeatureClient {
    public struct ClientMetadata: Metadata {
        public var name: String?
    }
}

extension OpenFeatureClient {
    private func evaluateFlag<T>(
        flagValueType: FlagValueType,
        key: String,
        defaultValue: T,
        options: FlagEvaluationOptions?
    ) -> FlagEvaluationDetails<T> {
        let options = options ?? FlagEvaluationOptions(hooks: [], hookHints: [:])
        let hints = options.hookHints
        let context = openFeatureApi.getEvaluationContext()

        var details = FlagEvaluationDetails(flagKey: key, value: defaultValue)
        let provider = openFeatureApi.getProvider() ?? NoOpProvider()
        let mergedHooks = provider.hooks + options.hooks + hooks + openFeatureApi.hooks
        let hookCtx = HookContext(
            flagKey: key,
            type: flagValueType,
            defaultValue: defaultValue,
            ctx: context,
            clientMetadata: self.metadata,
            providerMetadata: provider.metadata)

        do {
            hookSupport.beforeHooks(flagValueType: flagValueType, hookCtx: hookCtx, hooks: mergedHooks, hints: hints)

            let providerEval = try createProviderEvaluation(
                flagValueType: flagValueType,
                key: key,
                context: context,
                defaultValue: defaultValue,
                provider: provider)

            let evalDetails = FlagEvaluationDetails<T>.from(providerEval: providerEval, flagKey: key)
            details = evalDetails

            try hookSupport.afterHooks(
                flagValueType: flagValueType, hookCtx: hookCtx, details: evalDetails, hooks: mergedHooks, hints: hints)
        } catch {
            logger.error("Unable to correctly evaluate flag with key \(key) due to exception \(error)")

            if let error = error as? OpenFeatureError {
                details.errorCode = error.errorCode()
            } else {
                details.errorCode = .general
            }

            details.errorMessage = "\(error)"
            details.reason = Reason.error.rawValue

            hookSupport.errorHooks(
                flagValueType: flagValueType, hookCtx: hookCtx, error: error, hooks: mergedHooks, hints: hints)
        }

        hookSupport.afterAllHooks(
            flagValueType: flagValueType, hookCtx: hookCtx, hooks: mergedHooks, hints: hints)

        return details
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func createProviderEvaluation<V>(
        flagValueType: FlagValueType,
        key: String,
        context: EvaluationContext?,
        defaultValue: V,
        provider: FeatureProvider
    ) throws -> ProviderEvaluation<V> {
        switch flagValueType {
        case .boolean:
            guard let defaultValue = defaultValue as? Bool else {
                break
            }

            if let evaluation = try provider.getBooleanEvaluation(
                key: key,
                defaultValue: defaultValue,
                context: context) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .string:
            guard let defaultValue = defaultValue as? String else {
                break
            }

            if let evaluation = try provider.getStringEvaluation(
                key: key,
                defaultValue: defaultValue,
                context: context) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .integer:
            guard let defaultValue = defaultValue as? Int64 else {
                break
            }

            if let evaluation = try provider.getIntegerEvaluation(
                key: key,
                defaultValue: defaultValue,
                context: context) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .double:
            guard let defaultValue = defaultValue as? Double else {
                break
            }

            if let evaluation = try provider.getDoubleEvaluation(
                key: key,
                defaultValue: defaultValue,
                context: context) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .object:
            guard let defaultValue = defaultValue as? Value else {
                break
            }

            if let evaluation = try provider.getObjectEvaluation(
                key: key,
                defaultValue: defaultValue,
                context: context) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        }

        throw OpenFeatureError.generalError(message: "Unable to match default value type with flag value type")
    }
}
