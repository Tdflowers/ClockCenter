SDK_VERSION= 5.0
GO_EASY_ON_ME = 1
include theos/makefiles/common.mk

BUNDLE_NAME = ClockCenter
ClockCenter_FILES = ClockCenterController.m
ClockCenter_INSTALL_PATH = /System/Library/WeeAppPlugins/
ClockCenter_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
