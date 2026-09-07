import Foundation

public struct AITelemetry: Sendable {
    public let scope: String
    public let metadata: AIMetadata

    public init(scope: String, metadata: AIMetadata = AIMetadata()) {
        self.scope = scope
        self.metadata = metadata
    }
}
