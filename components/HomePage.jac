import "./styles/main.css";

import from "@jac/runtime" { jacLogout, useNavigate }
import from .Project.Panel { Panel as ProjectPanel }

def:pub HomePage -> JsxElement {
    nav = useNavigate();

    def handle_logout(e: MouseEvent) {
        jacLogout();
        nav("/login");
    }

    return
        <div class="app">
            <header class="header">
                <div class="header-inner">
                    <div class="logo">PM<span>Space</span></div>
                    <button class="btn-ghost" onClick={handle_logout}>Log out</button>
                </div>
            </header>
            <main class="page">
                <ProjectPanel />
            </main>
        </div>;
}
