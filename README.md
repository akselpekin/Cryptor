# Cryptor 1.0

Cryptor is a simple macOS application for file encryption and decryption. It provides a minimal, modern SwiftUI interface where users can select a file, choose to either "Lock" (encrypt) or "Unlock" (decrypt) it, enter a secret (password), and then confirm the operation. The app processes the file accordingly and displays a status message.

## How It Works

- **File Selection:**  
  Click on the "Select File" text to open a Finder dialog and choose a file. The selected file path is then displayed.

- **Operation Selection:**  
  Choose between **Lock** (encrypt) and **Unlock** (decrypt) using mutually exclusive options. The selected option is visually indicated by bold black text with a black outline, while the unselected option is styled in a lesser manner.

- **Secret Input:**  
  Enter a secret (password) in the provided text field. The confirm button activates once text is entered.

- **Confirmation & Output:**  
  Press the **Confirm** button to perform encryption or decryption. An output field displays whether the operation succeeded or if an error occurred.

- **Modern SwiftUI Interface:**  
  The app uses SwiftUI (with some AppKit bridging) for a clean, borderless interface with a white, rounded-corner view.

### Requirements

- macOS 15 or later
- Swift 6.0 or later