import from "@jac/runtime" { useNavigate }

import from ...models.Project { Project }
import from ..ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter }
import from ..ui.button { Button }
import from ..ui.badge { Badge }

def:pub Item(
    project: Project,
    onSelect: Callable[([str], None)] | None = None,
    onDelete: Callable[([str], None)] | None = None,
    onApprove: Callable[([str], None)] | None = None
) -> JsxElement {
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
        <Card
            className="cursor-pointer transition hover:border-primary/60 hover:shadow-md"
            onClick={go_to_project}
        >
            <CardHeader>
                <div className="flex items-start justify-between gap-2">
                    <CardTitle className="line-clamp-1">{project.name}</CardTitle>
                    {(<Badge variant="secondary">Draft</Badge>) if project.is_draft else None}
                </div>
                <CardDescription className="line-clamp-2">{project.tldr}</CardDescription>
            </CardHeader>
            <CardFooter className="justify-end gap-2">
                {(<Button size="sm" variant="secondary" onClick={handle_approve}>Approve</Button>)
                    if project.is_draft and onApprove
                    else None}
                {(<Button size="sm" variant="ghost" onClick={handle_delete}>
                    {"Discard" if project.is_draft else "Delete"}
                </Button>)
                    if onDelete
                    else None}
            </CardFooter>
        </Card>;
}
