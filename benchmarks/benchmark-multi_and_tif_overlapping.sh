#!/bin/sh
# <https://github.com/macie/openwrt-blocklist-update>
# SPDX-License-Identifier: 0BSD
set -eu

BLOCKLIST_URLS=$(cat <<EOF
    https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif-onlydomains.txt
    https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif.mini-onlydomains.txt
    https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif.medium-onlydomains.txt
    https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.mini-onlydomains.txt
    https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.plus.mini-onlydomains.txt
EOF
)

TEMPDIR="$(mktemp -d)"
trap 'rm -rf "${TEMPDIR}"' EXIT

download_clean_blocklist() {
    URL="$1"

    SRC_FILE="${URL##*/}"
    BLOCKLIST_NAME="${SRC_FILE%%.txt}"
    printf '# Download %s into' "$URL" >&2
    curl -qsL "$URL" >"${TEMPDIR}/blocklist.raw" || exit 1
    VER=$(grep '# Version:' <"${TEMPDIR}/blocklist.raw" | cut -f3 -d' ')
    DEST="${TEMPDIR}/${BLOCKLIST_NAME}-${VER}"
    grep -v '[#|\/|=]' <"${TEMPDIR}/blocklist.raw" >"$DEST"
    printf ' %s\n' "$DEST" >&2
    rm "${TEMPDIR}/blocklist.raw"
    echo "$DEST"
}

print_blocklist_stats() {
    SRC_FILE="$1"

    printf 'Blocklist %s: %s file with %s lines\n' "$(basename "$SRC_FILE")" "$(du -h "$SRC_FILE" | cut -f1)" "$(wc -l <"$SRC_FILE")"
}


#
# MAIN
#
for URL in $BLOCKLIST_URLS ; do
    BLOCKLIST_NAME=$(download_clean_blocklist "$URL")
    print_blocklist_stats "$BLOCKLIST_NAME"
done


printf '\nDups\tTIF_No\tMulti_No\tTIF\tMulti\n'
for MULTI_FILE in "${TEMPDIR}"/[!tif]* ; do
    for TIF_FILE in "${TEMPDIR}"/tif* ; do
        printf '%s\t%s\t%s\t%s\t%s\n'  "$(cat "${MULTI_FILE}" "${TIF_FILE}" | sort | uniq -d | wc -l)" "$(<"${TIF_FILE}" wc -l)" "$(<"${MULTI_FILE}" wc -l)" "$(basename "${TIF_FILE}")" "$(basename "${MULTI_FILE}")"
    done
done

