import XCTest
@testable import StarterExample

final class StarterExampleStateTests: XCTestCase {
    func testCompletingTaskUpdatesCount() {
        var state = StarterExampleState()

        state.completeTask()

        XCTAssertEqual(state.completedTasks, 1)
    }
}
