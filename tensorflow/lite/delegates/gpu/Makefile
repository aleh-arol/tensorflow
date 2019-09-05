# Find where we're running from, so we can store generated files here.
ifeq ($(origin MAKEFILE_DIR), undefined)
	MAKEFILE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
endif

HOST_ARCH := $(shell if uname -m | grep -q i[345678]86; then echo x86_32; else uname -m; fi)

# Override these on the make command line to target a specific architecture. For example:
# make -f tensorflow/lite/tools/make/Makefile TARGET=rpi TARGET_ARCH=armv7l
TARGET := linux
TARGET_ARCH := $(HOST_ARCH)

INCLUDES := \
-I. \
-I$(MAKEFILE_DIR)/downloads/ \
-I$(MAKEFILE_DIR)/downloads/FP16/include \
-I$(MAKEFILE_DIR)/downloads/absl \
-I$(MAKEFILE_DIR)/downloads/flatbuffers/include

CXXFLAGS := -O3 -DNDEBUG -fPIC -DTFLITE_GPU_BINARY_RELEASE \
-fvisibility=hidden \
-Wno-implicit-fallthrough \
-fexceptions \
-ffunction-sections \
-funwind-tables \
-fstack-protector-strong \
-fpic \
-Wno-invalid-command-line-argument \
-Wno-unused-command-line-argument \
-no-canonical-prefixes

CFLAGS := ${CXXFLAGS}
CXXFLAGS += -std=c++14
ARFLAGS := -r

LIB_NAME := libtensorflowlite_gpu_gl.a

ALL_SRCS := \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/dynamic_annotations.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/cycleclock.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/low_level_alloc.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/raw_logging.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/spinlock.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/spinlock_wait.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/sysinfo.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/thread_identity.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/throw_delegate.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/internal/unscaledcycleclock.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/base/log_severity.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/container/internal/hashtablez_sampler.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/container/internal/hashtablez_sampler_force_weak_definition.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/container/internal/raw_hash_set.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/debugging/internal/address_is_readable.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/debugging/internal/demangle.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/debugging/internal/elf_mem_image.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/debugging/internal/vdso_support.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/debugging/stacktrace.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/debugging/symbolize.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/hash/internal/city.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/hash/internal/hash.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/numeric/int128.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/ascii.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/charconv.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/escaping.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/charconv_bigint.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/charconv_parse.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/memutil.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/ostringstream.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/str_format/arg.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/str_format/bind.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/str_format/extension.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/str_format/float_conversion.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/str_format/output.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/str_format/parser.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/internal/utf8.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/match.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/numbers.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/str_cat.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/str_replace.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/str_split.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/string_view.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/strings/substitute.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/barrier.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/blocking_counter.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/internal/create_thread_identity.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/internal/graphcycles.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/internal/per_thread_sem.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/internal/waiter.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/mutex.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/synchronization/notification.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/civil_time.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/clock.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/duration.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/format.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/civil_time_detail.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_fixed.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_format.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_if.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_impl.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_info.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_libc.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_lookup.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/time_zone_posix.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/internal/cctz/src/zone_info_source.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/time/time.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/types/bad_any_cast.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/types/bad_optional_access.cc \
tensorflow/lite/delegates/gpu/downloads/absl/absl/types/bad_variant_access.cc \
tensorflow/lite/delegates/gpu/downloads/flatbuffers/src/code_generators.cpp \
tensorflow/lite/delegates/gpu/downloads/flatbuffers/src/idl_gen_fbs.cpp \
tensorflow/lite/delegates/gpu/downloads/flatbuffers/src/idl_gen_general.cpp \
tensorflow/lite/delegates/gpu/downloads/flatbuffers/src/idl_gen_text.cpp \
tensorflow/lite/delegates/gpu/downloads/flatbuffers/src/idl_parser.cpp \
tensorflow/lite/delegates/gpu/downloads/flatbuffers/src/reflection.cpp \
tensorflow/lite/delegates/gpu/downloads/flatbuffers/src/util.cpp \
tensorflow/lite/c/c_api_internal.c \
tensorflow/lite/delegates/gpu/common/convert.cc \
tensorflow/lite/delegates/gpu/common/data_type.cc \
tensorflow/lite/delegates/gpu/common/gpu_info.cc \
tensorflow/lite/delegates/gpu/common/memory_management.cc \
tensorflow/lite/delegates/gpu/common/memory_management/greedy_by_breadth_assignment.cc \
tensorflow/lite/delegates/gpu/common/memory_management/greedy_by_size_assignment.cc \
tensorflow/lite/delegates/gpu/common/memory_management/internal.cc \
tensorflow/lite/delegates/gpu/common/memory_management/min_cost_flow_assignment.cc \
tensorflow/lite/delegates/gpu/common/model_builder.cc \
tensorflow/lite/delegates/gpu/common/model_transformer.cc \
tensorflow/lite/delegates/gpu/common/operations.cc \
tensorflow/lite/delegates/gpu/common/shape.cc \
tensorflow/lite/delegates/gpu/common/transformations/fuse_add_to_conv.cc \
tensorflow/lite/delegates/gpu/common/transformations/fuse_mul_to_conv.cc \
tensorflow/lite/delegates/gpu/common/transformations/general_transformations.cc \
tensorflow/lite/delegates/gpu/common/transformations/make_fully_connected.cc \
tensorflow/lite/delegates/gpu/common/transformations/make_padding.cc \
tensorflow/lite/delegates/gpu/common/transformations/match_dilated_convolution.cc \
tensorflow/lite/delegates/gpu/common/transformations/merge_padding_with.cc \
tensorflow/lite/delegates/gpu/common/transformations/remove_noop.cc \
tensorflow/lite/delegates/gpu/gl/api.cc \
tensorflow/lite/delegates/gpu/gl/command_queue.cc \
tensorflow/lite/delegates/gpu/gl/compiler.cc \
tensorflow/lite/delegates/gpu/gl/compiler/compiled_node.cc \
tensorflow/lite/delegates/gpu/gl/compiler/fuse_auto_input.cc \
tensorflow/lite/delegates/gpu/gl/compiler/fuse_inline.cc \
tensorflow/lite/delegates/gpu/gl/compiler/fuse_inplace.cc \
tensorflow/lite/delegates/gpu/gl/compiler/object_accessor.cc \
tensorflow/lite/delegates/gpu/gl/compiler/preprocessor.cc \
tensorflow/lite/delegates/gpu/gl/compiler/rename.cc \
tensorflow/lite/delegates/gpu/gl/compiler/shader_codegen.cc \
tensorflow/lite/delegates/gpu/gl/compiler/variable_accessor.cc \
tensorflow/lite/delegates/gpu/gl/converters/bhwc_to_phwc4.cc \
tensorflow/lite/delegates/gpu/gl/converters/phwc4_to_bhwc.cc \
tensorflow/lite/delegates/gpu/gl/egl_context.cc \
tensorflow/lite/delegates/gpu/gl/egl_environment.cc \
tensorflow/lite/delegates/gpu/gl/egl_surface.cc \
tensorflow/lite/delegates/gpu/gl/float16_conversions.cc \
tensorflow/lite/delegates/gpu/gl/gl_buffer.cc \
tensorflow/lite/delegates/gpu/gl/gl_errors.cc \
tensorflow/lite/delegates/gpu/gl/gl_program.cc \
tensorflow/lite/delegates/gpu/gl/gl_shader.cc \
tensorflow/lite/delegates/gpu/gl/gl_sync.cc \
tensorflow/lite/delegates/gpu/gl/gl_texture.cc \
tensorflow/lite/delegates/gpu/gl/kernels/add.cc \
tensorflow/lite/delegates/gpu/gl/kernels/concat.cc \
tensorflow/lite/delegates/gpu/gl/kernels/conv.cc \
tensorflow/lite/delegates/gpu/gl/kernels/custom_registry.cc \
tensorflow/lite/delegates/gpu/gl/kernels/depthwise_conv.cc \
tensorflow/lite/delegates/gpu/gl/kernels/elementwise.cc \
tensorflow/lite/delegates/gpu/gl/kernels/fully_connected.cc \
tensorflow/lite/delegates/gpu/gl/kernels/lstm.cc \
tensorflow/lite/delegates/gpu/gl/kernels/mul.cc \
tensorflow/lite/delegates/gpu/gl/kernels/pad.cc \
tensorflow/lite/delegates/gpu/gl/kernels/pooling.cc \
tensorflow/lite/delegates/gpu/gl/kernels/prelu.cc \
tensorflow/lite/delegates/gpu/gl/kernels/registry.cc \
tensorflow/lite/delegates/gpu/gl/kernels/relu.cc \
tensorflow/lite/delegates/gpu/gl/kernels/reshape.cc \
tensorflow/lite/delegates/gpu/gl/kernels/slice.cc \
tensorflow/lite/delegates/gpu/gl/kernels/softmax.cc \
tensorflow/lite/delegates/gpu/gl/kernels/transpose_conv.cc \
tensorflow/lite/delegates/gpu/gl/kernels/upsampling_bilinear.cc \
tensorflow/lite/delegates/gpu/gl/object_manager.cc \
tensorflow/lite/delegates/gpu/gl/request_gpu_info.cc \
tensorflow/lite/delegates/gpu/gl/runtime.cc \
tensorflow/lite/delegates/gpu/gl/workgroups/best_effort_calculator.cc \
tensorflow/lite/delegates/gpu/gl/workgroups/calculator.cc \
tensorflow/lite/delegates/gpu/gl/workgroups/default_calculator.cc \
tensorflow/lite/delegates/gpu/gl/workgroups/ideal_workgroup_picker.cc \
tensorflow/lite/delegates/gpu/gl_delegate.cc \
tensorflow/lite/kernels/internal/quantization_util.cc \
tensorflow/lite/kernels/kernel_util.cc \
tensorflow/lite/minimal_logging.cc \
tensorflow/lite/minimal_logging_default.cc \
tensorflow/lite/util.cc

ifeq ($(TARGET),aarch64)
  EXTRA_SRCS := tensorflow/lite/minimal_logging_android.cc
  TARGET_ARCH := armv8-a
  TARGET_TOOLCHAIN_PREFIX := /tmp/arm64/bin/aarch64-linux-android
  CXX := $(CC_PREFIX)${TARGET_TOOLCHAIN_PREFIX}21-clang++
  CC := $(CC_PREFIX)${TARGET_TOOLCHAIN_PREFIX}21-clang
  AR := $(CC_PREFIX)${TARGET_TOOLCHAIN_PREFIX}-ar
endif

ALL_SRCS += $(EXTRA_SRCS)

# Where compiled objects are stored.
GENDIR := $(MAKEFILE_DIR)/gen/$(TARGET)_$(TARGET_ARCH)/
OBJDIR := $(GENDIR)obj/
BINDIR := $(GENDIR)bin/
LIBDIR := $(GENDIR)lib/

LIB_PATH := $(LIBDIR)$(LIB_NAME)

LIB_OBJS := $(addprefix $(OBJDIR), \
$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(ALL_SRCS)))))

# For normal manually-created TensorFlow Lite C++ source files.
$(OBJDIR)%.o: %.cc
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# For normal manually-created TensorFlow Lite C source files.
$(OBJDIR)%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJDIR)%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Gathers together all the objects we've compiled into a single '.a' archive.
$(LIB_PATH): $(LIB_OBJS)
	@mkdir -p $(dir $@)
	$(AR) $(ARFLAGS) $(LIB_PATH) $(LIB_OBJS)

all: $(LIB_PATH)

# Gets rid of all generated files.
clean:
	rm -rf $(MAKEFILE_DIR)/gen
