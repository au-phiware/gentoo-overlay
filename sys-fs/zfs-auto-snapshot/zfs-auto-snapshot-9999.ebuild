# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Automatic snapshots for ZFS on Linux"
HOMEPAGE="https://github.com/zfsonlinux/zfs-auto-snapshot/"
EGIT_REPO_URI="https://github.com/jakelee8/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="+systemd"

DEPEND="sys-fs/zfs
	systemd? ( sys-apps/systemd )
	!systemd? ( virtual/cron )"
RDEPEND="${DEPEND}"

DOCS=( README.md )

src_unpack() {
	use systemd && EGIT_BRANCH=systemd
	git-r3_src_unpack
}

src_install() {
	use systemd && mkdir -p "${D}"/usr/lib/systemd/system
	emake DESTDIR="${D}" PREFIX=/usr install

	if use systemd
	then
		sed -i "s/\(\/usr\)\/local/\1/" ${D}/usr/lib/systemd/system/* || die
	else
		fperms a-x /etc/cron.d/${PN}
	fi

	einstalldocs
}

pkg_postinst() {
	use systemd && systemctl enable --now zfs-auto-snapshot.target
	elog "Use the attribute com.sun:auto-snapshot to choose which datasets to"
	elog "snapshot."
	elog
	elog "E.g."
	elog "    zfs set com.sun:auto-snapshot=false rpool"
	elog "    zfs set com.sun:auto-snapshot=true rpool"
	elog "    zfs set com.sun:auto-snapshot:weekly=true rpool"
	elog
	if ! use systemd
	then
		ewarn "If you are using fcron as system crontab. frequent snapshot may not"
		ewarn "work. You should add below setting to job list by execute"
		ewarn "'fcrontab -e' manually:"
		ewarn "*/15 * * * * zfs-auto-snapshot -q -g --label=frequent --keep=4  //"
		elog
	fi
}

