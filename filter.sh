#!/bin/sh



OUT=$(mysql -u ciprian -D imobiliare -e "select link from olx;" | grep -iv "giroc\|sag\|dambovita\|freidorf\|fraidorf\|iosefin\|mansarda\|dumbravita\|braytim\|link\|braitym\|steaua\|mosnita\|mu[sz]icescu\|soarelui\|buziasului\|fabric\|[dD]ambovita")


OUT_FILT=$( echo "$OUT" | awk -F"#" '{print $1}' | sort  | uniq )

echo "$OUT_FILT"
