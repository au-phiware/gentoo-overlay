# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit mono git-r3

DESCRIPTION="From easy to expert, all in one 3D printing software."
HOMEPAGE="http://www.mattercontrol.com/"
EGIT_REPO_URI="https://github.com/MatterHackers/MatterControl.git"
EGIT_BRANCH="master"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND=">=dev-lang/mono-3.0.7
	dev-util/monodevelop
	media-libs/libcanberra[gtk]"
DEPEND="dev-util/monodevelop"

pkg_setup() {
    export MATTERCONTROL_CHECKOUT_DIR="${EGIT_CHECKOUT_DIR:-${WORKDIR}/${P}}"
	if use debug; then
		export MATTERCONTROL_CONFIGURATION=Debug
	else
		export MATTERCONTROL_CONFIGURATION=Release64
	fi
	export MATTERCONTROL_PLATFORM=
}

src_unpack() {
    git-r3_src_unpack
    git -C "${MATTERCONTROL_CHECKOUT_DIR}" submodule update --init --recursive
}

src_prepare() {
    mozroots --import --sync
    mono "${MATTERCONTROL_CHECKOUT_DIR}"/.nuget/NuGet.exe restore "${MATTERCONTROL_CHECKOUT_DIR}"/MatterControl.sln
}

src_compile() {
    #xbuild /property:Configuration=${MATTERCONTROL_CONFIGURATION} /property:Platform=${MATTERCONTROL_PLATFORM} "${MATTERCONTROL_CHECKOUT_DIR}"/MatterControl.sln
    xbuild /property:Configuration=${MATTERCONTROL_CONFIGURATION} "${MATTERCONTROL_CHECKOUT_DIR}"/MatterControl.sln
}

src_install() {
    dobin "${FILESDIR}/${PN}"
    dodir /usr/lib/"${PN}"/bin
    cp -R "${MATTERCONTROL_CHECKOUT_DIR}"/bin/${MATTERCONTROL_PLATFORM%AnyCPU}/${MATTERCONTROL_CONFIGURATION} "${D}/usr/lib/${PN}/bin"
    cp -R "${MATTERCONTROL_CHECKOUT_DIR}"/StaticData "${D}/usr/lib/${PN}/"
}
