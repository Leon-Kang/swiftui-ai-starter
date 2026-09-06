public struct StarterExampleState: Equatable, Sendable {
    public private(set) var completedTasks: Int

    public init(completedTasks: Int = 0) {
        self.completedTasks = completedTasks
    }

    public mutating func completeTask() {
        completedTasks += 1
    }
}
