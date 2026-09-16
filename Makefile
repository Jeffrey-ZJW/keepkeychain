ARCHS = arm64
TARGET = iphone:clang:latest:12.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AAKK
AAKK_FILES = Tweak.x
AAKK_FRAMEWORKS = Foundation Security
AAKK_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
