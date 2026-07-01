"""Main entry point for pm."""

import from models.Project { Project, create_root_project, get_projects, get_project }
import from walkers { Visitor, Cleaner, test_home }

cl import from components.HomePage { HomePage }

cl def:pub app -> JsxElement {
    return
        <HomePage/>;
}

with entry {
    print("entry");
}
