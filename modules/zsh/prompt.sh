# Prompt
## Custom Fields
function virtual_env_prompt () {
	REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }
}
grml_theme_add_token virtual-env -f virtual_env_prompt '%F{magenta}' '%f'
grml_theme_add_token host_full '%M ' '' ''
grml_theme_add_token existing-jobs '%(1j.[%j running job(s)].)' '%F{cyan}' '%f'

function calc_prompt_length () {
	items=(rc user at host_full path time date)
	count=0
	for item in ${items[@]}; do
		((count+=${#${(%)grml_prompt_token_default[$item]}}))
	done

	# VCS
	cleaned_vcs=`echo $vcs_info_msg_0_ | sed -e 's/%F{[^}]*}//g' -e 's/%f//g'`
	((count+=${#cleaned_vcs}))

	# Virtual env
	((count+=${#${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }}))
	echo $count
}

function gen_spaces () {
	space_length=$1
	if [ $space_length -lt 0 ]; then
		space_length=0
	fi

	spaces=""
	for _ in `seq $space_length`; do
		spaces+=" "
	done
	echo $spaces
}

function gen_padding () {
	prompt_length=$(calc_prompt_length)
	((space_length=$COLUMNS-$prompt_length))
	REPLY=$(gen_spaces $space_length)
}

grml_theme_add_token padding -f gen_padding '' ''

zstyle ':prompt:grml:*:items:user' pre '%F{red}'
zstyle ':prompt:grml:*:items:host_full' pre '%F{cyan}'
zstyle ':prompt:grml:*:items:path' pre '%F{yellow}'
zstyle ':prompt:grml:*:items:percent' pre '%f'
zstyle ':prompt:grml:left:setup' items user at host_full path virtual-env vcs padding time date newline rc percent
zstyle ':prompt:grml:right:setup' items shell-level existing-jobs sad-smiley
