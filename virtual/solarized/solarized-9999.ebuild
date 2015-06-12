# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit git-2

DESCRIPTION="Precision colors for machines and people"
HOMEPAGE="http://ethanschoonover.com/solarized"
EGIT_REPO_URI="https://github.com/altercation/solarized.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="solarized-dark solarized-light X grub"

src_configure() {
	local theme
	local nottheme
	if use solarized-dark
	then
		theme=dark
		nottheme=light
	elif use solarized-light
	then
		theme=light
		nottheme=dark
	fi

	if use X
	then
sed -re "/^! $nottheme/I,/#define S_base3/s/^(! *)?/! /;/^! $theme/I,/#define S_base3/s/^! *#define/#define/" "${S}"/xresources/solarized > "${FILESDIR}"
	fi

	if use grub
	then
		if [ -f /etc/default/grub ]
		then
			cp /etc/default/grub "${FILESDIR}"/grub
			source "${FILESDIR}"/grub
			GRUB_CMDLINE_LINUX_DEFAULT=$(echo -n ${GRUB_CMDLINE_LINUX_DEFAULT} | sed 's/vt\.default_\(red\|grn\|blu\)=[^ ]*\( \|$\)//g')
			echo -n 'GRUB_CMDLINE_LINUX_DEFAULT="' >> "${FILESDIR}"/grub
			if [ x"${GRUB_CMDLINE_LINUX_DEFAULT}" != x ]
			then
				echo -n "$GRUB_CMDLINE_LINUX_DEFAULT " >> "${FILESDIR}"/grub
			fi
		else
			echo -n 'GRUB_CMDLINE_LINUX_DEFAULT="' > "${FILESDIR}"/grub
		fi
		if use solarized-dark
		then
			echo 'vt.default_red=0x07,0xdc,0x85,0xb5,0x26,0xd3,0x2a,0xee,0x00,0xcb,0x58,0x65,0x83,0x6c,0x93,0xfd vt.default_grn=0x36,0x32,0x99,0x89,0x8b,0x36,0xa1,0xe8,0x2b,0x4b,0x6e,0x7b,0x94,0x71,0xa1,0xf6 vt.default_blu=0x42,0x2f,0x00,0x00,0xd2,0x82,0x98,0xd5,0x36,0x16,0x75,0x83,0x96,0xc4,0xa1,0xe3"' >> "${FILESDIR}"/grub
		elif use solarized-light
		then
			echo 'vt.default_red=0xee,0xdc,0x85,0xb5,0x26,0xd3,0x2a,0x07,0xfd,0xcb,0x93,0x83,0x65,0x6c,0x58,0x00 vt.default_grn=0xe8,0x32,0x99,0x89,0x8b,0x36,0xa1,0x36,0xf6,0x4b,0xa1,0x94,0x7b,0x71,0x6e,0x2b vt.default_blu=0xd5,0x2f,0x00,0x00,0xd2,0x82,0x98,0x42,0xe3,0x16,0xa1,0x96,0x83,0xc4,0x75,0x36"' >> "${FILESDIR}"/grub
		else
			echo '"' >> "${FILESDIR}"/grub
		fi
	fi
}

src_install() {
	if use solarized-dark || use solarized-light
	then
		if use grub
		then
			insinto /etc/default
			newins "${FILESDIR}"/grub grub
		fi
	fi
}
