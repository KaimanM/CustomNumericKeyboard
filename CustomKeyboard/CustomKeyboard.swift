//
//  CustomKeyboard.swift
//  CustomKeyboard
//
//  Created by Kaiman Mehmet on 30/05/2023.
//

import SwiftUI


extension TextField {
    @ViewBuilder
    func inputView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .background {
                SetTextFieldKeyboard(keyboardContent: content())
            }
    }

    @ViewBuilder
    func inputView2<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .background {
                SetTextFieldKeyboard2(keyboardContent: content())
            }
    }
}

fileprivate struct SetTextFieldKeyboard<Content: View>: UIViewRepresentable {
    var keyboardContent: Content
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let textFieldContainerView = uiView.superview?.superview {
                if let textField = textFieldContainerView.findTextField {
                    let hostingController = UIHostingController(rootView: keyboardContent)
                    hostingController.view.frame = .init(origin: .zero, size: hostingController.view.intrinsicContentSize)
                    textField.inputView = hostingController.view
                } else {
                    print("failed to find text field")
                }
            }
        }
    }
}

fileprivate struct SetTextFieldKeyboard2<Content: View>: UIViewRepresentable {
    var keyboardContent: Content
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let textFieldContainerView = uiView.superview?.superview {
                if let textField = textFieldContainerView.findTextField2 {
                    let hostingController = UIHostingController(rootView: keyboardContent)
                    hostingController.view.frame = .init(origin: .zero, size: hostingController.view.intrinsicContentSize)
                    textField.inputView = hostingController.view
                } else {
                    print("failed to find text field")
                }
            }
        }
    }
}

fileprivate extension UIView {
    var allSubViews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }

    var findTextField: UITextField? {
        if let textField = allSubViews.first(where: { view in
            view is UITextField
        }) as? UITextField {
            return textField
        }

        return nil
    }

    var findTextField2: UITextField? {
        if let textField = allSubViews.last(where: { view in
            view is UITextField
        }) as? UITextField {
            return textField
        }

        return nil
    }
}
