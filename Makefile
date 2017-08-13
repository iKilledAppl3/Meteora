ARCHS = armv7 arm64
TARGET = iphone:clang:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Meteora
Meteora_FILES = Tweak.xm
Meteora_FRAMEWORKS = UIKit CoreGraphics AudioToolbox AVFoundation
Meteora_PRIVATE_FRAMEWORKS = MediaRemote
Meteora_EXTRA_FRAMEWORKS += Cephei
Meteora += -Wl,-segalign,4000
Meteora_CFLAGS = -Wno-deprecated -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
