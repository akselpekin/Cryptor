import SwiftUI
import AppKit

@main
struct CryptorApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - SwiftUI View

struct ContentView: View {
    @State private var filePath: String = "Select a File"

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
                        lockAction()
                    }) {
                        Text("Lock")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        unlockAction()
                    }) {
                        Text("Unlock")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(8)
                    }
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
        print("Lock action triggered")
    }

    func unlockAction() {
        print("Unlock action triggered")
    }
}

// MARK: - AppDelegate to remove default window decorations

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                window.styleMask = [.borderless]
                window.isOpaque = false
                window.backgroundColor = .clear
            }
        }
    }
}