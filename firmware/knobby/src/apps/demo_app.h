#ifndef _DEMO_APP_H
#define _DEMO_APP_H

#include "../types.h"

extern lv_obj_t *screen_demo_app;

void build_demo_app_screen(void);
void open_demo_app(void);
void refresh_demo_app_ui(void);
void change_demo_value(int delta);
void event_open_demo_app(lv_event_t *e);

#endif // _DEMO_APP_H
