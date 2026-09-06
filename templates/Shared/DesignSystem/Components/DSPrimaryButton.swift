import SwiftUI

struct DSPrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void

    init(
        title: String,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .font(DSTypography.button)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(isEnabled ? DSColor.primaryAction : DSColor.disabledAction)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium, style: .continuous))
        }
        .disabled(!isEnabled || isLoading)
    }
}

#if DEBUG
#Preview {
    DSPrimaryButton(title: LocalizationKey.primaryButtonPreviewTitle.localized) {}
        .padding()
}
#endif
