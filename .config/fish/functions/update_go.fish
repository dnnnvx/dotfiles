function update_go
	if type -q go
		set curr_v (go version | grep -Eo 'go[0-9\.]+') # grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?'
		echo "Current version is: $curr_v"
		echo -ne "Fetching latest version... "
		set remote_v (curl -s "https://golang.org/dl/?mode=json" | jq -r '.[0].files[].version' | uniq)
		echo "found: $remote_v"
		if [ $curr_v = $remote_v ]
			echo "Up to date!"
    else
			while true
				read -p 'echo -n "An update is available! Continue? [y/n]: "' -l confirm
				switch $confirm
					case Y y
						cd /tmp
						curl "https://dl.google.com/go/$remote_v.linux-amd64.tar.gz" | tar xz
						if test /tmp/go
							mv /usr/local/go "/tmp/$curr_v"
							mv ./go/ /usr/local/
							cd -
							echo "Updated!"
						else
							echo "Download Failed :("
						end
						return 0
					case '' N n
						return 1
				end
			end
		end
	end
end
