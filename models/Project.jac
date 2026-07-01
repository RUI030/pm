import from .Task { Task }

node Project {
    has name: str = "PROJECT_NAME",
        tldr: str = "What's the goal of this project.";

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
        task[0].update_alias(task[0].gen_alias(task[0].get_title()));
        print(f"[Create] task {task[0].get_alias()}, parent is {self.name}");
        return task[0];
    }
}

def:pub create_root_project(name: str, tldr: str) -> Project {
    project = root ++> Project(name=name, tldr=tldr);
    print(f"[Create] Root project {name}");
    return project[0];
}

def:pub get_projects -> list[Project] {
    return [root-->][?:Project];
}
