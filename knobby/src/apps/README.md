# Apps

Multi-app modules launched from the App Select shell.

| Module | Role |
|--------|------|
| `app_select` | Launcher after intro; also reachable from the life-counter Apps menu |
| `demo_app` | Minimal dial/touch demo for bring-up and future-app patterns |

Life-counter UI (1P / MP / tools / settings) stays in the parent `src/` tree — it is the **Knobby** app entry from the launcher (`back_to_main()`), not a separate folder yet.

Add new apps here as `*_app.c` / `*_app.h`, register them in `app_select.c`, and wire input in `knobby/knob.c` when needed.
