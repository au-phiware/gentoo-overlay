# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit git-r3

DESCRIPTION="Command line utility for programming foot switches sold by PCsensor."
HOMEPAGE="https://github.com/rgerganov/footswitch"
EGIT_REPO_URI="https://github.com/rgerganov/footswitch.git"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/hidapi"
DEPEND="${RDEPEND}"

src_install() {
	dobin footswitch
	insinto /etc/udev/rules.d/
	doins 19-footswitch.rules 
	dodoc README.md
}
