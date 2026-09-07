import from ...models.Task { Task }
import from ...models.Project { get_tasks, create_task }
import from ...walkers { delete_task, approve_task }
import from .Item { Item as TaskItem }
import from ..ui.button { Button }
import from ..ui.input { Input }
import from ..ui.field { Field, FieldLabel }
import from ..ui.table { Table, TableHeader, TableBody, TableRow, TableHead }
import from ..ui.spinner { Spinner }

def:pub Panel(project_id: str) -> JsxElement {
    has tasks: list[Task] = [],
        new_title: str = "",
        show_form: bool = False,
        loaded: bool = False;

    async def refresh {
        tasks = await get_tasks(project_id);
        loaded = True;
    }

    async can with entry {
        await refresh();
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

    async def approve_task_item(id: str) {
        ok = await approve_task(project_id, id);
        if ok {
            await refresh();
        }
    }

    return
        <section className="flex flex-col gap-4">
            <div className="flex items-center justify-between">
                <div className="flex items-baseline gap-3">
                    <h2 className="text-lg font-semibold">Tasks</h2>
                    <span className="text-sm text-muted-foreground">{len(tasks)} total</span>
                </div>
                <Button
                    variant={"outline" if show_form else "default"}
                    onClick={lambda { show_form = not show_form; }}
                >
                    {"Cancel" if show_form else "+ New Task"}
                </Button>
            </div>

            {(
                <div className="rounded-lg border border-border bg-card p-4">
                    <div className="mb-3 text-sm font-medium">New Task</div>
                    <div className="flex flex-col gap-3 sm:flex-row">
                        <Field className="flex-1">
                            <FieldLabel htmlFor="new-task-title">Title</FieldLabel>
                            <Input
                                id="new-task-title"
                                value={new_title}
                                onChange={lambda (e: ChangeEvent) { new_title = e.target.value; }}
                                onKeyPress={lambda (e: KeyboardEvent) {
                                    if e.key == "Enter" { add_task(); }
                                }}
                                placeholder="Task title"
                            />
                        </Field>
                        <div className="flex items-end">
                            <Button onClick={add_task}>Create</Button>
                        </div>
                    </div>
                </div>
            ) if show_form else None}

            {(
                <div className="flex justify-center py-8"><Spinner /></div>
            ) if not loaded else None}

            {(
                <div className="rounded-lg border border-dashed border-border p-8 text-center">
                    <p className="text-base font-medium">No tasks yet</p>
                    <p className="mt-1 text-sm text-muted-foreground">
                        Create your first task to get started.
                    </p>
                    <Button className="mt-4" onClick={lambda { show_form = True; }}>
                        + New Task
                    </Button>
                </div>
            ) if loaded and len(tasks) == 0 and not show_form else None}

            {(
                <div className="rounded-lg border border-border bg-card">
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead className="w-48">Alias</TableHead>
                                <TableHead>Title</TableHead>
                                <TableHead className="w-56 text-right">Actions</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {[
                                <TaskItem key={jid(t)} task={t} onDelete={remove_task} onApprove={approve_task_item} /> for t in tasks
                            ]}
                        </TableBody>
                    </Table>
                </div>
            ) if loaded and len(tasks) > 0 else None}
        </section>;
}
