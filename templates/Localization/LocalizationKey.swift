import Foundation

enum LocalizationKey: String {
    case commonContinue = "common.continue"
    case commonCancel = "common.cancel"
    case exampleFeatureTitle = "example.feature.title"
    case exampleFeatureEmptyTitle = "example.feature.empty.title"
    case exampleFeatureEmptyMessage = "example.feature.empty.message"
    case exampleFeatureReload = "example.feature.reload"
    case emptyStatePreviewTitle = "preview.empty-state.title"
    case emptyStatePreviewMessage = "preview.empty-state.message"
    case emptyStatePreviewAction = "preview.empty-state.action"
    case primaryButtonPreviewTitle = "preview.primary-button.title"
    case exampleRowPreviewTitle = "preview.example-row.title"
}

extension LocalizationKey {
    var localized: String {
        String(localized: String.LocalizationValue(rawValue))
    }
}
