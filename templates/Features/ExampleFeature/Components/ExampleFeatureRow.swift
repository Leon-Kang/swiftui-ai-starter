import SwiftUI

struct ExampleFeatureRow: View {
    let title: String

    var body: some View {
        Text(title)
            .padding(.vertical, DSSpacing.xs)
    }
}

#if DEBUG
#Preview {
    ExampleFeatureRow(title: LocalizationKey.exampleRowPreviewTitle.localized)
}
#endif
