import Foundation
import CryptoKit

// MARK: - Key Generation
func generateKey(from secret: String) -> SymmetricKey {
    let keyData = SHA256.hash(data: Data(secret.utf8))
    return SymmetricKey(data: Data(keyData))
}

// MARK: - Encryption
func encryptFile(at filePath: String, with secret: String) throws {
    let fileURL = URL(fileURLWithPath: filePath)
    let originalData = try Data(contentsOf: fileURL)
    let key = generateKey(from: secret)
    let nonce = AES.GCM.Nonce()
    let sealedBox = try AES.GCM.seal(originalData, using: key, nonce: nonce)
    let originalExtension = fileURL.pathExtension
    guard let extData = originalExtension.data(using: .utf8) else {
        throw NSError(domain: "Encryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode file extension."])
    }
    let extNonce = AES.GCM.Nonce()
    let extSealedBox = try AES.GCM.seal(extData, using: key, nonce: extNonce)
    var extCiphertextLength = UInt16(extSealedBox.ciphertext.count).bigEndian
    let extLengthData = withUnsafeBytes(of: &extCiphertextLength) { Data($0) }
    var encryptedData = Data()
    encryptedData.append(extLengthData)
    encryptedData.append(Data(extNonce))
    encryptedData.append(extSealedBox.ciphertext)
    encryptedData.append(extSealedBox.tag)
    encryptedData.append(Data(nonce))
    encryptedData.append(sealedBox.ciphertext)
    encryptedData.append(sealedBox.tag)
    let outputURL = fileURL.deletingPathExtension().appendingPathExtension("encrypted")
    try encryptedData.write(to: outputURL)
    print("Encrypted file saved to: \(outputURL.path)")
}

// MARK: - Decryption
func decryptFile(at filePath: String, with secret: String) throws {
    let fileURL = URL(fileURLWithPath: filePath)
    let encryptedData = try Data(contentsOf: fileURL)
    let key = generateKey(from: secret)
    let extLengthData = encryptedData.prefix(2)
    let extCiphertextLength = extLengthData.withUnsafeBytes { $0.load(as: UInt16.self) }.bigEndian
    let extHeaderSize = 2 + 12 + Int(extCiphertextLength) + 16
    guard encryptedData.count > extHeaderSize else {
        throw NSError(domain: "Decryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid encrypted data"])
    }
    let extNonceStart = encryptedData.index(encryptedData.startIndex, offsetBy: 2)
    let extNonceEnd = encryptedData.index(extNonceStart, offsetBy: 12)
    let extNonceData = encryptedData[extNonceStart..<extNonceEnd]
    let extCiphertextStart = extNonceEnd
    let extCiphertextEnd = encryptedData.index(extCiphertextStart, offsetBy: Int(extCiphertextLength))
    let extCiphertext = encryptedData[extCiphertextStart..<extCiphertextEnd]
    let extTagStart = extCiphertextEnd
    let extTagEnd = encryptedData.index(extTagStart, offsetBy: 16)
    let extTag = encryptedData[extTagStart..<extTagEnd]
    let extNonce = try AES.GCM.Nonce(data: Data(extNonceData))
    let extSealedBox = try AES.GCM.SealedBox(nonce: extNonce, ciphertext: Data(extCiphertext), tag: Data(extTag))
    let decryptedExtData = try AES.GCM.open(extSealedBox, using: key)
    guard let originalExtension = String(data: decryptedExtData, encoding: .utf8) else {
        throw NSError(domain: "Decryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode original file extension"])
    }
    let fileContentStart = extTagEnd
    let fileContentData = encryptedData.suffix(from: fileContentStart)
    guard fileContentData.count > 12 + 16 else {
        throw NSError(domain: "Decryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid encrypted file content"])
    }
    let fileNonceData = fileContentData.prefix(12)
    let fileTag = fileContentData.suffix(16)
    let fileCiphertext = fileContentData.dropFirst(12).dropLast(16)
    let fileNonce = try AES.GCM.Nonce(data: Data(fileNonceData))
    let fileSealedBox = try AES.GCM.SealedBox(nonce: fileNonce, ciphertext: Data(fileCiphertext), tag: Data(fileTag))
    let decryptedData = try AES.GCM.open(fileSealedBox, using: key)
    let baseName = fileURL.deletingPathExtension().lastPathComponent
    let outputURL = fileURL.deletingLastPathComponent().appendingPathComponent(baseName).appendingPathExtension(originalExtension)
    try decryptedData.write(to: outputURL)
    print("Decrypted file saved to: \(outputURL.path)")
}

// MARK: - File Processing
func processFile(filePath: String, choice: String, secret: String) {
    do {
        if choice.lowercased() == "lock" {
            try encryptFile(at: filePath, with: secret)
            print("Encryption succeeded.")
        } else if choice.lowercased() == "unlock" {
            try decryptFile(at: filePath, with: secret)
            print("Decryption succeeded.")
        } else {
            print("Invalid operation choice. Use 'lock' for encryption or 'unlock' for decryption.")
        }
    } catch {
        print("Operation failed: \(error.localizedDescription)")
    }
}