import Foundation

public struct AIMetadata: Sendable {
    public let localeIdentifier: String?
    public let appVersion: String?
    public let surface: String?
    public let experiment: String?

    public init(
        localeIdentifier: String? = nil,
        appVersion: String? = nil,
        surface: String? = nil,
        experiment: String? = nil
    ) {
        self.localeIdentifier = localeIdentifier
        self.appVersion = appVersion
        self.surface = surface
        self.experiment = experiment
    }
}
