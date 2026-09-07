@testable import SwiftUIAIStarter

actor FakeAIEventRecorder: AIEventRecorder {
    private(set) var events: [AIEvent] = []

    func record(_ event: AIEvent, context: AIRequestContext) {
        events.append(event)
    }
}
