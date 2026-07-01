"""Main entry point for pm."""

cl import "./style.css";

node Project {
    has name: str = "PROJECT_NAME",
        tldr: str = "What's the goal of this project.";

    def update_name(new_name:str) -> int {
        self.name = new_name;
        return 0;
    }

    def update_tldr(new_tldr:str) -> int {
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

node Task {
    has title: str = "Fix the frontend broken form input and submission.",
        alias: str = "Verb-Noun",
        notes: str = "";

    def get_title() -> str {
        return self.title;
    }

    def get_alias() -> str {
        return self.alias;
    }

    def gen_alias(title: str) -> str by llm();

    def update_alias(alias: str) -> int {
        self.alias=alias;
        print(f"[Update] new alias ({alias}) for task {self.title}");
        return 0;
    }

    def:pub create_task(title: str) -> Task {
        task = self ++> Task(title=title);
        task[0].update_alias(task[0].gen_alias(task[0].get_title()));
        print(f"[Create] task {task[0].alias}, parents is {self.title}");
        return task[0];
    }
}
sem Task.title = "Describe the task in 1 sentence.";
sem Task.alias = "An easy to read, verb-noun structured 2-word high level abstraction of the Task generate fron the task title. All lower case and seperate 2 word by space";

walker Visitor {
    can start with Root entry {
        print("Root");
        visit [-->];
    }
    can check_project with Project entry {
        print(f">> Visit >> (Project) {here.get_name()}");
        visit [-->];
    }
    can check_task with Task entry {
        print(f">> Visit >> (Task) {here.get_alias()}");
        visit [-->];
    }
}

walker Cleaner {
    can with Root entry {
        visit [-->];
    }
    can del_project with Project entry {
        visit [-->];
        print(f"[Delete] (Project) {here.get_name()}");
        del here;
    }
    can del_task with Task entry {
        visit [-->];
        print(f"[Delete] (Task) {here.get_alias()}");
        del here;
    }
}

def:pub test_home() -> int {
    root spawn Cleaner();
    this_project = create_root_project("aaa","aaaa");
    this_task = this_project.create_task("go to the convenient store grab some drinks on the list and then check out.");
    this_task.create_task("grab 2 bottles of milo black tea");
    this_task.create_task("grab 2 bottles of starbucks coffee");
    this_project = create_root_project("bbb","bbbb");
    this_task = this_project.create_task("review classmate's circuit design project");
    this_project.create_sub_project("ccc","cccc");
    this_task = this_project.create_task("put oil in the pot turn on the heat and crack egg then heat until fully cooked");
    return 0;
}

cl def:pub app -> JsxElement {
    has projects: list[Project] = [],
        new_name: str = "",
        new_tldr: str = "",
        show_form: bool = False;

    async can with entry {
        projects = await get_projects();
    }

    async def add_project {
        if new_name.strip() {
            p = await create_root_project(new_name.strip(), new_tldr.strip());
            projects = projects + [p];
            new_name = "";
            new_tldr = "";
            show_form = False;
        }
    }

    return
        <div class="app">
            <header class="header">
                <div class="header-inner">
                    <div class="logo">PM<span>Space</span></div>
                    <button
                        class={"btn-outline" if show_form else "btn-primary"}
                        onClick={lambda { show_form = not show_form; }}
                    >
                        {"Cancel" if show_form else "+ New Project"}
                    </button>
                </div>
            </header>
            <main class="main">
                {(
                    <div class="new-form-wrapper">
                        <div class="new-form-title">New Project</div>
                        <div class="new-form-row">
                            <input
                                class="input"
                                value={new_name}
                                onChange={lambda e: ChangeEvent { new_name = e.target.value; }}
                                onKeyPress={lambda e: KeyboardEvent {
                                    if e.key == "Enter" { add_project(); }
                                }}
                                placeholder="Project name"
                            />
                            <input
                                class="input"
                                value={new_tldr}
                                onChange={lambda e: ChangeEvent { new_tldr = e.target.value; }}
                                onKeyPress={lambda e: KeyboardEvent {
                                    if e.key == "Enter" { add_project(); }
                                }}
                                placeholder="What's the goal? (optional)"
                            />
                            <button class="btn-primary" onClick={add_project}>Create</button>
                        </div>
                    </div>
                ) if show_form else None}
                <div class="section-header">
                    <div>
                        <span class="section-title">Projects</span>
                        <span class="project-count">{len(projects)} total</span>
                    </div>
                </div>
                {(
                    <div class="empty-state">
                        <div class="empty-icon">📋</div>
                        <h3>No projects yet</h3>
                        <p>Create your first project to get started.</p>
                        <button class="btn-primary" onClick={lambda { show_form = True; }}>
                            + New Project
                        </button>
                    </div>
                ) if len(projects) == 0 and not show_form else None}
                <div class="project-grid">
                    {[
                        <div key={jid(p)} class="project-card">
                            <div class="project-card-body">
                                <div class="project-name">{p.name}</div>
                                <div class="project-tldr">{p.tldr}</div>
                            </div>
                            <div class="project-card-footer">
                                <span class="card-arrow">→</span>
                            </div>
                        </div> for p in projects
                    ]}
                </div>
            </main>
        </div>;
}


with entry {
    # root spawn Cleaner();
    # this_project = create_root_project("aaa","aaaa");
    # this_task = this_project.create_task("go to the convenient store grab some drinks on the list and then check out.");
    # this_task.create_task("grab 2 bottles of milo black tea");
    # this_task.create_task("grab 2 bottles of starbucks coffee");
    # this_project = create_root_project("bbb","bbbb");
    # this_task = this_project.create_task("review classmate's circuit design project");
    # this_project.create_sub_project("ccc","cccc");
    # this_task = this_project.create_task("put oil in the pot turn on the heat and crack egg then heat until fully cooked");
    # root spawn Visitor();
    print("entry");
}