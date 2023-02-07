import Foundation
import OpenFeature

class BooleanHookMock: BooleanHook {
    public var beforeCalled = 0
    public var afterCalled = 0
    public var finallyAfterCalled = 0
    public var errorCalled = 0

    private var prefix: String
    private var addEval: (String) -> Void

    init() {
        self.prefix = ""
        self.addEval = { _ in }
    }

    init(prefix: String, addEval: @escaping (String) -> Void) {
        self.prefix = prefix
        self.addEval = addEval
    }

    func before(ctx: HookContext<Bool>, hints: [String: Any]) -> EvaluationContext? {
        beforeCalled += 1
        self.addEval(self.prefix.isEmpty ? "before" : "\(self.prefix) before")

        return nil
    }

    func after(ctx: HookContext<Bool>, details: FlagEvaluationDetails<Bool>, hints: [String: Any]) {
        afterCalled += 1
        self.addEval(self.prefix.isEmpty ? "after" : "\(self.prefix) after")
    }

    func error(ctx: HookContext<Bool>, error: Error, hints: [String: Any]) {
        errorCalled += 1
        self.addEval(self.prefix.isEmpty ? "error" : "\(self.prefix) error")
    }

    func finallyAfter(ctx: HookContext<Bool>, hints: [String: Any]) {
        finallyAfterCalled += 1
        self.addEval(self.prefix.isEmpty ? "finallyAfter" : "\(self.prefix) finallyAfter")
    }

    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return true
    }
}
