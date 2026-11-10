#include "demo_app.h"
#include "app_select.h"

// ---------- state ----------
lv_obj_t *screen_demo_app = NULL;
static lv_obj_t *label_demo_value = NULL;
static lv_obj_t *label_demo_tap = NULL;
static int demo_value = 0;
static int demo_taps = 0;

// ---------- refresh ----------
void refresh_demo_app_ui(void)
{
    char buf[32];

    if (label_demo_value != NULL) {
        snprintf(buf, sizeof(buf), "%d", demo_value);
        lv_label_set_text(label_demo_value, buf);
    }

    if (label_demo_tap != NULL) {
        snprintf(buf, sizeof(buf), "Taps: %d", demo_taps);
        lv_label_set_text(label_demo_tap, buf);
    }
}

// ---------- input ----------
void change_demo_value(int delta)
{
    demo_value += delta;
    refresh_demo_app_ui();
}

// ---------- events ----------
static void event_demo_tap(lv_event_t *e)
{
    (void)e;
    demo_taps++;
    refresh_demo_app_ui();
}

static void event_demo_apps(lv_event_t *e)
{
    (void)e;
    open_app_select();
}

void event_open_demo_app(lv_event_t *e)
{
    (void)e;
    open_demo_app();
}

// ---------- navigation ----------
void open_demo_app(void)
{
    refresh_demo_app_ui();
    load_screen_if_needed(screen_demo_app);
}

// ---------- build ----------
void build_demo_app_screen(void)
{
    lv_obj_t *title;
    lv_obj_t *hint;
    lv_obj_t *btn;

    screen_demo_app = lv_obj_create(NULL);
    lv_obj_set_size(screen_demo_app, 360, 360);
    lv_obj_set_style_bg_color(screen_demo_app, lv_color_black(), 0);
    lv_obj_set_style_border_width(screen_demo_app, 0, 0);
    lv_obj_set_scrollbar_mode(screen_demo_app, LV_SCROLLBAR_MODE_OFF);
    lv_obj_add_flag(screen_demo_app, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_add_event_cb(screen_demo_app, event_demo_tap, LV_EVENT_CLICKED, NULL);

    title = lv_label_create(screen_demo_app);
    lv_label_set_text(title, "Demo");
    lv_obj_set_style_text_color(title, lv_color_hex(0x42A5F5), 0);
    lv_obj_set_style_text_font(title, &lv_font_montserrat_32, 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 36);

    label_demo_value = lv_label_create(screen_demo_app);
    lv_label_set_text(label_demo_value, "0");
    lv_obj_set_style_text_color(label_demo_value, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_demo_value, &lv_font_montserrat_bold_116, 0);
    lv_obj_align(label_demo_value, LV_ALIGN_CENTER, 0, -8);

    hint = lv_label_create(screen_demo_app);
    lv_label_set_text(hint, "Turn dial / tap screen");
    lv_obj_set_style_text_color(hint, lv_color_hex(0x8A8A8A), 0);
    lv_obj_set_style_text_font(hint, &lv_font_montserrat_14, 0);
    lv_obj_align(hint, LV_ALIGN_CENTER, 0, 52);

    label_demo_tap = lv_label_create(screen_demo_app);
    lv_label_set_text(label_demo_tap, "Taps: 0");
    lv_obj_set_style_text_color(label_demo_tap, lv_color_hex(0x6A6A6A), 0);
    lv_obj_set_style_text_font(label_demo_tap, &lv_font_montserrat_14, 0);
    lv_obj_align(label_demo_tap, LV_ALIGN_CENTER, 0, 74);

    btn = make_button(screen_demo_app, "Apps", 120, 46, event_demo_apps);
    lv_obj_align(btn, LV_ALIGN_BOTTOM_MID, 0, -28);
}
