import Foundation

/// Interface used to resolve flags of varying types.
public protocol Client: Features {
    var metadata: Metadata { get }

    /// Return an optional client-level evaluation context.
    var evaluationContext: EvaluationContext? { get set }

    /// The hooks associated to this client.
    var hooks: [AnyHook] { get }

    /// Adds hooks for evaluation.
    /// Hooks are run in the order they're added in the before stage. They are run in reverse order for all
    /// other stages.
    func addHooks(_ hooks: AnyHook...)
}
