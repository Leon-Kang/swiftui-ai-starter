import Observation

@MainActor
@Observable
final class ExampleFeatureViewModel {
    private(set) var items: [String] = []

    func reload() {
        items = ["First", "Second", "Third"]
    }
}
