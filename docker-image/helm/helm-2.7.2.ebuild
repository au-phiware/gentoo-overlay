# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Run azure-cli tool in a docker container"
MERGE_TYPE=binary

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="zsh-completion bash-completion"

DEPEND="app-emulation/docker"
RDEPEND="docker-image/docker-bin $DEPEND"

pkg_preinst() {
	MY_PV=$PV
	[[ "${PV}" == "9999" ]] && MY_PV=latest

	image="linkyard/docker-helm:${MY_PV}"
	docker pull "${image}"
	docker tag "${image}" "${PN}"

	dosym docker-bin "/usr/bin/${PN}"

	if use zsh-completion; then
		docker run "${PN}" completion zsh > "${T}/zsh-completion"
		insinto /usr/share/zsh/site-functions
		newins "${T}/zsh-completion" "_${PN}"
	elif use bash-completion; then
		docker run "${PN}" completion bash > "${T}/bash-completion"
		insinto /usr/share/bash-completion/completions
		newins "${T}/bash-completion" "${PN}"
	fi
}
