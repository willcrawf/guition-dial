#ifndef _APP_SELECT_H
#define _APP_SELECT_H

#include "../types.h"

extern lv_obj_t *screen_app_select;

void build_app_select_screen(void);
void open_app_select(void);
void event_open_app_select(lv_event_t *e);

#endif // _APP_SELECT_H
