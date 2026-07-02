import "../styles/Project.css";

sv import from ...models.Project { Project, create_root_project, create_sub_project, get_projects, get_sub_projects }
import from .Item { Item as ProjectItem }

def:pub Panel(parent_id: str | None = None, onSelectProject: Callable[([str], None)] | None = None) -> JsxElement {
    has projects: list[Project] = [],
        new_name: str = "",
        new_tldr: str = "",
        show_form: bool = False;

    async can with entry {
        if parent_id {
            projects = await get_sub_projects(parent_id);
        } else {
            projects = await get_projects();
        }
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

    return
        <div>
            <div class="section-header">
                <div>
                    <span class="section-title">{"Sub-projects" if parent_id else "Projects"}</span>
                    <span class="project-count">{len(projects)} total</span>
                </div>
                <button
                    class={"btn-outline" if show_form else "btn-primary"}
                    onClick={lambda { show_form = not show_form; }}
                >
                    {"Cancel" if show_form else "+ New Project"}
                </button>
            </div>
            {(
                <div class="new-form-wrapper">
                    <div class="new-form-title">New Project</div>
                    <div class="new-form-row">
                        <input
                            class="input"
                            value={new_name}
                            onChange={lambda e: ChangeEvent { new_name = e.target.value; }}
                            onKeyPress={lambda e: KeyboardEvent {
                                if e.key == "Enter" { add_project(); }}
                            }
                            placeholder="Project name"
                        />
                        <input
                            class="input"
                            value={new_tldr}
                            onChange={lambda e: ChangeEvent { new_tldr = e.target.value; }}
                            onKeyPress={lambda e: KeyboardEvent {
                                if e.key == "Enter" { add_project(); }}
                            }
                            placeholder="What's the goal? (optional)"
                        />
                        <button class="btn-primary" onClick={add_project}>Create</button>
                    </div>
                </div>
            ) if show_form else None}
            {(
                <div class="empty-state">
                    <div class="empty-icon">📋</div>
                    <h3>{"No sub-projects yet" if parent_id else "No projects yet"}</h3>
                    <p>Create your first project to get started.</p>
                    <button class="btn-primary" onClick={lambda { show_form = True; }}>
                        + New Project
                    </button>
                </div>
            ) if len(projects) == 0 and not show_form else None}
            <div class="project-grid">
                {[
                    <ProjectItem key={jid(p)} project={p} onSelect={onSelectProject} /> for p in projects
                ]}
            </div>
        </div>;
}
