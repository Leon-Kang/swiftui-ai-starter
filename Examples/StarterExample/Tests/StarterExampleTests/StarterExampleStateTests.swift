import XCTest
@testable import StarterExample

final class StarterExampleStateTests: XCTestCase {
    func testCompletingTaskUpdatesCount() {
        var state = StarterExampleState()

        state.completeTask()

        XCTAssertEqual(state.completedTasks, 1)
    }

    func testMinimalAIIntegrationUsesStarterRuntime() async throws {
        let summary = try await StarterExampleSummarizer().summarize("Hello AI")

        XCTAssertEqual(summary.bullets, ["Processed 8 characters"])
    }
}
