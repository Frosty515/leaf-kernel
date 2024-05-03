#ifndef __CONFIG_H__
#define __CONFIG_H__

#define __LEAF_VERBOSE__
// #define __LEAF_VVERBOSE__
#define __LEAF_DEBUG_WRAPPERS__
#define __LEAF_DEBUG__

#define CONFIG_CPU_MAX 256

#include <stdbool.h>

extern bool _leaf_log;
extern bool _leaf_should_clear_serial;

#define __LEAF_DISABLE_LOG() _leaf_log = false;
#define __LEAF_ENABLE_LOG() _leaf_log = true;
#define __LEAF_CLEAR_SERIAL() _leaf_should_clear_serial = true;
#define __LEAF_DONT_CLEAR_SERIAL() _leaf_should_clear_serial = false;

#endif  // __CONFIG_H__
