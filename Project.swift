import ProjectDescription
import ProjectDescriptionHelpers

let project = ProjectBuilder
    .project(
        name: "EZGames",
        bundleIdPrefix: "hu.galiasys"
    )
    .addFeature(name: "Game2048")
    .build()
