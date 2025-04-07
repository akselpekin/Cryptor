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
    var extLength = UInt16(extData.count).bigEndian
    let lengthData = withUnsafeBytes(of: &extLength) { Data($0) }
    var encryptedData = Data()
    encryptedData.append(lengthData)
    encryptedData.append(extData)
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
    guard encryptedData.count > 2 else {
        throw NSError(domain: "Decryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid encrypted data"])
    }
    let extLengthData = encryptedData.prefix(2)
    let extLength = extLengthData.withUnsafeBytes { $0.load(as: UInt16.self) }.bigEndian
    let requiredHeaderSize = 2 + Int(extLength) + 12 + 16
    guard encryptedData.count > requiredHeaderSize else {
        throw NSError(domain: "Decryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid encrypted data"])
    }
    let extDataStart = encryptedData.index(encryptedData.startIndex, offsetBy: 2)
    let extDataEnd = encryptedData.index(extDataStart, offsetBy: Int(extLength))
    let extData = encryptedData[extDataStart..<extDataEnd]
    guard let originalExtension = String(data: extData, encoding: .utf8) else {
        throw NSError(domain: "Decryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode original file extension"])
    }
    let nonceStart = extDataEnd
    let nonceEnd = encryptedData.index(nonceStart, offsetBy: 12)
    let nonceData = encryptedData[nonceStart..<nonceEnd]
    let ciphertextAndTag = encryptedData[nonceEnd...]
    guard ciphertextAndTag.count > 16 else {
        throw NSError(domain: "Decryption", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid encrypted data"])
    }
    let ciphertext = ciphertextAndTag.prefix(ciphertextAndTag.count - 16)
    let tag = ciphertextAndTag.suffix(16)
    let nonce = try AES.GCM.Nonce(data: Data(nonceData))
    let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: Data(ciphertext), tag: Data(tag))
    let decryptedData = try AES.GCM.open(sealedBox, using: key)
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