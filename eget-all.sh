#!/bin/bash

: "${EGET_CONFIG_DIR:=${XDG_CONFIG_HOME:-$HOME/.config}/eget}"
: "${EGET_CONFIG_FILE:=${EGET_CONFIG_DIR}/packages}"
: "${EGET_TOKEN_FILE:=${EGET_CONFIG_DIR}/github_token}"
: "${EGET_TARGET_DIR:=${HOME}/lib/eget/bin}"

usage() {
	echo "${0##*/}: usage: ${0##*/} [ -f <config_file> ] [ -t <target_dir> ] [ -T <token_file> ] [ <pattern> ]"
}

log() {
	echo "${0##*/}: $1" >&2
}

warn() {
	log "WARNING: $1"
}

error() {
	log "ERROR: $1"
}

die() {
	error "$1"
	exit 1
}

while getopts f:t:T: ch; do
	case $ch in
		f)	EGET_CONFIG_FILE=$OPTARG
			;;

		t)	EGET_TARGET_DIR=$OPTARG
			;;

		T)	EGET_TOKEN_FILE=$OPTARG
			;;

		*)	usage >&2
			exit 2
			;;
	esac
done
shift "$(( OPTIND - 1 ))"

[[ -d "$EGET_TARGET_DIR" ]] ||
	die "target directory \"$EGET_TARGET_DIR\" does not exist"

[[ -f "$EGET_CONFIG_FILE" ]] ||
	die "config file \"$EGET_CONFIG_FILE\" does not exist"

set -e

if [[ -z "$GITHUB_TOKEN" ]] && [[ -z "$EGET_GITHUB_TOKEN" ]]; then
	if [[ -f "$EGET_TOKEN_FILE" ]]; then
		EGET_GITHUB_TOKEN=$(< "$EGET_TOKEN_FILE")
		export EGET_GITHUB_TOKEN
	else
		warn "unable to authenticate to github (reduced API limits)"
	fi
fi

mapfile -t packages < <(grep -vE '^$|^#' "$EGET_CONFIG_FILE" | grep "${1:-.}")

cd "$EGET_TARGET_DIR"

for pkgspec in "${packages[@]}"; do
	eval "pkg=( $pkgspec )"
	# shellcheck disable=SC2154
	log "installing ${pkg[0]}"
	eget --upgrade-only "${pkg[@]}" < /dev/null
done
