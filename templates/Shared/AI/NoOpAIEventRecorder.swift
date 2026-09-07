import Foundation

public struct NoOpAIEventRecorder: AIEventRecorder {
    public init() {}

    public func record(_ event: AIEvent, context: AIRequestContext) async {}
}
