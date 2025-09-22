import ProjectDescription

let tuist = Tuist(
    project: .tuist(plugins: [
        .local(path: "../Tuist/Templates/Feature")
    ])
)
