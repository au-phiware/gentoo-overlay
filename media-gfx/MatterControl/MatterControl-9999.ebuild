# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit git-r3

DESCRIPTION="From easy to expert, all in one 3D printing software."
HOMEPAGE="http://www.mattercontrol.com/"
EGIT_REPO_URI="https://github.com/MatterHackers/MatterControl.git"
EGIT_BRANCH="master"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-3.0.7
	dev-util/monodevelop"
DEPEND="dev-util/monodevelop"

pkg_setup() {
    export MATTERCONTROL_CHECKOUT_DIR="${EGIT_CHECKOUT_DIR:-${WORKDIR}/${P}}"
}

src_unpack() {
    local plugin_uri
    plugin_uri="${EGIT_REPO_URI%.git}"Plugins.git
    git-r3_src_unpack
    git -C "${MATTERCONTROL_CHECKOUT_DIR}" submodule update --init --recursive
    git-r3_fetch "${plugin_uri}"
    git-r3_checkout "${plugin_uri}" "${MATTERCONTROL_CHECKOUT_DIR}"/../MatterControlPlugins
}

src_prepare() {
    mozroots --import --sync
    mono "${MATTERCONTROL_CHECKOUT_DIR}"/.nuget/NuGet.exe restore "${MATTERCONTROL_CHECKOUT_DIR}"/MatterControl.sln
}

src_compile() {
    xbuild /property:Configuration=Release "${MATTERCONTROL_CHECKOUT_DIR}"/MatterControl.sln
}

src_install() {
    dobin "${FILESDIR}/${PN}"
    dodir /usr/lib/"${PN}"/bin
    cp -R "${MATTERCONTROL_CHECKOUT_DIR}"/bin/Release "${D}/usr/lib/${PN}/bin"
    cp -R "${MATTERCONTROL_CHECKOUT_DIR}"/StaticData "${D}/usr/lib/${PN}/"
}
