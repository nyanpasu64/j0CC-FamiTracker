#!/bin/bash
shopt -s globstar nullglob nocaseglob

recase() {
	headers=( **/*.h )

	echo ${#headers[*]} headers
	if [[ ${#headers[*]} -eq 0 ]]; then
		return
	fi
	# echo "${headers[*]}"

	regex=""
	for header in "${headers[@]}"; do
		header=`basename "$header"`
		regex+=';s%(#include "[^"]*)'"$header"'"%\1'"$header"'"%gI'
	done
	regex="${regex:1}"
	echo "$regex"

	find . -type f \( -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' \) -print0 | \
		xargs -0 sed -ri "$regex"
}

recase

# while IFS= read -r -d '' d; do
# 	echo $d
# 	pushd $d >/dev/null
# 	recase
# 	popd >/dev/null
# 	echo
# done < <(find . -type d -not -path '*/\.*' -print0)
