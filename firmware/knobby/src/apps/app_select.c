#include "app_select.h"
#include "demo_app.h"
#include "../settings.h"
#include "../ui_1p.h"

// ---------- screens ----------
lv_obj_t *screen_app_select = NULL;

// ---------- events ----------
static void event_launch_knobby(lv_event_t *e)
{
    (void)e;
    back_to_main();
}

static void event_launch_demo(lv_event_t *e)
{
    (void)e;
    open_demo_app();
}

void event_open_app_select(lv_event_t *e)
{
    (void)e;
    open_app_select();
}

// ---------- navigation ----------
void open_app_select(void)
{
    load_screen_if_needed(screen_app_select);
}

// ---------- build ----------
void build_app_select_screen(void)
{
    quad_item_t items[4] = {
        {"Knobby", event_launch_knobby, true, LV_EVENT_CLICKED},
        {"Demo",   event_launch_demo,   true, LV_EVENT_CLICKED},
        {"",       NULL,                false, LV_EVENT_CLICKED},
        {"",       NULL,                false, LV_EVENT_CLICKED},
    };
    build_quad_screen(&screen_app_select, items);
}
