# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit qmake-utils git-r3 systemd

DESCRIPTION="A notification system for tiling window managers."
HOMEPAGE="https://github.com/sboli/twmn"
EGIT_REPO_URI="https://github.com/sboli/twmn.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="systemd"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtx11extras:5
	dev-libs/boost
	sys-apps/dbus
	systemd? ( sys-apps/systemd )
	"
RDEPEND="${DEPEND}"

DOCS=( TODO README.md )

src_prepare() {
	eapply_user
	sed -i -e "s#/usr/local/#${EPREFIX}/#g" */*.pro
}

src_install() {
	eqmake5
	use systemd && systemd_dounit "${S}/init/systemd/twmnd.service"
	einstalldocs
}

pkg_postinst() {
	use systemd && systemctl enable --now twmnd.service
}
