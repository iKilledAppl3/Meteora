ARCHS = armv7 arm64
TARGET = iphone:clang:latest
SDK = iPhoneOS8.1
THEOS_BUILD_DIR = DEBs

include theos/makefiles/common.mk

TWEAK_NAME = Durango
Durango_FILES = Tweak.xm
Durango_FRAMEWORKS = UIKit CoreGraphics AudioToolbox AVFoundation
Durango_PRIVATE_FRAMEWORKS = MediaRemote
Durango_LIBRARIES += cephei
Durango += -Wl,-segalign,4000
Durango_CFLAGS = -Wno-deprecated -Wno-deprecated-declarations -Wno-error

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Durango_prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
