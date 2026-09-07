import from ...models.Task { Task }
import from ..ui.table { TableRow, TableCell }
import from ..ui.button { Button }
import from ..ui.badge { Badge }

def:pub Item(
    task: Task,
    onDelete: Callable[([str], None)] | None = None,
    onApprove: Callable[([str], None)] | None = None
) -> JsxElement {
    def handle_delete(e: MouseEvent) {
        if onDelete {
            onDelete(jid(task));
        }
    }

    def handle_approve(e: MouseEvent) {
        if onApprove {
            onApprove(jid(task));
        }
    }

    return
        <TableRow>
            <TableCell className="font-medium">
                <div className="flex items-center gap-2">
                    {(<Badge variant="secondary">Draft</Badge>) if task.is_draft else None}
                    <span>{task.alias}</span>
                </div>
            </TableCell>
            <TableCell className="text-muted-foreground">{task.title}</TableCell>
            <TableCell className="text-right">
                <div className="flex justify-end gap-2">
                    {(<Button size="sm" variant="secondary" onClick={handle_approve}>Approve</Button>)
                        if task.is_draft and onApprove
                        else None}
                    {(<Button size="sm" variant="ghost" onClick={handle_delete}>
                        {"Discard" if task.is_draft else "Delete"}
                    </Button>)
                        if onDelete
                        else None}
                </div>
            </TableCell>
        </TableRow>;
}
