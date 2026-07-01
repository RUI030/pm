import from "@jac/runtime" { useNavigate }

sv import from ...models.Project { Project }

def:pub Item(project: Project) -> JsxElement {
    nav = useNavigate();

    def go_to_project(e: MouseEvent) {
        nav("/project/" + jid(project));
    }

    return
        <div class="project-card" onClick={go_to_project}>
            <div class="project-card-body">
                <div class="project-name">{project.name}</div>
                <div class="project-tldr">{project.tldr}</div>
            </div>
            <div class="project-card-footer">
                <span class="card-arrow">→</span>
            </div>
        </div>;
}
