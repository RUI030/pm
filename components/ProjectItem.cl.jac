sv import from ..models.Project { Project }

def:pub ProjectItem(
    project: Project
) -> JsxElement {
    return
        <div class="project-item">
            <h2>
                {project.name}
            </h2>
            <p>
                {project.tldr}
            </p>
        </div>;
}