import ProjectDescription

private let baseBundleId = "red.razvan.kontacts"

let project = Project(
    name: "Contacts",
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: baseBundleId,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .target(name: "Repository")
            ]
        ),
        .target(
            name: "Repository",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(baseBundleId).repository",
            sources: ["Repository/Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)
