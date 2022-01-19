# Defined in /home/mdes/.config/fish/functions/get_fisher.fish @ line 1
function get_fisher
	if not functions -q fisher
		set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
		curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
		fish -c fisher
	end
end
