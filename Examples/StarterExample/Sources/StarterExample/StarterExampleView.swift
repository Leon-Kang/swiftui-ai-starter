import SwiftUI

public struct StarterExampleView: View {
    private let title: LocalizedStringKey
    private let state: StarterExampleState

    public init(title: LocalizedStringKey, state: StarterExampleState) {
        self.title = title
        self.state = state
    }

    public var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
            Text(state.completedTasks, format: .number)
                .monospacedDigit()
        }
        .padding()
    }
}
