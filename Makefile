ARCHS = arm64
TARGET = iphone:clang:latest:12.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = keepkeychain
keepkeychain_FILES = Tweak.x
keepkeychain_FRAMEWORKS = Foundation Security
keepkeychain_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
