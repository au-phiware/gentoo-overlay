# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Run azure-cli tool in a docker container"
MERGE_TYPE=binary

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="bash-completion"

DEPEND="app-emulation/docker"
RDEPEND="docker-image/docker-bin $DEPEND"

pkg_preinst() {
	MY_PV=$PV
	[[ "${PV}" == "9999" ]] && MY_PV=latest

	docker build -t az -f - /var/empty <<- Dockerfile
		FROM microsoft/azure-cli:${MY_PV}

		ENTRYPOINT ["az"]
		CMD [""]

		RUN apk add --no-cache docker
Dockerfile

	dosym docker-bin /usr/bin/az

	if use bash-completion; then
		docker run --entrypoint /bin/cat az /azure-cli/az.completion > "${T}/bash-completion"
		insinto /usr/share/bash-completion/completions
		newins "${T}/bash-completion" az
	fi
}
