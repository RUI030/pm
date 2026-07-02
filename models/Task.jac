node Task {
    has title: str = "Fix the frontend broken form input and submission.",
        alias: str = "Verb-Noun",
        notes: str = "",
        is_draft: bool = False;

    def get_title() -> str {
        return self.title;
    }

    def get_alias() -> str {
        return self.alias;
    }

    def gen_alias(title: str) -> str by llm();

    def update_alias(alias: str) -> int {
        self.alias = alias;
        print(f"[Update] new alias ({alias}) for task {self.title}");
        return 0;
    }

    def:pub create_task(title: str) -> Task {
        task = self ++> Task(title=title);
        try {
            task[0].update_alias(task[0].gen_alias(task[0].get_title()));
        } except Exception as e {
            print(f"[Warn] alias generation failed for task {jid(task[0])}: {str(e)}");
        }
        print(f"[Create] task {task[0].alias}, parent is {self.title}");
        return task[0];
    }
}

sem Task.title = "Describe the task in 1 sentence.";
sem Task.alias = "An easy to read, verb-noun structured 2-word high level abstraction of the Task generate fron the task title. All lower case and seperate 2 word by space";
sem Task.gen_alias = "Generate a short, scannable alias for a task, capturing its single most important goal or action - not just whatever word appears first in the title. Respond with ONLY the final alias, no explanation or reasoning.";
sem Task.gen_alias.title = "The task's full title text to summarize into a short alias.";
