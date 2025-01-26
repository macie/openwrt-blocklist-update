#!/bin/sh
# <https://github.com/macie/openwrt-blocklist-update>
# SPDX-License-Identifier: 0BSD
set -eu

BLOCKLIST_URL="$1"
# https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.plus.mini-onlydomains.txt
# https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/ultimate-onlydomains.txt

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
    echo "$DEST"
}

prepare_blocklist_stats() {
    SRC_FILE="$1"

    DEST_FILE="${SRC_FILE}_stats.tsv"

    <"$SRC_FILE" awk 'BEGIN{srand(); OFS="\t"} {print length, rand(), $0}' >"$DEST_FILE"
    printf '# Created intermediate table [ DOMAIN_LEN | RANDOM_NO | DOMAIN ]\n' >&2

    printf 'Blocklist %s\n' "$(basename "$SRC_FILE")"
    printf 'domains only: %s file with %s lines (longest line: %s characters)\n' "$(du -h "$SRC_FILE" | cut -f1)" "$(wc -l <"$DEST_FILE")" "$(sort -rn <"$DEST_FILE" | head -1 | cut -f1)"
}

benchmark_packing() {
    FILENAME="$1"
    DOMAINS_PER_LINE="$2"

    # shellcheck disable=SC2016
    PACK_RULES='NR % PER_LINE == 1 {printf "local=/"} {printf "%s/", $0} NR % PER_LINE == 0 {print ""; next} END {if (NR % PER_LINE != 0) print ""}' 
    if [ "$DOMAINS_PER_LINE" -eq 1 ] ; then
        # shellcheck disable=SC2016
        PACK_RULES='{ printf "local=/%s/\n", $0 }'
    fi

    STATS_FILE="${FILENAME}_stats.tsv"
    printf 'dnsmasq format with %s domains per line:\n' "$DOMAINS_PER_LINE"
    <"$STATS_FILE" cut -f3 | awk -v PER_LINE="$DOMAINS_PER_LINE" "$PACK_RULES" | awk 'BEGIN{OFS="\t"} {print length, $0}' | sort -rn | cut -f2 >"${FILENAME}-dnsmasq_packed_sorted"
    printf ' - original order: %s file with %s lines (longest line: %s characters)\n' "$(du -h "${FILENAME}-dnsmasq_packed_sorted" | cut -f1)" "$(wc -l <"${FILENAME}-dnsmasq_packed_sorted")" "$(head -1 <"${FILENAME}-dnsmasq_packed_sorted" | wc --chars)"
    <"$STATS_FILE" sort -k1 -n | cut -f3 | awk -v PER_LINE="$DOMAINS_PER_LINE" "$PACK_RULES" | awk 'BEGIN{OFS="\t"} {print length, $0}' | sort -rn | cut -f2 >"${FILENAME}-dnsmasq_packed_sorted"
    printf ' - descending order: %s file with %s lines (longest line: %s characters)\n' "$(du -h "${FILENAME}-dnsmasq_packed_sorted" | cut -f1)" "$(wc -l <"${FILENAME}-dnsmasq_packed_sorted")" "$(head -1 <"${FILENAME}-dnsmasq_packed_sorted" | wc --chars)"
    <"$STATS_FILE" sort -k2 -n | cut -f3 | awk -v PER_LINE="$DOMAINS_PER_LINE" "$PACK_RULES" | awk 'BEGIN{OFS="\t"} {print length, $0}' | sort -rn | cut -f2 >"${FILENAME}-dnsmasq_packed_sorted"
    printf ' - random order: %s file with %s lines (longest line: %s characters)\n' "$(du -h "${FILENAME}-dnsmasq_packed_sorted" | cut -f1)" "$(wc -l <"${FILENAME}-dnsmasq_packed_sorted")" "$(head -1 <"${FILENAME}-dnsmasq_packed_sorted" | wc --chars)"
}

#
# MAIN
#
BLOCKLIST_NAME=$(download_clean_blocklist "$BLOCKLIST_URL")

prepare_blocklist_stats "$BLOCKLIST_NAME"

for DOMAINS_PER_LINE in 1 2 3 4 5 6 7 8 9 10; do
    benchmark_packing "$BLOCKLIST_NAME" "$DOMAINS_PER_LINE"
done
