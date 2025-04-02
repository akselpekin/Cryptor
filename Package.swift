// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "enordecrypt",
    platforms: [
        .macOS(.v15),
    ],
    targets: [
        .executableTarget(
            name: "enordecrypt",
            resources: [
                .process("ASSETS"),
            ]
        ),    
    ]
)
