#
# Bober V2X
#

include $(TOPDIR)/rules.mk

PKG_NAME:=boberv2x
PKG_VERSION:=0.0.1
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/boberv2x
  SECTION:=BoberV2X
  CATEGORY:=BoberV2X
  TITLE:=BoberV2X
  DEPENDS:=+base-files +firewall
endef

define Package/boberv2x/description
  Meta package for Bober V2X installation
endef

define Build/Compile
        # NOOP
endef

define Package/boberv2x/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,boberv2x))