"""Main entry point for pm."""

to cl:

import from components.HomePage { HomePage }

def:pub app -> JsxElement {

    return
        <HomePage/>;
        # <h1>Test</h1>;
}

to sv:
import from walkers { Cleaner, Visitor, test_home }

with entry {
    print("entry");
}
