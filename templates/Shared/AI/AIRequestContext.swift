import Foundation

public struct AIRequestContext: Sendable {
    public let feature: String
    public let timeout: TimeInterval
    public let allowsRetry: Bool
    public let cancellationBehavior: AICancellationBehavior
    public let telemetry: AITelemetry
    public let cachePolicy: AICachePolicy
    public let traceID: UUID
    public let safeMetadata: AIMetadata

    public init(
        feature: String,
        timeout: TimeInterval = 15,
        allowsRetry: Bool = true,
        cancellationBehavior: AICancellationBehavior = .cooperative,
        telemetry: AITelemetry = .init(scope: "default"),
        cachePolicy: AICachePolicy = .ephemeral,
        traceID: UUID = UUID(),
        safeMetadata: AIMetadata = AIMetadata()
    ) {
        self.feature = feature
        self.timeout = timeout
        self.allowsRetry = allowsRetry
        self.cancellationBehavior = cancellationBehavior
        self.telemetry = telemetry
        self.cachePolicy = cachePolicy
        self.traceID = traceID
        self.safeMetadata = safeMetadata
    }
}
