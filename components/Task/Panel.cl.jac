import "../styles/Task.css";

sv import from ...models.Task { Task }
sv import from ...models.Project { get_tasks, create_task }
sv import from ...walkers { delete_task }
import from .Item { Item as TaskItem }

def:pub Panel(project_id: str) -> JsxElement {
    has tasks: list[Task] = [],
        new_title: str = "",
        show_form: bool = False;

    async can with entry {
        tasks = await get_tasks(project_id);
    }

    async def add_task {
        if new_title.strip() {
            t = await create_task(project_id, new_title.strip());
            if t {
                tasks = tasks + [t];
            }
            new_title = "";
            show_form = False;
        }
    }

    async def remove_task(id: str) {
        ok = await delete_task(project_id, id);
        if ok {
            tasks = [t for t in tasks if jid(t) != id];
        }
    }

    return
        <div class="panel-section">
            <div class="section-header">
                <div>
                    <span class="section-title">Tasks</span>
                    <span class="project-count">{len(tasks)} total</span>
                </div>
                <button
                    class={"btn-outline" if show_form else "btn-primary"}
                    onClick={lambda { show_form = not show_form; }}
                >
                    {"Cancel" if show_form else "+ New Task"}
                </button>
            </div>
            {(
                <div class="new-form-wrapper">
                    <div class="new-form-title">New Task</div>
                    <div class="new-form-row">
                        <input
                            class="input"
                            value={new_title}
                            onChange={lambda e: ChangeEvent { new_title = e.target.value; }}
                            onKeyPress={lambda e: KeyboardEvent {
                                if e.key == "Enter" { add_task(); }}
                            }
                            placeholder="Task title"
                        />
                        <button class="btn-primary" onClick={add_task}>Create</button>
                    </div>
                </div>
            ) if show_form else None}
            {(
                <div class="empty-state">
                    <div class="empty-icon">📋</div>
                    <h3>No tasks yet</h3>
                    <p>Create your first task to get started.</p>
                    <button class="btn-primary" onClick={lambda { show_form = True; }}>
                        + New Task
                    </button>
                </div>
            ) if len(tasks) == 0 and not show_form else None}
            {(
                <table class="task-table">
                    <tbody>
                        {[
                            <TaskItem key={jid(t)} task={t} onDelete={remove_task} /> for t in tasks
                        ]}
                    </tbody>
                </table>
            ) if len(tasks) > 0 else None}
        </div>;
}
