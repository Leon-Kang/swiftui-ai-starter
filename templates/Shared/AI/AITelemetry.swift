import Foundation

struct AITelemetry: Sendable {
    let scope: String
    let metadata: [String: String]

    init(scope: String, metadata: [String: String] = [:]) {
        self.scope = scope
        self.metadata = metadata
    }
}
