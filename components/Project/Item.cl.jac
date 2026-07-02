import from "@jac/runtime" { useNavigate }

sv import from ...models.Project { Project }

def:pub Item(project: Project, onSelect: Callable[([str], None)] | None = None, onDelete: Callable[([str], None)] | None = None, onApprove: Callable[([str], None)] | None = None) -> JsxElement {
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

    def handle_approve(e: MouseEvent) {
        e.stopPropagation();
        if onApprove {
            onApprove(jid(project));
        }
    }

    return
        <div class={"project-card draft-card" if project.is_draft else "project-card"} onClick={go_to_project}>
            <div class="project-card-body">
                {(<span class="draft-badge">Draft</span>) if project.is_draft else None}
                <div class="project-name">{project.name}</div>
                <div class="project-tldr">{project.tldr}</div>
            </div>
            <div class="project-card-footer">
                {(<button class="btn-primary" onClick={handle_approve}>Approve</button>) if project.is_draft and onApprove else None}
                {(<button class="btn-ghost delete-link" onClick={handle_delete}>{"Discard" if project.is_draft else "Delete"}</button>) if onDelete else None}
                <span class="card-arrow">→</span>
            </div>
        </div>;
}
