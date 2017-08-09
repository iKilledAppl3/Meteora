ARCHS = armv7 arm64
SDK = iPhoneOS8.1
TARGET = iphone:clang:latest
THEOS_BUILD_DIR = DEBS

include theos/makefiles/common.mk

BUNDLE_NAME = Durango
Durango_FILES = Durango.mm
Durango_INSTALL_PATH = /Library/PreferenceBundles
Durango_FRAMEWORKS = UIKit MessageUI CoreGraphics
Durango_PRIVATE_FRAMEWORKS = Preferences
Durango_LIBRARIES += cepheiprefs MobileGestalt
Durango_CFLAGS = -Wno-deprecated -Wno-deprecated-declarations -Wno-error

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Durango.plist$(ECHO_END)
