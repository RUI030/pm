"""Main entry point for pm."""

import from models.Project { Project, create_root_project, get_projects, get_project }
import from walkers { Visitor, Cleaner, test_home }

cl import from "@jac/runtime" { Router, Routes, Route }
cl import from components.HomePage { HomePage }
cl import from components.Project.Page { Page as ProjectPage }

cl def:pub app -> JsxElement {
    return
        <Router>
            <Routes>
                <Route path="/" element={<HomePage />} />
                <Route path="/project/:id" element={<ProjectPage />} />
            </Routes>
        </Router>;
}

with entry {
    print("entry");
}
