import SwiftUI

struct ExampleFeatureView: View {
    @State private var viewModel = ExampleFeatureViewModel()

    var body: some View {
        Group {
            if viewModel.items.isEmpty {
                DSEmptyStateView(
                    icon: "sparkles",
                    title: LocalizationKey.exampleFeatureEmptyTitle.localized,
                    message: LocalizationKey.exampleFeatureEmptyMessage.localized,
                    actionTitle: LocalizationKey.exampleFeatureReload.localized
                ) {
                    viewModel.reload()
                }
            } else {
                List(viewModel.items, id: \.self) { item in
                    Text(item)
                }
            }
        }
        .navigationTitle(LocalizationKey.exampleFeatureTitle.localized)
    }
}

#if DEBUG
#Preview {
    ExampleFeatureView()
}
#endif
