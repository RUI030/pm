sv import from ...models.Task { Task }

def:pub Item(task: Task, onDelete: Callable[([str], None)] | None = None) -> JsxElement {
    def handle_delete(e: MouseEvent) {
        if onDelete {
            onDelete(jid(task));
        }
    }

    return
        <tr class="task-row">
            <td class="task-alias">{task.alias}</td>
            <td class="task-title">{task.title}</td>
            <td class="task-actions">
                {(<button class="btn-ghost delete-link" onClick={handle_delete}>Delete</button>) if onDelete else None}
            </td>
        </tr>;
}
