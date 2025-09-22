import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")
let platformAttribute: Template.Attribute = .optional("platform", default: "iOS")

let template = Template(
    description: "A feature module",
    attributes: [
        nameAttribute,
        platformAttribute,
    ],
    items: [
        // Interface
        .file(
            path: "Features/{{ name }}/Interface/{{ name }}Interface.swift",
            templatePath: "Interface/interface.stencil"
        ),
        
        // UI
        .file(
            path: "Features/{{ name }}/UI/{{ name }}View.swift",
            templatePath: "UI/main-view.stencil"
        ),
        // UI/Tests
        .file(
            path: "Features/{{ name }}/UI/Tests/{{ name }}Tests.swift",
            templatePath: "UI/Tests/tests.stencil"
        ),
        
        // Domain
        .string(
            path: "Features/{{ name }}/Domain/{{ name }}.swift",
            contents: "// Placeholder"
        ),
        // Domain/Tests
        .file(
            path: "Features/{{ name }}/Domain/Tests/{{ name }}Tests.swift",
            templatePath: "Domain/Tests/tests.stencil"
        ),
        
        // Example App
        .file(
            path: "Features/{{ name }}/Example/{{ name }}ExampleApp.swift",
            templatePath: "Example/example.stencil"
        ),
    ]
)
