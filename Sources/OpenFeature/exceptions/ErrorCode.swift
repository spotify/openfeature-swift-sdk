import Foundation

public enum ErrorCode: Int {
    case providerNotReady = 1
    case flagNotFound
    case parseError
    case typeMismatch
    case targetingKeyMissing
    case invalidContext
    case general
}
