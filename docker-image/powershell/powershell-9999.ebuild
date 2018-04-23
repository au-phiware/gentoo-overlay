# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Run powershell in a docker container"
MERGE_TYPE=binary

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-emulation/docker"
RDEPEND="docker-image/docker-bin $DEPEND"

pkg_preinst() {
	MY_PV=$PV
	[[ "${PV}" == "9999" ]] && MY_PV=latest

	docker build -t pwsh -f - /var/empty <<- Dockerfile
		FROM microsoft/powershell:${MY_PV}

		ENTRYPOINT ["pwsh"]
		CMD [""]
		Dockerfile

	dosym docker-bin /usr/bin/pwsh
}
