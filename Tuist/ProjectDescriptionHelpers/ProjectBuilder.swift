import ProjectDescription

public struct ProjectBuilder {
    private let name: String
    private let bundleIdPrefix: String
    private var features: [Feature] = []
    
    private init(name: String, bundleIdPrefix: String) {
        self.name = name
        self.bundleIdPrefix = bundleIdPrefix
    }
    
    public static func project(name: String, bundleIdPrefix: String) -> ProjectBuilder {
        ProjectBuilder(name: name, bundleIdPrefix: bundleIdPrefix)
    }
    
    public func addFeature(name featureName: String) -> ProjectBuilder {
        var builder = self
        builder.features.append(Feature(name: featureName))
        return builder
    }
    
    public func build() -> Project {
        // Main app
        var targets: [Target] = [
            .target(
                name: name,
                destinations: .iOS,
                product: .app,
                bundleId: "\(bundleIdPrefix).\(name)",
                infoPlist: .extendingDefault(
                    with: [
                        "UILaunchScreen": [
                            "UIColorName": "",
                            "UIImageName": "",
                        ],
                    ]
                ),
                buildableFolders: [
                    .init(stringLiteral: "\(name)/Sources"),
                    .init(stringLiteral: "\(name)/Resources")
                ],
                dependencies: features.map { .target(name: $0.frameworkTargetName) }
            ),
            .target(
                name: "\(name)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "\(bundleIdPrefix).\(name)Tests",
                infoPlist: .default,
                buildableFolders: [
                    .init(stringLiteral: "\(name)/Tests")
                ],
                dependencies: [
                    .target(name: name),
                    .external(name: "ViewInspector")
                ]
            )
        ]
        
        // Add all feature targets
        for feature in features {
            targets.append(contentsOf: feature.targets(bundleIdPrefix: bundleIdPrefix))
        }
        
        // Schemes (main app and all feature example apps)
        var schemes: [Scheme] = [
            .scheme(
                name: name,
                shared: true,
                buildAction: .buildAction(targets: [
                    .target(name)
                ]),
                testAction: .testPlans([
                    Path("\(name)/\(name).xctestplan")
                ])
            )
        ]
        for feature in features {
            schemes.append(
                .scheme(
                    name: feature.exampleAppTargetName,
                    shared: true,
                    buildAction: .buildAction(targets: [
                        .target(feature.exampleAppTargetName)
                    ]),
                    testAction: .testPlans([
                        Path("Features/\(feature.name)/\(feature.name).xctestplan")
                    ])
                )
            )
        }
        
        return Project(
            name: name,
            options: .options(automaticSchemesOptions: .disabled),
            targets: targets,
            schemes: schemes
        )
    }
}

private struct Feature {
    let name: String
    
    var frameworkTargetName: String { name }
    var testTargetName: String { "\(name)Tests" }
    var exampleAppTargetName: String { "\(name)Example" }
    
    func targets(bundleIdPrefix: String) -> [Target] {
        [
            // Framework
            .target(
                name: frameworkTargetName,
                destinations: .iOS,
                product: .framework,
                bundleId: "\(bundleIdPrefix).\(frameworkTargetName)",
                infoPlist: .default,
                sources: .sourceFilesList(globs: [
                    .glob("Features/\(name)/Interface/**"),
                    .glob("Features/\(name)/UI/**", excluding: ["Features/\(name)/UI/Tests/**"]),
                    .glob("Features/\(name)/Domain/**", excluding: ["Features/\(name)/Domain/Tests/**"]),
                ]),
                dependencies: []
            ),
            // Tests
            .target(
                name: testTargetName,
                destinations: .iOS,
                product: .unitTests,
                bundleId: "\(bundleIdPrefix).\(testTargetName)",
                infoPlist: .default,
                buildableFolders: [
                    .init(stringLiteral: "Features/\(name)/UI/Tests"),
                    .init(stringLiteral: "Features/\(name)/Domain/Tests")
                ],
                dependencies: [
                    .target(name: frameworkTargetName),
                    .external(name: "ViewInspector")
                ]
            ),
            // Example App
            .target(
                name: exampleAppTargetName,
                destinations: .iOS,
                product: .app,
                bundleId: "\(bundleIdPrefix).\(exampleAppTargetName)",
                infoPlist: .default,
                buildableFolders: [
                    .init(stringLiteral: "Features/\(name)/Example")
                ],
                dependencies: [.target(name: frameworkTargetName)]
            )
        ]
    }
}
