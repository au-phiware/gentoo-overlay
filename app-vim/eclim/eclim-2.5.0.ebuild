# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

#VIM_PLUGIN_VIM_VERSION="7.0"
inherit eutils java-pkg-2 java-ant-2 multilib

MY_P=${P/-/_}

DESCRIPTION="The power of Eclipse in your favorite editor."
HOMEPAGE="http://eclim.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+java"
SRC_URI="https://github.com/ervandew/eclim/releases/download/${PV}/${MY_P}.tar.gz"

VIM_PLUGIN_HELPFILES=""
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""

COMMON_DEPEND="|| ( dev-util/eclipse-sdk:3.5 >=dev-util/eclipse-sdk-bin-4.2.0 )"
JAVA_VERSION="1.7"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-${JAVA_VERSION}"
RDEPEND="${COMMON_DEPEND}
	|| ( app-editors/vim app-editors/gvim )
	>=virtual/jre-${JAVA_VERSION}"

S=${WORKDIR}/${MY_P}
eclipse_home="${ROOT}/opt/eclipse-sdk-bin-4.5"

pkg_setup() {
	if use java ; then
		mypkg_plugins=",jdt,ant,maven"
	fi
	mypkg_plugins=${mypkg_plugins#,}

	mkdir -p ${D}${eclipse_home}
	chmod a+w ${D}${eclipse_home}
	ls -ld ${D}${eclipse_home}

	EANT_BUILD_TARGET="build"
	EANT_EXTRA_ARGS="-Declipse.home=${eclipse_home} \
			-Declipse.local=${D}${eclipse_home} \
			-Dplugins=${mypkg_plugins}"
	EANT_EXTRA_ARGS_INSTALL="-Declipse.home=${D}${eclipse_home} \
			-Dplugins=${mypkg_plugins} \
			-Dvim.files=${D}/usr/share/vim/vimfiles"

	chmod u+x ${S}/org.eclim/nailgun/configure
}

src_install() {
	eant ${EANT_EXTRA_ARGS_INSTALL} deploy

	dosym "${eclipse_home}"/plugins/org.${MY_P}/bin/eclimd \
			/usr/bin/eclimd || die "symlink failed"
	dosym "${eclipse_home}"/plugins/org.${MY_P}/bin/eclim \
			"${eclipse_home}"/eclim || die "symlink failed"
}
