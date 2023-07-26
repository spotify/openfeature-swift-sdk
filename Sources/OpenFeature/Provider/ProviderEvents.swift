import Foundation

public let ProviderEventDetailsKeyProvider = "Provider"
public let ProviderEventDetailsKeyClient = "Client"
public let ProviderEventDetailsKeyError = "Error"

public enum ProviderEvent: String, CaseIterable {
    case ready = "PROVIDER_READY"
    case error = "PROVIDER_ERROR"
    case configurationChanged = "PROVIDER_CONFIGURATION_CHANGED"
    case stale = "PROVIDER_STALE"

    var notification: NSNotification.Name {
        NSNotification.Name(rawValue)
    }
}
