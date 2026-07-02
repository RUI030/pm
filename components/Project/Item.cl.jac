import from "@jac/runtime" { useNavigate }

sv import from ...models.Project { Project }

def:pub Item(project: Project, onSelect: Callable[([str], None)] | None = None, onDelete: Callable[([str], None)] | None = None) -> JsxElement {
    nav = useNavigate();

    def go_to_project(e: MouseEvent) {
        if onSelect {
            onSelect(jid(project));
        } else {
            nav("/project/" + jid(project));
        }
    }

    def handle_delete(e: MouseEvent) {
        e.stopPropagation();
        if onDelete {
            onDelete(jid(project));
        }
    }

    return
        <div class="project-card" onClick={go_to_project}>
            <div class="project-card-body">
                <div class="project-name">{project.name}</div>
                <div class="project-tldr">{project.tldr}</div>
            </div>
            <div class="project-card-footer">
                {(<button class="btn-ghost delete-link" onClick={handle_delete}>Delete</button>) if onDelete else None}
                <span class="card-arrow">→</span>
            </div>
        </div>;
}
