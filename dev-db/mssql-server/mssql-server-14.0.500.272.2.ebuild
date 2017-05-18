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
RDEPEND="${DEPEND} >=dev-libs/openssl-1.0.1 <dev-libs/openssl-1.1.0 sys-process/numactl app-arch/bzip2 sys-auth/sssd"

S="${WORKDIR}"

pkg_config() {
	if use zfs
	then
		einfo "ZFS is not supported. Let's make an ext4 filesystem in a zvol!"
		read -p "Enter name of new zvol: " zvolname
		read -p "Enter size of new zvol: " zvolsize
		zfs create -s -V $zvolsize $zvolname
		echo ",,L" | sfdisk /dev/zvol/$zvolname
		mkfs.ext4 /dev/zvol/${zvolname}-part1
		echo "/dev/zvol/${zvolname}-part1 /var/opt/mssql ext4          noatime         0 0" >> /etc/fstab
		mkdir /var/opt/mssql
		mount /var/opt/mssql
	fi

	if [ -f "${ROOT%/}"/var/opt/mssql/data/master.mdf ]
	then
		einfo "It appears that the master database already exists."
	else
		"${ROOT%/}"/opt/mssql/bin/mssql-conf setup
	fi
}

src_install() {
	cp -a opt "${D}" || die
	cp -a usr "${D}" || die
}
