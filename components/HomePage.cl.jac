import "./styles/main.css";
import "./styles/HomePage.css";

sv import from ..models.Project { Project, create_root_project, get_projects }

def:pub HomePage -> JsxElement {
    has projects: list[Project] = [],
        new_name: str = "",
        new_tldr: str = "",
        show_form: bool = False;

    async can with entry {
        projects = await get_projects();
    }

    async def add_project {
        if new_name.strip() {
            p = await create_root_project(new_name.strip(), new_tldr.strip());
            projects = projects + [p];
            new_name = "";
            new_tldr = "";
            show_form = False;
        }
    }

    return
        <div class="app">
            <header class="header">
                <div class="header-inner">
                    <div class="logo">PM<span>Space</span></div>
                </div>
            </header>
            <main class="page">
                <div class="section-header">
                    <div>
                        <span class="section-title">Projects</span>
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
                        <h3>No projects yet</h3>
                        <p>Create your first project to get started.</p>
                        <button class="btn-primary" onClick={lambda { show_form = True; }}>
                            + New Project
                        </button>
                    </div>
                ) if len(projects) == 0 and not show_form else None}
                <div class="project-grid">
                    {[
                        <div key={jid(p)} class="project-card">
                            <div class="project-card-body">
                                <div class="project-name">{p.name}</div>
                                <div class="project-tldr">{p.tldr}</div>
                            </div>
                            <div class="project-card-footer">
                                <span class="card-arrow">→</span>
                            </div>
                        </div> for p in projects
                    ]}
                </div>
            </main>
        </div>;
}