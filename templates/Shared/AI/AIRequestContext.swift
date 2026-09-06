import Foundation

struct AIRequestContext: Sendable {
    let feature: String
    let timeout: TimeInterval
    let allowsRetry: Bool
    let cancellationBehavior: AICancellationBehavior
    let telemetry: AITelemetry
    let cachePolicy: AICachePolicy
    let traceID: UUID
    let userMetadata: [String: String]

    init(
        feature: String,
        timeout: TimeInterval = 15,
        allowsRetry: Bool = true,
        cancellationBehavior: AICancellationBehavior = .cooperative,
        telemetry: AITelemetry = .init(scope: "default"),
        cachePolicy: AICachePolicy = .ephemeral,
        traceID: UUID = UUID(),
        userMetadata: [String: String] = [:]
    ) {
        self.feature = feature
        self.timeout = timeout
        self.allowsRetry = allowsRetry
        self.cancellationBehavior = cancellationBehavior
        self.telemetry = telemetry
        self.cachePolicy = cachePolicy
        self.traceID = traceID
        self.userMetadata = userMetadata
    }
}
