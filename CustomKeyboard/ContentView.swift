//
//  ContentView.swift
//  CustomKeyboard
//
//  Created by Kaiman Mehmet on 30/05/2023.
//

import SwiftUI
import Introspect

struct ContentView: View {
    @State private var text: String = ""
    @State private var text2: String = ""
    private let textFieldObserver = TextFieldObserver()

    enum FocusStates: Hashable {
        case first, second
    }

    @FocusState var focus: FocusStates?

    @ViewBuilder
    func testView() -> some View {
        ZStack {
            Color.black

            Button("next") {
                focus = FocusStates.second
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
    }


    var body: some View {
        VStack {
            Text("Custom Keyboard Demo")
                .font(.largeTitle)
//            Text(text)
//            Button("testy ") {
//                self.focus = focus == .first ? .second : .first
//            }
            Group {
                TextField("Textfield 1", text: $text)
                    .introspectTextField(customize: { textField in
                        textField.inputView = NumericKeyboardBuilder().build(text: $text, textField: textField, onSubmit: {
                            focus = .second
                        }, onDismiss: {
                            focus = nil
                        })
                        textField.inputAssistantItem.leadingBarButtonGroups = []
                        textField.inputAssistantItem.trailingBarButtonGroups = []
                        textField.keyboardAppearance = .dark
                        textField.addTarget(
                            self.textFieldObserver,
                            action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                            for: .editingDidBegin
                        )
                    })
                    .focused($focus, equals: FocusStates.first)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
            }
            Spacer()
            Group {
                TextField("Textfield 2", text: $text2)
                    .introspectTextField(customize: { textField in
                        textField.inputView = NumericKeyboardBuilder()
                            .build(text: $text2, textField:  textField, onSubmit: {
                                focus = nil
                            }, submitLabel: .done,

                                   onPrevious: {
                                focus = .first
                            }, onDismiss: {
                                focus = nil
                            })
                        textField.inputAssistantItem.leadingBarButtonGroups = []
                        textField.inputAssistantItem.trailingBarButtonGroups = []
                        textField.keyboardAppearance = .dark
                        textField.addTarget(
                            self.textFieldObserver,
                            action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                            for: .editingDidBegin
                        )
                    })
                    .focused($focus, equals: FocusStates.second)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .safeAreaInset(edge: .bottom) { //this will push the view when the keyboad is shown
                        Color.clear.frame(height: focus == .second ? 30 : 0)
                    }
            }
        }
        .onChange(of: focus, perform: { newValue in
            print("new focus state", newValue)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color
                .gray
                .ignoresSafeArea()
        }
    }
}


private class TextFieldObserver: NSObject {
    @objc
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
