# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Run any tool in a docker container"
MERGE_TYPE=binary

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-apps/coreutils app-emulation/docker"
DEPEND=""

pkg_preinst() {
	newbin "$FILESDIR/docker-bin-${PV}" "docker-bin"
}
