cc_library(
    name = "libco",
    hdrs = glob(["*.h"]),
    srcs = glob(["*.cpp"],
            exclude = ["example*"],
        ) + glob(["*.S"]),
    copts = ["-std=c++11"],
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "example_cond",
    srcs = ["example_cond.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)

cc_binary(
    name = "example_closure",
    srcs = ["example_closure.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)

cc_binary(
    name = "example_copystack",
    srcs = ["example_copystack.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)


cc_binary(
    name = "example_setenv",
    srcs = ["example_setenv.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)

cc_binary(
    name = "example_specific",
    srcs = ["example_specific.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)

cc_binary(
    name = "example_thread",
    srcs = ["example_thread.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)


cc_binary(
    name = "example_echocli",
    srcs = ["example_echocli.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)

cc_binary(
    name = "example_echosvr",
    srcs = ["example_echosvr.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)

cc_binary(
    name = "example_poll",
    srcs = ["example_poll.cpp"],
    copts = ["-std=c++11",
        ],
    linkopts = [],
    deps = ["//:libco"]
)
