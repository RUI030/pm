"""Main entry point for pm."""

import "./styles/global.css";

import from models.Project {
    Project,
    create_root_project,
    create_sub_project,
    get_projects,
    get_project,
    get_parent,
    get_sub_projects,
    get_tasks,
    create_task,
    plan_children
}
import from walkers {
    Visitor,
    Cleaner,
    test_home,
    delete_project,
    delete_task,
    approve_project,
    approve_task
}

import from "@jac/runtime" { Router, Routes, Route, AuthGuard }
import from components.HomePage { HomePage }
import from components.LoginPage { LoginPage }
import from components.Project.Page { Page as ProjectPage }

def:pub app -> JsxElement {
    return
        <Router>
            <Routes>
                <Route path="/login" element={<LoginPage/>}/>
                <Route element={<AuthGuard redirect="/login"/>}>
                    <Route path="/" element={<HomePage/>}/>
                    <Route path="/project/:id" element={<ProjectPage/>}/>
                </Route>
            </Routes>
        </Router>;
}

with entry {
    print("entry");
}
