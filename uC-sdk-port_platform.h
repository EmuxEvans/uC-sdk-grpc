#define GPR_NO_AUTODETECT_PLATFORM
#define GPR_ARCH_32 1
#define GPR_GCC_SYNC 1
#define GPR_GCC_TLS 1
#define GPR_CUSTOM_SOCKET 1
#define GPR_CPU_CUSTOM 1
#define GPR_CUSTOM_SYNC 1

typedef void * gpr_mu;
typedef void * gpr_cv;
typedef void * gpr_once;

#define GPR_ONCE_INIT NULL
