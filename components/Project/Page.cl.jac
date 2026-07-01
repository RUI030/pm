import from "@jac/runtime" { useParams }

sv import from ...models.Project { Project, get_project }

def:pub Page -> JsxElement {
    has project: Project | None = None;
    params = useParams();

    async can with entry {
        project = await get_project(str(params["id"]));
    }

    if project is None {
        return <div>Project not found.</div>;
    }

    return
        <div class="project-page">
            <h1 class="project-page-name">{project.name}</h1>
            <p class="project-page-tldr">{project.tldr}</p>
        </div>;
}
