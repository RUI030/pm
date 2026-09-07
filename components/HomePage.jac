import from "@jac/runtime" { jacLogout, useNavigate }

import from .ui.button { Button }
import from .Project.Panel { Panel as ProjectPanel }

def:pub HomePage -> JsxElement {
    nav = useNavigate();

    def handle_logout(e: MouseEvent) {
        jacLogout();
        nav("/login");
    }

    return
        <div className="min-h-svh bg-background">
            <header className="border-b border-border bg-card">
                <div className="mx-auto flex max-w-5xl items-center justify-between px-6 py-4">
                    <div className="text-xl font-semibold tracking-tight">
                        PM<span className="text-primary">Space</span>
                    </div>
                    <Button variant="ghost" onClick={handle_logout}>Log out</Button>
                </div>
            </header>
            <main className="mx-auto max-w-5xl px-6 py-8">
                <ProjectPanel />
            </main>
        </div>;
}
