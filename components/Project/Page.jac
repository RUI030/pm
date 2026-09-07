import from "@jac/runtime" { useParams, useNavigate }

import from ...models.Project { Project, get_project, get_parent, plan_children }
import from .Panel { Panel as ProjectPanel }
import from ..Task.Panel { Panel as TaskPanel }
import from ..ui.button { Button }
import from ..ui.input { Input }
import from ..ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }

def:pub Page -> JsxElement {
    has project: Project | None = None;
    has parent_id: str | None = None;
    has plan_request: str = "";
    has planning: bool = False;
    has plan_version: int = 0;
    params = useParams();
    nav = useNavigate();

    async def load_project(id: str) {
        project = await get_project(id);
        parent = await get_parent(id);
        parent_id = jid(parent) if parent else None;
    }

    async can with entry {
        await load_project(str(params["id"]));
    }

    def go_home(e: MouseEvent) {
        nav("/");
    }

    async def go_back {
        if parent_id {
            await load_project(parent_id);
            nav("/project/" + parent_id);
        } else {
            nav("/");
        }
    }

    async def select_sub_project(id: str) {
        await load_project(id);
        nav("/project/" + id);
    }

    async def run_plan {
        if project is not None and plan_request.strip() {
            planning = True;
            await plan_children(jid(project), plan_request.strip());
            plan_request = "";
            planning = False;
            plan_version = plan_version + 1;
        }
    }

    return
        <div className="min-h-svh bg-background">
            <header className="border-b border-border bg-card">
                <div className="mx-auto flex max-w-5xl items-center justify-between px-6 py-4">
                    <div className="cursor-pointer text-xl font-semibold tracking-tight" onClick={go_home}>
                        PM<span className="text-primary">Space</span>
                    </div>
                </div>
            </header>
            <main className="mx-auto flex max-w-5xl flex-col gap-8 px-6 py-8">
                {(
                    <p className="text-muted-foreground">Project not found.</p>
                ) if project is None else (
                    <>
                        <div className="flex flex-col gap-3">
                            <Button variant="ghost" size="sm" className="self-start" onClick={go_back}>
                                {"← Back to parent" if parent_id else "← All projects"}
                            </Button>
                            <h1 className="text-3xl font-semibold tracking-tight">{project.name}</h1>
                            <p className="text-muted-foreground">{project.tldr}</p>
                        </div>

                        <Card>
                            <CardHeader>
                                <CardTitle>Plan with AI</CardTitle>
                                <CardDescription>Describe the work and let the planner draft tasks and sub-projects.</CardDescription>
                            </CardHeader>
                            <CardContent>
                                <div className="flex flex-col gap-3 sm:flex-row">
                                    <Input
                                        className="flex-1"
                                        value={plan_request}
                                        onChange={lambda (e: ChangeEvent) { plan_request = e.target.value; }}
                                        onKeyPress={lambda (e: KeyboardEvent) {
                                            if e.key == "Enter" { run_plan(); }
                                        }}
                                        placeholder="What needs to get done?"
                                    />
                                    <Button onClick={run_plan} disabled={planning}>
                                        {"Planning..." if planning else "Plan"}
                                    </Button>
                                </div>
                            </CardContent>
                        </Card>

                        <TaskPanel key={"task-" + jid(project) + "-" + str(plan_version)} project_id={jid(project)} />
                        <ProjectPanel key={"project-" + jid(project) + "-" + str(plan_version)} parent_id={jid(project)} onSelectProject={select_sub_project} />
                    </>
                )}
            </main>
        </div>;
}
