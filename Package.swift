// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Republished",
  platforms: [.iOS(.v13), .macOS(.v12)],
  products: [
    .library(
      name: "Republished",
      targets: ["Republished"]
    ),
  ],
  dependencies: [
    //.package(url: "https://github.com/GoodHatsLLC/SwiftLintFix.git", from: "0.1.7"),
  ],
  targets: [
    .target(
      name: "Republished",
      dependencies: [],
      swiftSettings: Env.swiftSettings
    ),
    .testTarget(
      name: "RepublishedTests",
      dependencies: ["Republished"],
      exclude: ["RepublishedTests.xctestplan"]
    ),
  ]
)

// MARK: - Env

private enum Env {
  static let swiftSettings: [SwiftSetting] = {
    var settings: [SwiftSetting] = []
    settings.append(contentsOf: [
      .enableUpcomingFeature("ConciseMagicFile"),
      .enableUpcomingFeature("ExistentialAny"),
      .enableUpcomingFeature("StrictConcurrency"),
      .enableUpcomingFeature("ImplicitOpenExistentials"),
      .enableUpcomingFeature("BareSlashRegexLiterals"),
    ])
    return settings
  }()
}
