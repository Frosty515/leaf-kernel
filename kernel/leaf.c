#define LEAF_INCLUDE_PRIVATE
#include <sys/leaf.h>

// CPU related headers
#include <arch/cpu/cpu.h>
#include <arch/cpu/cpuid.h>
#include <arch/cpu/utils.h>

// x86_64 architecture specific headers
#include <arch/x86_64/acpi/mcfg.h>
#include <arch/x86_64/idt/idt.h>

// File system related headers
#include <fs/vfs.h>

// Memory management related headers
#include <libc/stdlib/memory/kheap.h>

// System configuration headers
#include <sys/_config.h>

// Backtrace related headers
#include <sys/backtrace.h>

// Real-time clock related headers
#include <sys/time/rtc.h>

// Utility headers for parsing
#include <utils/parsing/ini.h>

int main() {
    plog_ok("Reached target \033[1mpost-kinit\033[0m");
    _int(1);

    hlt();
    return LEAF_RETURN_SUCCESS;
}
