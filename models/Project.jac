import from .Task { Task }

node Project {
    has name: str = "PROJECT_NAME",
        tldr: str = "What's the goal of this project.",
        is_draft: bool = False;

    def update_name(new_name: str) -> int {
        self.name = new_name;
        return 0;
    }

    def update_tldr(new_tldr: str) -> int {
        self.tldr = new_tldr;
        return 0;
    }

    def get_name() -> str {
        return self.name;
    }

    def get_tldr() -> str {
        return self.tldr;
    }

    def:pub create_sub_project(name: str, tldr: str) -> Project {
        project = self ++> Project(name=name, tldr=tldr);
        print(f"[Create] Sub project {name}, parent is {self.name}");
        return project[0];
    }

    def:pub create_task(title: str) -> Task {
        task = self ++> Task(title=title);
        try {
            task[0].update_alias(task[0].gen_alias(task[0].get_title()));
        } except Exception as e {
            print(f"[Warn] alias generation failed for task {jid(task[0])}: {str(e)}");
        }
        print(f"[Create] task {task[0].get_alias()}, parent is {self.name}");
        return task[0];
    }

    def draft_task(title: str) -> Task {
        task = self ++> Task(title=title, is_draft=True);
        try {
            task[0].update_alias(task[0].gen_alias(task[0].get_title()));
        } except Exception as e {
            print(f"[Warn] alias generation failed for draft task {jid(task[0])}: {str(e)}");
        }
        return task[0];
    }

    def draft_sub_project(name: str, tldr: str) -> Project {
        project = self ++> Project(name=name, tldr=tldr, is_draft=True);
        return project[0];
    }

    def:pub plan(prompt: str) -> str by llm(tools=[self.draft_task, self.draft_sub_project]);
}

sem Project.draft_task = "Create a single new draft task directly under this project.";
sem Project.draft_task.title = "A short, actionable task title.";

sem Project.draft_sub_project = "Create a new draft sub-project directly under this project, for when part of the request needs a further layer of breakdown rather than being a single flat task.";
sem Project.draft_sub_project.name = "A short name for the sub-project.";
sem Project.draft_sub_project.tldr = "One sentence describing the sub-project's goal.";

sem Project.plan = "Given a free-text request describing work to be done, decide what belongs directly under this project: create draft tasks for concrete single-step actions, or create draft sub-projects when part of the request needs further breakdown into multiple steps. Only plan ONE level deep - do not try to plan multiple layers in a single call.";
sem Project.plan.prompt = "The user's free-text description of what they want done.";

def:pub create_root_project(name: str, tldr: str) -> Project {
    project = root ++> Project(name=name, tldr=tldr);
    print(f"[Create] Root project {name}");
    return project[0];
}

def:pub get_projects -> list[Project] {
    return [root-->][?:Project];
}

def _find_project(id: str, candidates: list[Project]) -> Project | None {
    for p in candidates {
        if jid(p) == id {
            return p;
        }
        found = _find_project(id, [p-->][?:Project]);
        if found {
            return found;
        }
    }
    return None;
}

def:pub get_project(id: str) -> Project | None {
    return _find_project(id, [root-->][?:Project]);
}

def:pub get_parent(id: str) -> Project | None {
    p = get_project(id);
    if p is None {
        return None;
    }
    parents = [p <--][?:Project];
    return parents[0] if parents else None;
}

def:pub get_sub_projects(id: str) -> list[Project] {
    p = get_project(id);
    if p is None {
        return [];
    }
    return [p-->][?:Project];
}

def:pub create_sub_project(parent_id: str, name: str, tldr: str) -> Project | None {
    parent = get_project(parent_id);
    if parent is None {
        return None;
    }
    return parent.create_sub_project(name, tldr);
}

def:pub get_tasks(project_id: str) -> list[Task] {
    p = get_project(project_id);
    if p is None {
        return [];
    }
    return [p-->][?:Task];
}

def:pub create_task(project_id: str, title: str) -> Task | None {
    p = get_project(project_id);
    if p is None {
        return None;
    }
    return p.create_task(title);
}

def:pub plan_children(node_id: str, prompt: str) -> str {
    p = get_project(node_id);
    if p is None {
        return "Project not found.";
    }
    return p.plan(prompt);
}
