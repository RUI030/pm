import "./styles/main.css";

import from .Project.Panel { Panel as ProjectPanel }

def:pub HomePage -> JsxElement {
    return
        <div class="app">
            <header class="header">
                <div class="header-inner">
                    <div class="logo">PM<span>Space</span></div>
                </div>
            </header>
            <main class="page">
                <ProjectPanel />
            </main>
        </div>;
}
