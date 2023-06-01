//
//  Keeb.swift
//  CustomKeyboard
//
//  Created by Kaiman Mehmet on 30/05/2023.
//

import SwiftUI
import AudioToolbox

struct NumericKeyboard: View {
    @Binding var text: String
    let textField: UITextField
    var onSubmit: Action? = nil
    var submitLabel: SubmitLabel
    var onPrevious: Action? = nil
    var onDismiss: Action

    let numbers = (1...9).map { "\($0)" }
    let darkButtonGray = Color(red: 50/255, green: 50/255, blue: 50/255)

    let columns = [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))]
    enum SubmitLabel: String { case next, done }

    var body: some View {
        ZStack {
            HStack {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(numbers, id: \.self) { item in
                        key(input: item)
                    }
                    key(input: ".")
                    key(input: "0")
                    deleteKey
                }
                .frame(width: 260)
                modifierPane
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(.regularMaterial)
    }

    var modifierPane: some View {
        VStack(spacing: 10) {
            if let onPrevious {
                Button {
                    AudioServicesPlaySystemSound(1156)
                    onPrevious()
                } label: {
                    Text("previous")
                        .keyboardButtonLabel(foregroundColor: darkButtonGray, titleScale: .small, widthScale: .large)
                }
                .buttonStyle(.plain)
            } else {
                Spacer()
                    .frame(height: 60)
            }

            Button {
                AudioServicesPlaySystemSound(1104)
                text = ""
            } label: {
                Text("clear")
                    .keyboardButtonLabel(foregroundColor: .red, titleScale: .small, widthScale: .large)
            }


            if let onSubmit {
                Button {
                    AudioServicesPlaySystemSound(1156)
                    onSubmit()
                } label: {
                    Text(submitLabel.rawValue)
                        .keyboardButtonLabel(titleScale: .small, widthScale: .large)
                }
                .buttonStyle(.plain)
            } else {
                Spacer()
                    .frame(height: 130)
            }

            Button {
                AudioServicesPlaySystemSound(1156)
                onDismiss()
            } label: {
                Text("\(Image(systemName: "keyboard.chevron.compact.down"))")
                    .keyboardButtonLabel(foregroundColor: darkButtonGray, titleScale: .small, widthScale: .large)
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    func key(input: String) -> some View {
        Button {
            textField.insertText(input)
            AudioServicesPlaySystemSound(1104)
        } label: {
            Text(input)
                .keyboardButtonLabel(foregroundColor: Color(uiColor: .darkGray))
        }
        .buttonStyle(.plain)
    }

    var deleteKey: some View {
        Button {
            textField.deleteBackward()
            AudioServicesPlaySystemSound(1155)
        } label: {
            Text("\(Image(systemName: "delete.left"))")
                .keyboardButtonLabel(foregroundColor: darkButtonGray)
        }
        .buttonStyle(.plain)
    }
}

struct KeyboardButtonLabel: ViewModifier {
    enum Size { case small, large }
    var foregroundColor: Color
    var titleScale: Size
    var widthScale: Size
    var heightScale: Size

    func body(content: Content) -> some View {
        content
            .font(titleScale == .small ? .title3 : .title2)
            .foregroundColor(.white)
            .frame(width: widthScale == .small ? 80 : 120,
                   height: heightScale == .small ? 60 : 130)
            .background(foregroundColor)
            .cornerRadius(5)
            .background {
                Color.black
                    .cornerRadius(5)
                    .offset(y: 1.5)
            }
    }
}

extension Text {
    func keyboardButtonLabel(foregroundColor: Color = .blue,
                             titleScale: KeyboardButtonLabel.Size = .large,
                             widthScale: KeyboardButtonLabel.Size = .small,
                             heightScale: KeyboardButtonLabel.Size = .small) -> some View {
        modifier(KeyboardButtonLabel(foregroundColor: foregroundColor,
                                     titleScale: titleScale,
                                     widthScale: widthScale,
                                     heightScale: heightScale))
    }
}

struct NumericKeyboard_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        ZStack {
            Color.black
            NumericKeyboard(text: $text, textField: UITextField(), onSubmit: {}, submitLabel: .next, onPrevious: {}, onDismiss: {})
        }
        .preferredColorScheme(.dark)
    }
}

typealias Action = () -> Void

class NumericKeyboardBuilder {
    func build(text: Binding<String>,
               textField: UITextField,
               onSubmit: Action? = nil,
               submitLabel: NumericKeyboard.SubmitLabel = .next,
               onPrevious: Action? = nil,
               onDismiss: @escaping Action) -> UIView {
        let hostingController = UIHostingController(rootView: NumericKeyboard(text: text,
                                                                              textField: textField, onSubmit: onSubmit,
                                                                              submitLabel: submitLabel,
                                                                              onPrevious: onPrevious,
                                                                              onDismiss: onDismiss))
        hostingController.view.frame = .init(origin: .zero, size: hostingController.view.intrinsicContentSize)
        return hostingController.view
    }
}
