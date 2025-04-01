import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.closable, .resizable, .miniaturizable, .titled],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = .clear
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = false

        let visualEffectView = NSVisualEffectView(frame: window.contentView!.bounds)
        visualEffectView.autoresizingMask = [.width, .height]
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active

        let textField = NSTextField(labelWithString: "Select a file.")
        textField.font = NSFont.systemFont(ofSize: 48, weight: .bold)
        textField.alignment = .center
        textField.isEditable = false
        textField.isBordered = false
        textField.backgroundColor = .clear

        if let appearance = window.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) {
            textField.textColor = (appearance == .darkAqua) ? .white : .black
        }

        textField.translatesAutoresizingMaskIntoConstraints = false

        window.contentView?.addSubview(visualEffectView)
        window.contentView?.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: window.contentView!.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: window.contentView!.centerYAnchor)
        ])

        window.center()
        window.makeKeyAndOrderFront(nil)

        self.window = window
    }
}