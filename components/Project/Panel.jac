import from ...models.Project { Project, create_root_project, create_sub_project, get_projects, get_sub_projects }
import from ...walkers { delete_project, approve_project }
import from .Item { Item as ProjectItem }
import from ..ui.button { Button }
import from ..ui.input { Input }
import from ..ui.field { Field, FieldLabel }
import from ..ui.spinner { Spinner }

def:pub Panel(parent_id: str | None = None, onSelectProject: Callable[([str], None)] | None = None) -> JsxElement {
    has projects: list[Project] = [],
        new_name: str = "",
        new_tldr: str = "",
        show_form: bool = False,
        loaded: bool = False;

    async def refresh {
        if parent_id {
            projects = await get_sub_projects(parent_id);
        } else {
            projects = await get_projects();
        }
        loaded = True;
    }

    async can with entry {
        await refresh();
    }

    async def add_project {
        if new_name.strip() {
            p: Project | None = None;
            if parent_id {
                p = await create_sub_project(parent_id, new_name.strip(), new_tldr.strip());
            } else {
                p = await create_root_project(new_name.strip(), new_tldr.strip());
            }
            if p {
                projects = projects + [p];
            }
            new_name = "";
            new_tldr = "";
            show_form = False;
        }
    }

    async def remove_project(id: str) {
        ok = await delete_project(id);
        if ok {
            projects = [p for p in projects if jid(p) != id];
        }
    }

    async def approve_project_item(id: str) {
        ok = await approve_project(id);
        if ok {
            await refresh();
        }
    }

    return
        <section className="flex flex-col gap-4">
            <div className="flex items-center justify-between">
                <div className="flex items-baseline gap-3">
                    <h2 className="text-lg font-semibold">
                        {"Sub-projects" if parent_id else "Projects"}
                    </h2>
                    <span className="text-sm text-muted-foreground">{len(projects)} total</span>
                </div>
                <Button
                    variant={"outline" if show_form else "default"}
                    onClick={lambda { show_form = not show_form; }}
                >
                    {"Cancel" if show_form else "+ New Project"}
                </Button>
            </div>

            {(
                <div className="rounded-lg border border-border bg-card p-4">
                    <div className="mb-3 text-sm font-medium">New Project</div>
                    <div className="flex flex-col gap-3 sm:flex-row">
                        <Field className="flex-1">
                            <FieldLabel htmlFor="new-name">Name</FieldLabel>
                            <Input
                                id="new-name"
                                value={new_name}
                                onChange={lambda (e: ChangeEvent) { new_name = e.target.value; }}
                                onKeyPress={lambda (e: KeyboardEvent) {
                                    if e.key == "Enter" { add_project(); }
                                }}
                                placeholder="Project name"
                            />
                        </Field>
                        <Field className="flex-1">
                            <FieldLabel htmlFor="new-tldr">Goal (optional)</FieldLabel>
                            <Input
                                id="new-tldr"
                                value={new_tldr}
                                onChange={lambda (e: ChangeEvent) { new_tldr = e.target.value; }}
                                onKeyPress={lambda (e: KeyboardEvent) {
                                    if e.key == "Enter" { add_project(); }
                                }}
                                placeholder="What's the goal?"
                            />
                        </Field>
                        <div className="flex items-end">
                            <Button onClick={add_project}>Create</Button>
                        </div>
                    </div>
                </div>
            ) if show_form else None}

            {(
                <div className="flex justify-center py-8"><Spinner /></div>
            ) if not loaded else None}

            {(
                <div className="rounded-lg border border-dashed border-border p-8 text-center">
                    <p className="text-base font-medium">
                        {"No sub-projects yet" if parent_id else "No projects yet"}
                    </p>
                    <p className="mt-1 text-sm text-muted-foreground">
                        Create your first project to get started.
                    </p>
                    <Button className="mt-4" onClick={lambda { show_form = True; }}>
                        + New Project
                    </Button>
                </div>
            ) if loaded and len(projects) == 0 and not show_form else None}

            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {[
                    <ProjectItem key={jid(p)} project={p} onSelect={onSelectProject} onDelete={remove_project} onApprove={approve_project_item} /> for p in projects
                ]}
            </div>
        </section>;
}
