import SwiftUI

struct DSEmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(DSColor.secondaryText)

            Text(title)
                .font(DSTypography.title)

            Text(message)
                .font(DSTypography.body)
                .foregroundStyle(DSColor.secondaryText)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                DSPrimaryButton(title: actionTitle, action: action)
            }
        }
        .padding(DSSpacing.lg)
    }
}

#if DEBUG
#Preview {
    DSEmptyStateView(
        icon: "tray",
        title: LocalizationKey.emptyStatePreviewTitle.localized,
        message: LocalizationKey.emptyStatePreviewMessage.localized,
        actionTitle: LocalizationKey.emptyStatePreviewAction.localized
    ) {}
}
#endif
