#ifndef __RUNNER_H__
#define __RUNNER_H__

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define SERVICE_FLAG_RUN_ONCE 0x0001
#define SERVICE_FLAG_AUTO_START 0x0010
#define SERVICE_FLAG_STOP_WHEN_DONE 0x0100
#define SERVICE_FLAG_VERBOSE 0x1000

#define SERVICE_WARN_MEMORY 0x32
#define SERVICE_ERROR_INVALID_SIGNATURE 0x42
#define SERVICE_ERROR_INVALID_MAGIC 0x52
#define SERVICE_ERROR_FILE_NOT_FOUND 0x62
#define SERVICE_ERROR_NO_VMM 0x69
#define SERVICE_ERROR_UNKNOWN 0x80

#define SERVICE_TYPE_DAEMON 0x01
#define SERVICE_TYPE_DRIVER 0x02
#define SERVICE_TYPE_CHECK 0x03
#define SERVICE_TYPE_CONF 0x04
#define SERVICE_TYPE_KINIT 0x05

#define MAX_SERVICE_ERR_LEN 64

typedef struct service_t service_t;

typedef struct {
    char name[32];
    bool verbose;
    bool run_once;
    bool auto_start;
    bool stop_when_done;
    uint8_t type;
    int (*runner)(service_t *, void *);
} service_config_t;

struct service_t {
    service_config_t *config;
    bool has_been_run;
    uint16_t flags;
    int (*runner)(service_t *, void *);
};

int register_service(service_config_t *conf, void *in);
void test_service();

#endif  // __RUNNER_H__
