#include "scr_st77916.h"
#include <lvgl.h>
#include "hal/lv_hal.h"
#include "knob.h"

void setup()
{
  delay(200);
  Serial.begin(115200);
  scr_lvgl_init();
  knob_gui();
}

void loop()
{
  lv_timer_handler();
  vTaskDelay(5);
}
