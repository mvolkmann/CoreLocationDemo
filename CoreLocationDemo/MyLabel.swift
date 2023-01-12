import SwiftUI
import UIKit

struct MyLabel: UIViewRepresentable {
    let text: String

    // Creates a kind of UIView and configures its initial state.
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .red
        // There is no need to set the `text` property here
        // because `updateUIView` will do it.

        // This sets the priority with which a view resists
        // being made larger than its intrinsic size.
        // The UILabel will be the minimum size required to fit the text.
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
    }

    // Updates the state of the UIView created in `makeUIView`
    // with new data provided by a SwiftUI View.
    // This called after makeUIView and again every time a parameter changes.
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
    }
}
