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
        // Game2048
        .target(
            name: "Game2048",
            destinations: .iOS,
            product: .framework,
            bundleId: "hu.galiasys.Game2048",
            infoPlist: .default,
            sources: .sourceFilesList(globs: [
                .glob("Features/Game2048/Interface/**"),
                .glob("Features/Game2048/UI/**", excluding: ["Features/Game2048/UI/Tests/**"]),
                .glob("Features/Game2048/Domain/**", excluding: ["Features/Game2048/Domain/Tests/**"]),
            ]),
            dependencies: []
        ),
        .target(
            name: "Game2048Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "hu.galiasys.Game2048Tests",
            infoPlist: .default,
            buildableFolders: [
                "Features/Game2048/UI/Tests",
                "Features/Game2048/Domain/Tests"
            ],
            dependencies: [.target(name: "Game2048")]
        ),
        .target(
            name: "Game2048Example",
            destinations: .iOS,
            product: .app,
            bundleId: "hu.galiasys.Game2048Example",
            infoPlist: .default,
            buildableFolders: [
                "Features/Game2048/Example"
            ],
            dependencies: [.target(name: "Game2048")]
        )
    ],
    schemes: [
        .scheme(
            name: "EZGames",
            shared: true,
            buildAction: .buildAction(targets: ["EZGames"]),
            testAction: .targets([
                "EZGamesTests",
                "Game2048Tests"
            ])
        ),
        .scheme(
            name: "Game2048Example",
            shared: true,
            buildAction: .buildAction(targets: ["Game2048Example"]),
            testAction: .targets([
                "Game2048Tests"
            ])
        )
    ]
)
