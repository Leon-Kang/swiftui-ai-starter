import Foundation

public protocol AIEventRecorder: Sendable {
    func record(_ event: AIEvent, context: AIRequestContext) async
}
