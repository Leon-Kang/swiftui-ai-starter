import Foundation

@MainActor
final class ExampleFeatureViewModel: ObservableObject {
    @Published private(set) var items: [String] = []

    func reload() {
        items = ["First", "Second", "Third"]
    }
}
