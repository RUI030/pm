sv import from ..main { Project, get_projects }

import from .ProjectItem { ProjectItem }

def:pub HomePage -> JsxElement {
    has projects: list[Project] = [];

    async can with entry {
        projects = await get_projects();
    }

    return
        <div>
            <h1>This is Homepage</h1>
            <div>
                {[
                    <ProjectItem
                        key={jid(p)}
                        project={p}
                    /> for p in projects
                ]}
            </div>
        </div>
    ;
}