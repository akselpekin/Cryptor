import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    @MainActor private var textField: NSTextField = {
        let tf = NSTextField(labelWithString: "Select a file.")
        tf.font = NSFont.systemFont(ofSize: 48, weight: .bold)
        tf.alignment = .center
        tf.textColor = .black
        tf.isEditable = false
        tf.isBordered = false
        tf.backgroundColor = .clear
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private var textFieldCenterXConstraint: NSLayoutConstraint?

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
        }

        window.contentView?.addSubview(textField)

        textFieldCenterXConstraint = textField.centerXAnchor.constraint(equalTo: window.contentView!.centerXAnchor)
        textFieldCenterXConstraint?.isActive = true
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: window.contentView!.centerYAnchor)
        ])

        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        textField.addGestureRecognizer(clickGesture)
        textField.isSelectable = true

        window.center()
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }

        @MainActor @objc private func handleClick(_ sender: NSClickGestureRecognizer) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 2.0
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            context.allowsImplicitAnimation = true
            self.textFieldCenterXConstraint?.constant = -1000
            self.window?.contentView?.layoutSubtreeIfNeeded()
        } completionHandler: {
       
        }
    }
}