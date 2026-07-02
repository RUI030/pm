import "../styles/main.css";
import "../styles/Project.css";

import from "@jac/runtime" { useParams, useNavigate }

sv import from ...models.Project { Project, get_project }

def:pub Page -> JsxElement {
    has project: Project | None = None;
    params = useParams();
    nav = useNavigate();

    async can with entry {
        project = await get_project(str(params["id"]));
    }

    def go_home(e: MouseEvent) {
        nav("/");
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
                    <div class="project-header">
                        <button class="btn-ghost back-link" onClick={go_home}>← All projects</button>
                        <h1 class="project-header-name">{project.name}</h1>
                        <p class="project-header-tldr">{project.tldr}</p>
                    </div>
                )}
            </main>
        </div>;
}
