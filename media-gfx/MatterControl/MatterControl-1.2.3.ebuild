# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit mono git-r3

DESCRIPTION="From easy to expert, all in one 3D printing software."
HOMEPAGE="http://www.mattercontrol.com/"
EGIT_REPO_URI="https://github.com/MatterHackers/MatterControl.git"
EGIT_BRANCH="${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="conf-debug conf-debug64 conf-release"
#    conf-release64 \
#    platform-any platform-mixed platform-x86 platform-x64 \
REQUIRED_USE="( || ( !conf-release ^^ ( conf-debug conf-debug64 conf-release ) ) )"
#    ( || ( !platform-any ^^ ( platform-any platform-mixed platform-x86 platform-x64 ) ) ) \

RDEPEND=">=dev-lang/mono-3.0.7
	dev-util/monodevelop
	media-libs/libcanberra[gtk]"
DEPEND="dev-util/monodevelop"

pkg_setup() {
    export MATTERCONTROL_CHECKOUT_DIR="${EGIT_CHECKOUT_DIR:-${WORKDIR}/${P}}"
}

src_unpack() {
    git-r3_src_unpack
    git -C "${MATTERCONTROL_CHECKOUT_DIR}" submodule update --init --recursive
}

src_prepare() {
    mozroots --import --sync
    cd "${MATTERCONTROL_CHECKOUT_DIR}"
    mono "${MATTERCONTROL_CHECKOUT_DIR}"/.nuget/NuGet.exe restore "${MATTERCONTROL_CHECKOUT_DIR}"/MatterControl.sln
}

src_compile() {
    local -a BUILD_ARGS
    if use conf-debug
    then
        BUILD_ARGS+="/property:Configuration=Debug"
    elif use conf-debug64
    then
        BUILD_ARGS+="/property:Configuration=Debug64"
#    elif use conf-release64
#    then
#        BUILD_ARGS+="/property:Configuration=Release64"
    else
        BUILD_ARGS+="/property:Configuration=Release"
    fi
#    if use platform-any
#    then
#        BUILD_ARGS+="/property:Platform=Any CPU"
#    elif use platform-mixed
#    then
#        BUILD_ARGS+="/property:Platform=Mixed Platforms"
#    elif use platform-x86
#    then
#        BUILD_ARGS+="/property:Platform=x86"
#    elif use platform-x64
#    then
#        BUILD_ARGS+="/property:Platform=x64"
#    fi
    xbuild ${BUILD_ARGS[@]} "${MATTERCONTROL_CHECKOUT_DIR}"/MatterControl.sln
}

src_install() {
    local CONFIGURATION
    local PLATFORM
    if use conf-debug
    then
	CONFIGURATION="Debug"
    elif use conf-debug64
    then
	CONFIGURATION="Debug"
#    elif use conf-release64
#    then
#	CONFIGURATION="Release64"
    else
	CONFIGURATION="Release"
    fi
    dobin "${FILESDIR}/${PN}"
    dodir /usr/lib/"${PN}"/bin
    cp -R "${MATTERCONTROL_CHECKOUT_DIR}/bin/${CONFIGURATION}" "${D}/usr/lib/${PN}/bin"
    cp -R "${MATTERCONTROL_CHECKOUT_DIR}"/StaticData "${D}/usr/lib/${PN}/"
}
