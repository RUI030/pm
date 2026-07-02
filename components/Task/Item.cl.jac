sv import from ...models.Task { Task }

def:pub Item(task: Task, onDelete: Callable[([str], None)] | None = None, onApprove: Callable[([str], None)] | None = None) -> JsxElement {
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
        <tr class={"task-row draft-row" if task.is_draft else "task-row"}>
            <td class="task-alias">
                {(<span class="draft-badge">Draft</span>) if task.is_draft else None}
                {task.alias}
            </td>
            <td class="task-title">{task.title}</td>
            <td class="task-actions">
                {(<button class="btn-primary" onClick={handle_approve}>Approve</button>) if task.is_draft and onApprove else None}
                {(<button class="btn-ghost delete-link" onClick={handle_delete}>{"Discard" if task.is_draft else "Delete"}</button>) if onDelete else None}
            </td>
        </tr>;
}
