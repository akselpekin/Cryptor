import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    @MainActor private var titleLabel: NSTextField = {
        let tf = NSTextField(labelWithString: "Cryptor 1.0")
        tf.font = NSFont.systemFont(ofSize: 32, weight: .semibold)
        tf.alignment = .left
        tf.textColor = .black
        tf.isEditable = false
        tf.isBordered = false
        tf.backgroundColor = .clear
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 400),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = true
        window.backgroundColor = .clear
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = false
        window.isMovableByWindowBackground = true

        if let contentView = window.contentView {
            contentView.wantsLayer = true
            if let layer = contentView.layer {
                layer.cornerRadius = 12.0
                layer.masksToBounds = true
                layer.backgroundColor = NSColor.white.cgColor
            }

            contentView.addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20)
            ])
        }

        window.center()
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
}