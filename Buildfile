#  Buildfile
#  Bibliotek
#
#  Created by Steve Brunwasser on 12/20/22.
#  Copyright © 2022 Steve Brunwasser. All rights reserved.
#
#  This Makefile downloads and compiles the open source YAZ library developed by Index Data.
#  The YAZ library provides support for the Z39.50 protocol, which is used for searching and
#  retrieving information from remote databases.
#
#  More information about YAZ can be found at https://www.indexdata.com/resources/software/yaz/

.DEFAULT: all
.PHONY: all

# Set the CC variable to the clang compiler.
# The CC variable specifies the compiler to be used for building the project.
CC ?= /usr/bin/clang

# Set the CFLAGS and LDFLAGS variables to include all architectures in $ARCHS.
# The CFLAGS variable specifies additional flags to be passed to the compiler.
# The LDFLAGS variable specifies additional flags to be passed to the linker.
CFLAGS += $(foreach arch,$(ARCHS),-arch $(arch))
LDFLAGS += $(foreach arch,$(ARCHS),-arch $(arch))

# Set the YAZ version, source URL, and build directory variables.
# The YAZ_VERSION variable specifies the version of YAZ to download and build.
# The YAZ_SOURCE_URL variable specifies the URL of the YAZ source code tarball.
# The YAZ_SOURCE_DIR variable specifies the directory where the YAZ source code will be extracted.
# The YAZ_BUILD_DIR variable specifies the directory where YAZ build products will be installed.
# The YAZ_TEMP_DIR variable specifies a temporary directory where YAZ will be built.
YAZ_VERSION ?= yaz-5.32.0
YAZ_SOURCE_URL ?= https://ftp.indexdata.com/pub/yaz/$(YAZ_VERSION).tar.gz
YAZ_SOURCE_DIR ?= $(PROJECT_DIR)/libyaz
YAZ_BUILD_DIR ?= $(TARGET_BUILD_DIR)
YAZ_TEMP_DIR ?= $(TARGET_TEMP_DIR)

# The default target for this Makefile is 'all', which builds the YAZ library.
all: $(YAZ_BUILD_DIR)/lib/libyaz.dylib $(YAZ_BUILD_DIR)/include/yaz/yaz-version.h

# Create the YAZ source, build, and temp directories if they don't already exist.
$(YAZ_SOURCE_DIR) $(YAZ_BUILD_DIR) $(YAZ_TEMP_DIR):
	mkdir -p $@

# Download the YAZ source code tarball and extract it to the YAZ source directory.
$(YAZ_SOURCE_DIR)/configure: $(YAZ_SOURCE_DIR)
	curl -L $(YAZ_SOURCE_URL) | tar xz -C $(YAZ_SOURCE_DIR) --strip-components 1

# Generate the Makefile for building YAZ.
$(YAZ_TEMP_DIR)/Makefile $(YAZ_TEMP_DIR)/%/Makefile: $(YAZ_SOURCE_DIR)/configure $(YAZ_TEMP_DIR)
	cd $(YAZ_TEMP_DIR) && $(YAZ_SOURCE_DIR)/configure \
		CC="$(CC)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" \
		--srcdir=$(YAZ_SOURCE_DIR) --prefix=$(YAZ_BUILD_DIR) \
		--enable-threads --enable-shared --disable-static \
		--with-xslt --with-xml2 --with-iconv --without-gnutls

# Build and install the YAZ library.
$(YAZ_BUILD_DIR)/lib/libyaz.dylib: $(YAZ_TEMP_DIR)/src/Makefile $(YAZ_BUILD_DIR)
	cd $(YAZ_TEMP_DIR)/src && $(MAKE) && $(MAKE) install
	install_name_tool -id "@rpath/libyaz.5.dylib" $(YAZ_BUILD_DIR)/lib/libyaz.5.dylib
	install_name_tool -id "@rpath/libyaz_icu.5.dylib" $(YAZ_BUILD_DIR)/lib/libyaz_icu.5.dylib
	install_name_tool -id "@rpath/libyaz_server.5.dylib" $(YAZ_BUILD_DIR)/lib/libyaz_server.5.dylib

# Install the YAZ headers.
$(YAZ_BUILD_DIR)/include/yaz/yaz-version.h: $(YAZ_TEMP_DIR)/include/Makefile $(YAZ_BUILD_DIR)
	cd $(YAZ_TEMP_DIR)/include && $(MAKE) && $(MAKE) install
