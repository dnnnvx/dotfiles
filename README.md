# Void Desktop Setup

Dot 👽 Dot 🦎

## Next steps?

- https://github.com/siduck/chadwm
- https://github.com/NvChad/NvChad
- https://github.com/elkowar/eww

## Packages

> Update/upgrade all with `sudo xbps-install -Su`

### Base

| Package Name      | Description                         | Link                                                                                       |
|-------------------|-------------------------------------|--------------------------------------------------------------------------------------------|
| xorg-minimal      | Display server                      | [Github](https://github.com/freedesktop/xorg-xserver)                                      |
| xinit             | X server & client startup utilities | [Gitlab](https://gitlab.freedesktop.org/xorg/app/xinit)                                    |
| xf86-video-amdgpu | AMD Xorg video driver               | [Github](https://github.com/freedesktop/xorg-xf86-video-amdgpu)                            |
| base-devel        | Dev-tools meta package              | [Pkg](https://github.com/void-linux/void-packages/blob/master/srcpkgs/base-devel/template) |
| git               | Interactive process viewer          | [Github](https://github.com/git/git)                                                       |
| vim               | Terminal editor                     | [Github](https://github.com/vim/vim)                                                       |
| dbus              | IPC mechanism                       | [Github](https://github.com/freedesktop/dbus)                                              |
| tree              | List contents in a tree-like format | [Manpage](https://linux.die.net/man/1/tree)                                                |
| htop              | Interactive process viewer          | [Github](https://github.com/htop-dev/htop)                                                 |
| fish-shell        | Command line shell                  | [Github](https://github.com/fish-shell/fish-shell)                                         |
| pulseaudio        | Sound server                        | [Github](https://github.com/pulseaudio/pulseaudio)                                         |
| alacritty         | OpenGL terminal emulator            | [Github](https://github.com/alacritty/alacritty)                                           |
| docker            | Container ecosystem                 | [Github](https://github.com/moby/moby)                                                     |

### Tools

| Package Name | Description                              | Link                                                   |
|--------------|------------------------------------------|--------------------------------------------------------|
| ncdu         | Disk utilty                              | [Site](https://dev.yorhel.nl/ncdu)                     |
| bat          | Cat alternative                          | [Github](https://github.com/sharkdp/bat)               |
| hexyl        | TUI binary viewer                        | [Github](https://github.com/sharkdp/hexyl)             |
| hyperfine    | Command-line benchmarking tool           | [Github](https://github.com/sharkdp/hyperfine)         |
| shellcheck   | Static analysis tool for shell scripts   | [Github](https://github.com/koalaman/shellcheck)       |
| p7zip        | Command line version of 7zip             | [Sourceforge](https://sourceforge.net/projects/p7zip/) |
| tig          | Text-mode interface for git              | [Sourceforge](https://github.com/jonas/tig)            |
| parted       | Manipulate partition tables              | [Site](https://savannah.gnu.org/git/?group=parted)     |
| aws-cli      | Command Line Interface for AWS           | [Github](https://github.com/aws/aws-cli)               |
| vpm          | package management helper for Void Linux | [Github](https://github.com/netzverweigerer/vpm)       |
| termshark    | Terminal UI for tshark                   | [Github](https://github.com/gcla/termshark)            |
| mkpasswd     | Password generator                       | [Page](https://linux.die.net/man/1/mkpasswd)           |

### Applications & others

| Package Name        | Description                                  | Link                                                           |
|---------------------|----------------------------------------------|----------------------------------------------------------------|
| dejavu-fonts-ttf    | Dejavu font                                  | [Site](https://dejavu-fonts.github.io/)                        |
| noto-fonts-ttf      | Noto font                                    | [Site](https://www.google.com/get/noto/)                       |
| noto-fonts-emoji    | Noto emoji font                              | [Site](https://www.google.com/get/noto/)                       |
| fontconfig          | Font configuration and customization         | [Gitlab](https://gitlab.freedesktop.org/fontconfig/fontconfig) |
| chromium            | Chromium web browser                         | [Site](https://www.chromium.org/Home)                          |
| firefox             | Firefox web browser                          | [Site](https://www.mozilla.org/en-US/firefox/new/)             |
| vscode              | VS Code without branding/telemetry/licensing | [Github](https://github.com/VSCodium/vscodium)                 |
| lmms                | Music production software                    | [Github](https://github.com/LMMS/lmms)                         |
| obs                 | Live streaming and screen recording          | [Github](https://github.com/obsproject/obs-studio)             |
| blender             | 3D creation suite                            | [Github](https://github.com/blender/blender)                   |
| gimp                | Image editor                                 | [Site](https://www.gimp.org/)                                  |
| godot               | Game engine                                  | [Site](https://godotengine.org/)                               |
| synfigstudio        | 2D Animation Software                        | [Site](https://www.synfig.org/)                                |
| vlc                 | Media player                                 | [Gitlab](https://code.videolan.org/videolan/vlc)               |
| telegram-desktop    | Messaging app                                | [Github](https://github.com/telegramdesktop/tdesktop)          |
| paprefs             | Pulseaudio configs                           | [Site](https://freedesktop.org/software/pulseaudio/paprefs)    |
| wireshark           | Network traffic analyzer                     | [Github](https://github.com/wireshark/wireshark)               |

#### Add user to new groups and remove old packages

```console
$ sudo usermod -aG sudo,input,video,libvirt,docker,kvm $USER
$ sudo xbps-remove -Oo
```

## Other installations

| Tool                       | Description                         | Link                                                       |
|----------------------------|-------------------------------------|------------------------------------------------------------|
| Go                         | The Go programming language         | [Site](https://golang.org/dl/)                             |
| Brew                       | Brew package manager                | [Site](https://brew.sh/)                                   |
| Dart / Flutter             | Dart language and Flutter framework | [Site](https://flutter.dev/docs/get-started/install/linux) |
| Android Studio             | IDE                                 | [Site](https://developer.android.com/studio)               |
| Gitg                       | Gnome gui client git repositories   | [Site](https://wiki.gnome.org/Apps/Gitg/)                  |
| Ghex                       | Gnome hex editor                    | [Site](https://wiki.gnome.org/Apps/Ghex)                   |
| Vital Audio                | Spectral warping wavetable synth    | [Site](https://vital.audio/)                               |
| Fisher                     | Fish shell plugins                  | [Github](https://github.com/jorgebucaran/fisher)           |
| Fish-nvm                   | Node version manager                | [Github](https://github.com/jorgebucaran/fish-nvm)         |
| duf                        | Disk utility                        | [Github](https://github.com/muesli/duf)                    |
| fzf                        | Fuzzy finder                        | [Github](https://github.com/junegunn/fzf)                  |
| JetBrains Mono Font        | JetBrains font                      | [Site](https://www.jetbrains.com/lp/mono/)                 |
| Fira Code Mono (Nerd)      | Fira font (nerdfont version)        | [Site](https://www.nerdfonts.com/font-downloads)           |
| Go Mono (Nerd)             | Go font (nerdfont version)          | [Site](https://www.nerdfonts.com/font-downloads)           |
| Iosevka Font (SS12)        | Iosevka font                        | [Github](https://github.com/be5invis/Iosevka/releases)     |
| Atkinson Hyperlegible Font | Atkinson font                       | [Site](https://fontesk.com/atkinson-hyperlegible-font/)    |

## Brew installations

| Package Name                | Description                          | Link                                                  |
|-----------------------------|--------------------------------------|-------------------------------------------------------|
| minikube                    | Local k8s                            | [Github](https://github.com/kubernetes/minikube)      |
| octant                      | Kubernetes Web UI                    | [Github](https://github.com/vmware-tanzu/octant)      |
| kubespy                     | Observing k8s resources in real time | [Github](https://github.com/pulumi/kubespy)           |
| kind                        | K8s in docker                        | [Github](https://github.com/kubernetes-sigs/kind)     |
| k9s                         | Kubernetes CLI/TUI management        | [Github](https://github.com/derailed/k9s)             |
| FairwindsOps/tap/polaris    | K8s validations best practices       | [Github](https://github.com/FairwindsOps/polaris)     |
| aquasecurity/trivy/trivy    | Vulnerability scanner                | [Github](https://github.com/aquasecurity/trivy)       |
| lazydocker                  | Docker TUI management                | [Github](https://github.com/jesseduffield/lazydocker) |
| hadolint                    | Dockerfile linter                    | [Github](https://github.com/hadolint/hadolint)        |
| go-task/tap/go-task         | Task runner (make alternative)       | [Github](https://github.com/vmware-tanzu/octant)      |
| aws-sam-cli                 | AWS Serverless CLI                   | [Github](https://github.com/aws/aws-sam-cli)          |
| mitmproxy                   | Web Traffic inspector (TUI & Web UI) | [Github](https://github.com/mitmproxy/mitmproxy)      |
| goaccess                    | Real-time web log analyzer           | [Github](https://github.com/allinurl/goaccess)        |
| bettercap                   | Network/bluetooth log analyzer       | [Github](https://github.com/bettercap/bettercap)      |
| pyroscope-io/brew/pyroscope | Continuous profiling platform        | [Github](https://github.com/pyroscope-io/pyroscope)   |
| vegeta                      | HTTP load testing tool               | [Github](https://github.com/tsenart/vegeta)           |
| mkcert                      | Make local trusted dev certs         | [Github](https://github.com/FiloSottile/mkcert)       |
| starship                    | Cool shell dev prompts               | [Github](https://github.com/starship/starship)        |

## VS Code plugins

| Name                     | Extension ID                                |
|--------------------------|---------------------------------------------|
| Go                       | golang.go                                   |
| GraphQL                  | graphql.vscode-graphql                      |
| Dart                     | dart-code.dart-code                         |
| Flutter                  | dart-code.flutter                           |
| webhint                  | webhint.vscode-webhint                      |
| ESLint                   | dbaeumer.vscode-eslint                      |
| stylelint                | stylelint.vscode-stylelint                  |
| Svelte                   | svelte.svelte-vscode                        |
| YAML                     | redhat.vscode-yaml                          |
| docker                   | ms-azuretools.vscode-docker                 |
| VSCode Great Icons       | emmanuelbeziat.vscode-great-icons           |
| Kubernetes               | ms-kubernetes-tools.vscode-kubernetes-tools |
| hadolint                 | exiasr.hadolint                             |
| GitHub heme              | github.github-vscode-theme                  |
| Ruby Solargrpah          | castwide.solargraph                         |
| vscode-styled-components | jpoissonnier.vscode-styled-components       |

## Audio

- In `/home/user/.config/pulse/daemon.conf`:

```sh
avoid-resampling = true
flat-volumes = no
resample-method = speex-float-10
avoid-resampling = yes
## These next options should be tailored to your use case and hardware. I mainly play files in 44100 and 96000 bit rate through headphones.
default-sample-format = float32le
default-sample-rate = 44100
alternate-sample-rate = 96000
```

### Autologin on startup
See: [docs](https://wiki.voidlinux.org/Automatic_Login_to_Graphical_Environment)
```sh
$ sudo cp -R /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
$ sudo echo >> /etc/sv/agetty-autologin-tty1/conf "GETTY_ARGS=\"--autologin $USER --noclear\"
  BAUD_RATE=38400
  TERM_NAME=linux"
```
Logout, login, and:
```sh
$ sudo rm /var/service/agetty-tty1
$ sudo ln -s /etc/sv/agetty-autologin-tty1 /var/service
```

### Auto xinit w/ fish
In `~/.config/fish/config.fish`:
```sh
#set -l tty (fgconsole)
if test -z $DISPLAY
  #and [ tty = 1 ]
  exec startx
end
```

> In general, use `~/.config/fish/config.fish` for any ".profile" configuration

### Create Pulseaudio module for OBS
(Assume that with listing `short links` 3 is the null one and 2 is the default)
```sh
$ pactl load-module module-null-sink
$ pactl list short sinks
$ pactl load-module module-combine-sink sink_name=OBScombine slaves=3,2
```
