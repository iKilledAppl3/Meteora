ARCHS = armv7 arm64
TARGET = iphone:clang:latest

include theos/makefiles/common.mk

BUNDLE_NAME = Meteora
Meteora_FILES = Meteora.mm
Meteora_INSTALL_PATH = /Library/PreferenceBundles
Meteora_FRAMEWORKS = UIKit MessageUI CoreGraphics
Meteora_PRIVATE_FRAMEWORKS = Preferences
Meteora_EXTRA_FRAMEWORKS = CepheiPrefs
Meteora_LIBRARIES += MobileGestalt
Meteora_CFLAGS = -Wno-deprecated -Wno-deprecated-declarations -Wno-error

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Meteora.plist$(ECHO_END)
