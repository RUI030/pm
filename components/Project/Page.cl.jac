import "../styles/main.css";
import "../styles/Project.css";

import from "@jac/runtime" { useParams, useNavigate }

sv import from ...models.Project { Project, get_project, get_parent }
import from .Panel { Panel as ProjectPanel }

def:pub Page -> JsxElement {
    has project: Project | None = None;
    has parent_id: str | None = None;
    params = useParams();
    nav = useNavigate();

    async def load_project(id: str) {
        project = await get_project(id);
        parent = await get_parent(id);
        parent_id = jid(parent) if parent else None;
    }

    async can with entry {
        await load_project(str(params["id"]));
    }

    def go_home(e: MouseEvent) {
        nav("/");
    }

    async def go_back {
        if parent_id {
            await load_project(parent_id);
            nav("/project/" + parent_id);
        } else {
            nav("/");
        }
    }

    async def select_sub_project(id: str) {
        await load_project(id);
        nav("/project/" + id);
    }

    return
        <div class="app">
            <header class="header">
                <div class="header-inner">
                    <div class="logo" onClick={go_home}>PM<span>Space</span></div>
                </div>
            </header>
            <main class="page">
                {(
                    <div class="project-page-empty">Project not found.</div>
                ) if project is None else (
                    <div>
                        <div class="project-header">
                            <button class="btn-ghost back-link" onClick={go_back}>
                                {"← Back to parent" if parent_id else "← All projects"}
                            </button>
                            <h1 class="project-header-name">{project.name}</h1>
                            <p class="project-header-tldr">{project.tldr}</p>
                        </div>
                        <ProjectPanel parent_id={jid(project)} onSelectProject={select_sub_project} />
                    </div>
                )}
            </main>
        </div>;
}
