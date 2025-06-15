import SwiftUI
import AppKit

@main
struct CryptorApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        if let icon = NSImage(named: NSImage.Name("cryptor_mac.icns")) {
            NSApplication.shared.applicationIconImage = icon
        }
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
    @State private var outputMessage: String = ""

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
                .cornerRadius(12)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Cryptor 1.1")
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
                HStack(spacing: 8) {
                    TextField("Your secret...", text: $userInput)
                        .textContentType(.newPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(18)
                        .frame(minWidth: 184)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    Button(action: {
                        userInput = generateStrongPassword()
                    }) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 22))
                            .frame(minWidth: 44, maxHeight: 57)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                HStack {
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
                    
                    // Output Text Field (read-only, no outline)
                    TextField("", text: $outputMessage)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(18)
                        .frame(minWidth: 184)
                        .disabled(true)
                }
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
        //print("Lock action triggered")
    }

    func unlockAction() {
        //print("Unlock action triggered")
    }

    func confirmAction() {
        do {
            if selectedSetting.lowercased() == "lock" {
                try encryptFile(at: filePath, with: userInput)
                outputMessage = "Encryption succeeded."
            } else if selectedSetting.lowercased() == "unlock" {
                try decryptFile(at: filePath, with: userInput)
                outputMessage = "Decryption succeeded."
            } else {
                outputMessage = "Invalid: Use 'lock' for encryption or 'unlock' for decryption."
            }
        } catch {
            outputMessage = "Operation failed: \(error.localizedDescription)"
        }
        print(outputMessage)
    }

    func generateStrongPassword(length: Int = 20) -> String {
        let charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+{}[]:;<>?,./"
        var result = ""
        for _ in 0..<length {
            if let randomChar = charset.randomElement() {
                result.append(randomChar)
            }
        }
        return result
    }
}