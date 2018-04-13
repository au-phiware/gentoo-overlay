# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/setuptools/setuptools-9999.ebuild,v 1.1 2013/01/11 09:59:31 mgorny Exp $
EAPI="5"

# Enforce Bash scrictness.
set -e

EGIT_REPO_URI="https://github.com/ryanoasis/nerd-fonts"

inherit eutils font git-r3

DESCRIPTION="Iconic font collection"
HOMEPAGE="https://nerdfonts.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 x86-fbsd"

# src_install() expects USE flags to be the lowercase basenames of the
# corresponding font directories. See src_install_font() for details.
IUSE_FLAGS=(
	3270
	anonymouspro
	arimo
	aurulentsansmono
	bigblueterminal
	bitstreamverasansmono
	blex
	codenewroman
	cousine
	dejavusansmono
	droidsansmono
	fantasquesansmono
	firacode
	firamono
	go-mono
	gohu
	hack
	hasklig
	heavydata
	hermit
	inconsolata
	inconsolatago
	inconsolatalgc
	iosevka
	lekton
	liberationmono
	mplus
	meslo
	monofur
	monoid
	mononoki
	noto
	opendyslexic
	overpass
	profont
	proggyclean
	robotomono
	sharetechmono
	sourcecodepro
	spacemono
	terminus
	tinos
	ubuntu
	ubuntumono
)
IUSE="otf ttf single windows complete minimal all ${IUSE_FLAGS[*]}"

# If no such USE flags were enabled, fail.
REQUIRED_USE="?? ( otf ttf ) ?? ( complete minimal ) ^^ ( all || ( ${IUSE_FLAGS[*]} ) )"

DEPEND="$DEPEND sys-apps/findutils app-shells/bash"
#RDEPEND=""

# Temporary directory to which all fonts to be installed will be copied.
# Ideally, such fonts could simply be installed from their default directories;
# sadly, eclass "font" assumes such fonts always reside in a single directory.
FONT_S="${T}"
FONT_PN=NerdFonts

src_prepare() {
	epatch "${FILESDIR}/distdir.patch"
}

src_install() {
	local arg=""

	use ttf && arg="--ttf"
	use otf && arg="--otf"
	use single && arg="$arg -s"
	use windows && arg="$arg -w"
	use "complete" && arg="$arg -A" 
	use "minimal" && arg="$arg -M" 

	export FONT_S
	mkdir -p "${FONT_S}"
	rm -rf "${FONT_S}/*"

	# Copy all fonts in the passed directory to a
	# temporary directory for subsequent installation if the corresponding USE
	# flag is enabled or return silently otherwise.
	src_install_font() {
		(( ${#} == 1 )) || die 'Expected one dirname.'
		local dirname="${1}" flag_name
		flag_name="${dirname,,}"
		flag_name="${flag_name// /}"

		if use "${flag_name}" || usev all; then
			einfo Installing $dirname...
			( "${S}"/install.sh --copy -S $arg "${dirname}" )
		fi
	}

	# Copy all fonts to be installed to a temporary directory.
	src_install_font 3270
	src_install_font AnonymousPro
	src_install_font Arimo
	src_install_font AurulentSansMono
	src_install_font BigBlueTerminal
	src_install_font BitstreamVeraSansMono
	src_install_font Blex
	src_install_font CodeNewRoman
	src_install_font Cousine
	src_install_font DejaVuSansMono
	src_install_font DroidSansMono
	src_install_font FantasqueSansMono
	src_install_font FiraCode
	src_install_font FiraMono
	src_install_font Go-Mono
	src_install_font Gohu
	src_install_font Hack
	src_install_font Hasklig
	src_install_font HeavyData
	src_install_font Hermit
	src_install_font Inconsolata
	src_install_font InconsolataGo
	src_install_font InconsolataLGC
	src_install_font Iosevka
	src_install_font Lekton
	src_install_font LiberationMono
	src_install_font MPlus
	src_install_font Meslo
	src_install_font Monofur
	src_install_font Monoid
	src_install_font Mononoki
	src_install_font Noto
	src_install_font OpenDyslexic
	src_install_font Overpass
	src_install_font ProFont
	src_install_font ProggyClean
	src_install_font RobotoMono
	src_install_font ShareTechMono
	src_install_font SourceCodePro
	src_install_font SpaceMono
	src_install_font Terminus
	src_install_font Tinos
	src_install_font Ubuntu
	src_install_font UbuntuMono

	# Convert the above map of all font filetypes to be installed into the
	# whitespace-delimited string global accepted by eclass "font".
	FONT_S="${FONT_S}/${FONT_PN}"
	FONT_SUFFIX=""
	for suffix in otf ttf pcf.gz; do
		[ -n "$(find "${FONT_S}" -name '*.'$suffix)" ] && FONT_SUFFIX="$FONT_SUFFIX $suffix"
	done

	# Install all such fonts.
	font_src_install
}
