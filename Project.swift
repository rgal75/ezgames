import ProjectDescription

let project = Project(
    name: "EZGames",
    targets: [
        .target(
            name: "EZGames",
            destinations: .iOS,
            product: .app,
            bundleId: "hu.galiasys.EZGames",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "EZGames/Sources",
                "EZGames/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "EZGamesTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "hu.galiasys.EZGamesTests",
            infoPlist: .default,
            buildableFolders: [
                "EZGames/Tests"
            ],
            dependencies: [.target(name: "EZGames")]
        ),
    ]
)
