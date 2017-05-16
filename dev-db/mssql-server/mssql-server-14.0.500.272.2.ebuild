# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator rpm

MY_PV=$(replace_version_separator 4 '-')
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Microsoft SQL Server on Linux"
HOMEPAGE="https://docs.microsoft.com/en-us/sql/linux"
SRC_URI="https://packages.microsoft.com/rhel/7/mssql-server/${MY_P}.x86_64.rpm"

LICENSE="mssql-server-preview-eula"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# RPM depends on:
#   openssl < 1:1.1.0
#   openssl >= 1:1.0.1
#   bzip2
#   numactl-libs
#   gdb
#   libsss_nss_idmap
DEPEND=""
RDEPEND="${DEPEND} >=dev-libs/openssl-1.0.1 <dev-libs/openssl-1.1.0 sys-process/numactl dev-libs/nss app-arch/bzip2 sys-auth/sssd"

S="${WORKDIR}"

pkg_config() {
	if [ -d "${ROOT%/}"/var/opt/mssql/data ]
	then
		einfo "It appears that the mssql database already exists."
	else
		"${ROOT%/}"/opt/mssql/bin/mssql-conf setup
	fi
}

src_install() {
	cp -a opt "${D}" || die
	cp -a usr "${D}" || die
}
