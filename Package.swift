// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Cryptor",
    platforms: [
        .macOS(.v15),
    ],
    targets: [
        .executableTarget(
            name: "Cryptor",
            resources: []
        ),    
    ]
)