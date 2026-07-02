import from models.Project { Project, create_root_project, get_project }
import from models.Task { Task }

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

def:pub delete_project(id: str) -> bool {
    p = get_project(id);
    if p is None {
        return False;
    }
    p spawn Cleaner();
    return True;
}

def:pub delete_task(project_id: str, task_id: str) -> bool {
    p = get_project(project_id);
    if p is None {
        return False;
    }
    for t in [p-->][?:Task] {
        if jid(t) == task_id {
            t spawn Cleaner();
            return True;
        }
    }
    return False;
}

def:pub test_home() -> int {
    root spawn Cleaner();
    this_project = create_root_project("aaa", "aaaa");
    this_task = this_project.create_task("go to the convenient store grab some drinks on the list and then check out.");
    this_task.create_task("grab 2 bottles of milo black tea");
    this_task.create_task("grab 2 bottles of starbucks coffee");
    this_project = create_root_project("bbb", "bbbb");
    this_task = this_project.create_task("review classmate's circuit design project");
    this_project.create_sub_project("ccc", "cccc");
    this_task = this_project.create_task("put oil in the pot turn on the heat and crack egg then heat until fully cooked");
    return 0;
}
