#
# Copyright (C) 2015 CZ.NIC, z. s. p. o. (https://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PKG_RELRO_FULL:=0

include $(TOPDIR)/rules.mk

PKG_NAME:=knot-resolver-fullforward
PKG_VERSION:=765254e0b091122c0156e7793639dde8ef63484f

PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://gitlab.labs.nic.cz/knot/resolver.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.gz

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_MAINTAINER:=Knot DNS <knot-dns@labs.nic.cz>
PKG_LICENSE:=GPL-3.0

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/knot-resolver-fullforward
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=IP Addresses and Names
	TITLE:=Knot DNS Resolver
	URL:=https://gitlab.labs.nic.cz/knot/resolver
	DEPENDS=+knot-libknot +libuv +luajit +knot-libzscanner +knot-libdnssec +dnssec-rootkey +resolver-conf +luasec +luasocket
	EXTRA_DEPENDS:=knot-libknot (>= 2.4.2), knot-libknot (< 2.5.0)
endef

define Package/knot-resolver-fullforward/description
  The Knot DNS Resolver is a minimalistic caching resolver implementation.
endef

MAKE_FLAGS += \
	PREFIX=/usr \
	ETCDIR=/etc/kresd

define Build/Patch
	$(Build/Patch/Default)
	cd $(PKG_BUILD_DIR) && \
	sed -i -e 's/\(.*find_lib,hiredis.*\)/HAS_hiredis := no/' \
	       -e 's/\(.*find_lib,libmemcached.*\)/HAS_libmemcached := no/' Makefile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/*bin/kresd $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libkres.so* $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/kdns_modules $(1)/usr/lib

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/kresd.init $(1)/etc/init.d/kresd

	$(INSTALL_DIR) $(1)/etc/kresd
	$(CP) $(PKG_BUILD_DIR)/etc/icann-ca.pem $(1)/etc/kresd
	$(INSTALL_BIN) ./files/dhcp_host_domain_ng.sh $(1)/etc/kresd/dhcp_host_domain_ng.sh
	$(INSTALL_BIN) ./files/kresd.postinst $(1)/etc/kresd/kresd.postinst.sh
	$(INSTALL_BIN) ./files/convert_config.sh $(1)/etc/kresd/convert_config.sh
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
set -ex
if [ -z "$$IPKG_INSTROOT" ]; then
/etc/init.d/dnsmasq restart
sleep 2 # Cooldown for above (problems in times of reinstall)
/etc/kresd/kresd.postinst.sh && rm /etc/kresd/kresd.postinst.sh
/etc/kresd/convert_config.sh && rm /etc/kresd/convert_config.sh
fi
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
set -ex
if [ -z "$$IPKG_INSTROOT" ]; then
# Remove the script if it is there.
if [ -e /etc/init.d/kresd ] ; then /etc/init.d/kresd stop ; /etc/init.d/kresd disable ;  fi
fi
endef

define Package/knot-resolver-fullforward/postrm
#!/bin/sh
if [ -z "$$IPKG_INSTROOT" ]; then
[ \! -x /etc/init.d/resolver ] || /etc/init.d/resolver restart
fi
endef

$(eval $(call BuildPackage,knot-resolver-fullforward))

