########################################################################
# sdk-statics.mk ABr
# Static variables for a specific SDK (e.g. iphoneos / iphonesimulator)

# PRJ_DIR -> Directory of this Makefile
PRJ_DIR:=$(realpath .)

# BUILD_DIR -> Will contain all output
BUILD_DIR:=$(PRJ_DIR)/build_dir

# TOP_DIR -> Directory where msoffice was cloned.
TOP_DIR:=$(realpath ../../..)

# SIMDE_DIR -> Location of the simde project (directly under TOP_DIR)
SIMDE_DIR:=$(TOP_DIR)/simde

# MSOC_DIR -> Location of the msoffice project (directly under TOP_DIR)
MSOC_DIR:=$(TOP_DIR)/msoffice

# CYBOZULIB_DIR -> Location of the cybozulib project (directly under TOP_DIR)
CYBOZULIB_DIR:=$(TOP_DIR)/cybozulib

# You must pass in location for openssl. The passed folder must contain:
# * openssl-arm64-v8a - ARM64 build
# * openssl-armeabi-v7a - old ARM build
# * openssl-x86 - x86 build (used by emulator)
# * openssl-x86_64 - x64 build
#
# Underneath each folder there must be:
# * lib - Prebuilt openssl binaries
# * include - openssl include folder for that platform
ifeq ($(OPENSSL_DIR),)
$(error Must set OPENSSL_DIR to location for Android openssl)
OPENSSL_DIR:=$(MSOC_DIR)/android/openssl
endif

# validate all folders
ifeq (,$(wildcard $(SIMDE_DIR)/.*))
$(error Cannot locate $(SIMDE_DIR))
endif
ifeq (,$(wildcard $(MSOC_DIR)/.*))
$(error Cannot locate $(MSOC_DIR))
endif
ifeq (,$(wildcard $(CYBOZULIB_DIR)/.*))
$(error Cannot locate $(CYBOZULIB_DIR))
endif

# all other locations are relative to MSOC_DIR
SRC_DIR:=$(MSOC_DIR)/src

# set API level here
ifeq ($(ANDROID_API),)
ANDROID_API:=34
endif
export ANDROID_API

# require ANDROID_HOME
ifeq ($(ANDROID_HOME),)
$(error Must set ANDROID_HOME)
endif
ifeq ($(ANDROID_SDK_HOME),)
ANDROID_SDK_HOME=$(shell find $(ANDROID_HOME) -type d -name sdk)
endif
ifeq ($(ANDROID_SDK_HOME),)
$(error Cannot locate 'sdk' directory from ANDROID_HOME)
endif

ifeq ($(ANDROID_NDK_HOME),)
# default to highest installed NDK
ANDROID_NDK_HOME=$(shell find $(ANDROID_SDK_HOME)/ndk/* -maxdepth 0 -type d | sort -r | head -n 1)
endif
ifeq ($(ANDROID_NDK_HOME),)
$(error Cannot locate ANDROID_NDK_HOME from ANDROID_SDK_HOME)
endif

# note tools specific to mac and intel :(
ANDROID_NDK_TOOLCHAIN_DIR:=$(ANDROID_NDK_HOME)/toolchains
ANDROID_NDK_PREBUILT_DIR:=$(ANDROID_NDK_TOOLCHAIN_DIR)/llvm/prebuilt/darwin-x86_64
ANDROID_NDK_SYSROOT_DIR:=$(ANDROID_NDK_PREBUILT_DIR)/sysroot

## require NDK via Xamarin
#XAMARIN_ANDROID_SDK_DIR=$(HOME)/Library/Developer/Xamarin/android-sdk-macosx
#XAMARIN_ANDROID_NDK_DIR=$(XAMARIN_ANDROID_SDK_DIR)/ndk-bundle
#ifeq ($(wildcard $(XAMARIN_ANDROID_NDK_DIR)/.*),)
#$(error This build requires Xamarin Android NDK to be installed at '$(XAMARIN_ANDROID_NDK_DIR)')
#endif
##$(info XAMARIN_ANDROID_NDK_DIR=$(XAMARIN_ANDROID_NDK_DIR))

## note tools specific to mac and intel :(
#XAMARIN_ANDROID_NDK_TOOLCHAIN_DIR:=$(XAMARIN_ANDROID_NDK_DIR)/toolchains
#XAMARIN_ANDROID_NDK_PREBUILT_DIR:=$(XAMARIN_ANDROID_NDK_TOOLCHAIN_DIR)/llvm/prebuilt/darwin-x86_64
#XAMARIN_ANDROID_NDK_SYSROOT_DIR:=$(XAMARIN_ANDROID_NDK_PREBUILT_DIR)/sysroot

# set major env vars used to locate tools
ifeq (,$(findstring $(ANDROID_SDK_HOME)/emulator,$(PATH)))
PATH:=$(PATH):$(ANDROID_SDK_HOME)/emulator
endif
ifeq (,$(findstring $(ANDROID_SDK_HOME)/tools/bin,$(PATH)))
PATH:=$(PATH):$(ANDROID_SDK_HOME)/tools/bin
endif
ifeq (,$(findstring $(ANDROID_SDK_HOME)/platform-tools,$(PATH)))
PATH:=$(PATH):$(ANDROID_SDK_HOME)/platform-tools
endif
ifeq (,$(findstring $(ANDROID_NDK_PREBUILT_DIR)/bin,$(PATH)))
PATH:=$(PATH):$(ANDROID_NDK_PREBUILT_DIR)/bin
endif
export PATH
#$(info PATH=$(PATH))
#$(error PATH=$(PATH))
#ANDROID_NDK_HOME:=$(XAMARIN_ANDROID_NDK_DIR)
#export ANDROID_NDK_HOME
PLATFORM_TYPE:=Android
export PLATFORM_TYPE

