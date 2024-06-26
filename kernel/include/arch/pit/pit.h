#ifndef __PIT_H__
#define __PIT_H__

#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <arch/x86_64/idt/idt.h>

#define PIT_COMMAND 0x43
#define PIT_DATA 0x40

extern int_frame_t *cur_frame;

void pit_set_count(uint16_t count);
uint16_t pit_read_count();
void pit_set_divisor(uint16_t divisor);
void init_pit();
void pit_int();
void pit_sleep(uint64_t millis);

uint64_t pit_get_uptime_milis();
uint64_t pit_get_uptime_secs();

#endif  // __PIT_H__
