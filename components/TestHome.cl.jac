import from "@jac/runtime" { Navigate }
sv import from ..models.Project { get_projects }

def:pub TestHome -> JsxElement {
    has first_id: str | None = None;

    async can with entry {
        ps = await get_projects();
        if ps {
            first_id = jid(ps[0]);
        }
    }

    if first_id is None {
        return <div>No projects yet.</div>;
    }
    return <Navigate to={"/project/" + first_id} replace={True} />;
}
