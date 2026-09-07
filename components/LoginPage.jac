import "./styles/main.css";

import from "@jac/runtime" { jacLogin, jacSignup, jacIsLoggedIn, useNavigate, Navigate }

def:pub LoginPage -> JsxElement {
    has email: str = "";
    has password: str = "";
    has mode: str = "login";
    has status: str = "";
    has busy: bool = False;
    nav = useNavigate();

    if jacIsLoggedIn() {
        return <Navigate to="/" replace={True} />;
    }

    async def submit {
        if busy { return; }
        if not email.strip() or not password {
            status = "Enter email and password.";
            return;
        }
        busy = True;
        status = "";
        try {
            if mode == "signup" {
                signup_result: dict | None = None;
                signup_result = await jacSignup(email.strip(), password);
                if not signup_result["success"] {
                    status = "Signup failed (email may be in use).";
                    busy = False;
                    return;
                }
            }
            login_ok: bool = False;
            login_ok = await jacLogin(email.strip(), password);
            if not login_ok {
                status = "Invalid credentials.";
                busy = False;
                return;
            }
            nav("/");
        } except Exception as e {
            status = "Error: " + str(e);
        }
        busy = False;
    }

    return
        <div class="app">
            <header class="header">
                <div class="header-inner">
                    <div class="logo">PM<span>Space</span></div>
                </div>
            </header>
            <main class="page">
                <div class="panel-section new-form-wrapper">
                    <div class="new-form-title">{"Create account" if mode == "signup" else "Log in"}</div>
                    <div class="new-form-row">
                        <input
                            class="input"
                            value={email}
                            onChange={lambda (e: ChangeEvent) { email = e.target.value; }}
                            placeholder="Email"
                        />
                        <input
                            class="input"
                            type="password"
                            value={password}
                            onChange={lambda (e: ChangeEvent) { password = e.target.value; }}
                            onKeyPress={lambda (e: KeyboardEvent) {
                                if e.key == "Enter" { submit(); }
                            }}
                            placeholder="Password"
                        />
                        <button class="btn-primary" onClick={submit}>
                            {"Working..." if busy else ("Sign up" if mode == "signup" else "Log in")}
                        </button>
                    </div>
                    {(<div class="project-page-empty">{status}</div>) if status else None}
                    <div class="new-form-row">
                        <button
                            class="btn-ghost"
                            onClick={lambda { mode = "login" if mode == "signup" else "signup"; status = ""; }}
                        >
                            {"Have an account? Log in" if mode == "signup" else "Need an account? Sign up"}
                        </button>
                    </div>
                </div>
            </main>
        </div>;
}
