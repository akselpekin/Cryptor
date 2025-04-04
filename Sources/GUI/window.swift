import SwiftUI
import AppKit

@main
struct CryptorApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
            }
        }    
    }
}

// MARK: - SwiftUI
struct ContentView: View {
    @State private var filePath: String = "Select a File"
    @State private var selectedSetting: String = "Lock"
    @State private var isLockSelected: Bool = true
    @State private var userInput: String = ""

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
                .cornerRadius(12)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Cryptor 1.0")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)

                Text(filePath)
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        openFile()
                    }

                HStack(spacing: 20) {
                    Button(action: {
                        selectedSetting = "Lock"
                        isLockSelected = true
                        lockAction()
                    }) {
                        Text("Lock")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isLockSelected ? Color.black : Color.clear, lineWidth: 2)
                    )

                    Button(action: {
                        selectedSetting = "Unlock"
                        isLockSelected = false
                        unlockAction()
                    }) {
                        Text("Unlock")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(!isLockSelected ? Color.black : Color.clear, lineWidth: 2)
                    )
                }

                // Secret Input Field
                TextField("Your secret...", text: $userInput)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(18)
                    .frame(minWidth: 184)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )

                // Confirm Button
                Button(action: {
                    confirmAction()
                }) {
                    Text("Confirm")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(userInput.isEmpty ? .gray : .black)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(userInput.isEmpty ? Color.gray : Color.black, lineWidth: 2)
                )
                .disabled(userInput.isEmpty)
            }
            .padding(20)
        }
    }

    func openFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true

        if panel.runModal() == .OK, let url = panel.url {
            filePath = url.path
        }
    }

    func lockAction() {
        print("Lock action triggered")
    }

    func unlockAction() {
        print("Unlock action triggered")
    }

    func confirmAction() {
        print("Confirm action triggered with input: \(userInput)")
    }
}