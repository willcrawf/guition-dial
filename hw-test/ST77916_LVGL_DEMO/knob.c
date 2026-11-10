#include "knob.h"

/* Minimal bring-up UI: large number, dial +/-1, touch flash confirmation.
 * Built from the manufacturer ST77916_LVGL_DEMO pin/init path. */

static lv_obj_t *screen = NULL;
static lv_obj_t *label_value = NULL;
static lv_obj_t *label_hint = NULL;
static lv_obj_t *label_touch = NULL;
static int value = 40; /* Commander starting life */

static void refresh_value(void)
{
  if (label_value == NULL) return;
  lv_label_set_text_fmt(label_value, "%d", value);
}

static void on_touch(lv_event_t *e)
{
  lv_event_code_t code = lv_event_get_code(e);
  if (code == LV_EVENT_PRESSED) {
    lv_label_set_text(label_touch, "TOUCH");
    lv_obj_set_style_text_color(label_touch, lv_color_hex(0x00C853), 0);
  } else if (code == LV_EVENT_RELEASED) {
    lv_label_set_text(label_touch, "ready");
    lv_obj_set_style_text_color(label_touch, lv_color_hex(0x888888), 0);
  }
}

void knob_gui(void)
{
  screen = lv_obj_create(NULL);
  lv_obj_set_size(screen, 360, 360);
  lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
  lv_obj_set_style_border_width(screen, 0, 0);
  lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
  lv_obj_add_event_cb(screen, on_touch, LV_EVENT_PRESSED, NULL);
  lv_obj_add_event_cb(screen, on_touch, LV_EVENT_RELEASED, NULL);
  lv_scr_load(screen);

  label_hint = lv_label_create(screen);
  lv_label_set_text(label_hint, "HW TEST");
  lv_obj_set_style_text_color(label_hint, lv_color_hex(0xAAAAAA), 0);
  lv_obj_align(label_hint, LV_ALIGN_TOP_MID, 0, 48);

  label_value = lv_label_create(screen);
  lv_obj_set_style_text_color(label_value, lv_color_white(), 0);
  lv_obj_set_style_text_font(label_value, &lv_font_montserrat_32, 0);
  lv_obj_align(label_value, LV_ALIGN_CENTER, 0, -8);
  refresh_value();

  label_touch = lv_label_create(screen);
  lv_label_set_text(label_touch, "ready");
  lv_obj_set_style_text_color(label_touch, lv_color_hex(0x888888), 0);
  lv_obj_align(label_touch, LV_ALIGN_BOTTOM_MID, 0, -56);
}

void knob_cb(lv_event_t *e)
{
  (void)e;
}

void knob_change(knob_event_t k, int cont)
{
  (void)cont;
  if (k == KNOB_LEFT) {
    value -= 1;
  } else if (k == KNOB_RIGHT) {
    value += 1;
  }
  refresh_value();
}
