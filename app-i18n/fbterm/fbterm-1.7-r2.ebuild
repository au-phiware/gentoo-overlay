EAPI="5"
inherit autotools-utils

DESCRIPTION="Fast terminal emulator for the Linux framebuffer"
HOMEPAGE="http://fbterm.googlecode.com/"
SRC_URI="https://github.com/au-phiware/fbterm/archive/${P}.0-${PR}.tar.gz"
S="${WORKDIR}/${PN}-${P}.0-${PR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="caps gpm video_cards_vesa solarized-dark solarized-light"

RDEPEND="caps? ( sys-libs/libcap )
	gpm? ( sys-libs/gpm )
	video_cards_vesa? ( dev-libs/libx86 )
	media-libs/fontconfig
	media-libs/freetype:2"
DEPEND="${RDEPEND}
	sys-libs/ncurses
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( AUTHORS NEWS README )

src_configure() {
	local myeconfargs=(
		$(use_enable gpm)
		$(use_enable video_cards_vesa vesa)
		$(use solarized-light && echo "--enable-solarized=light")
		$(use solarized-dark && echo "--enable-solarized=dark")
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	$(type -P tic) -o "${ED}/usr/share/terminfo/" \
		"${S}"/terminfo/fbterm || die "Failed to generate terminfo database"
	if use caps; then
		setcap "cap_sys_tty_config+ep" "${ED}"/usr/bin/fbterm
	else
		fperms u+s /usr/bin/fbterm
	fi
}

pkg_postinst() {
	einfo
	einfo " ${PN} won't work with vga16fb. You have to use other native"
	einfo " framebuffer drivers or vesa driver."
	einfo " See ${EPREFIX}/usr/share/doc/${P}/README for details."
	einfo " To use ${PN}, ensure you are in video group."
	einfo " To input CJK merge app-i18n/fbterm-ucimf"
	einfo
}
