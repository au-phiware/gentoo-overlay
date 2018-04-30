# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A shell implementation of the Procfile format"
HOMEPAGE="https://chrismytton.github.io/shoreman/"
EGIT_REPO_URI="https://github.com/chrismytton/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

src_install() {
	newbin "${S}/shoreman.sh" shoreman
}
