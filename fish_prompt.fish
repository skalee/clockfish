function fish_prompt --description "Write out the prompt"

	set -l pretty_clock (
		printf "%s%s" (set_color cyan) (date +%H:%M))

	set -l pretty_me (
		printf "%s%s" (set_color normal) (whoami))

	set -l pretty_path (
		printf "%s%s" (set_color $fish_color_cwd) (prompt_pwd))

	# symbolic-ref will display current branch even in empty repo
	# whereas name-ref returns useful output even in a detached state
	set -l git_rev_name (
		env git symbolic-ref --short HEAD 2>/dev/null
		or env git name-rev --name-only HEAD 2>/dev/null)

	# Pretty ref name with a leading space or empty string
	set -l pretty_git_ref (
		if test -n "$git_rev_name" # if in Git
			env git diff --quiet 2>/dev/null
			and env git diff --quiet --cached 2>/dev/null
			and set -l git_clean "yes"

			if test -z "$git_clean" # if Git dirty
				printf " %s%s" (set_color red) (echo $git_rev_name)
			else
				printf " %s%s" (set_color blue) (echo $git_rev_name)
			end
		end)

	printf "%s %s %s%s%s>" \
		$pretty_clock \
		$pretty_me \
		$pretty_path \
		$pretty_git_ref \
		(set_color normal)

end
