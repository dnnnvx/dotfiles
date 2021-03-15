# Void Desktop Setup

Dot 👽 Dot 🦎

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
| wireshark           | Network traffic analyzer                     | [Github](https://github.com/wireshark/wireshark)               |

```console
$ sudo usermod -aG input,video,libvirt,docker,kvm $USER
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
| Iosevka Font (SS12)        | Iosevka font                        | [Github](https://github.com/be5invis/Iosevka/releases)     |
| Atkinson Hyperlegible Font | Atkinson font                       | [Site](https://fontesk.com/atkinson-hyperlegible-font/)    |

## Other installations

| Tool                       | Description                         | Link                                                       |
|----------------------------|-------------------------------------|------------------------------------------------------------|
| Go                         | The Go programming lnguage          | [Site](https://golang.org/dl/)                             |
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
| Iosevka Font (SS12)        | Iosevka font                        | [Github](https://github.com/be5invis/Iosevka/releases)     |
| Atkinson Hyperlegible Font | Atkinson font                       | [Site](https://fontesk.com/atkinson-hyperlegible-font/)    |

## Brew installations

| Package Name | Description                          | Link                                           |
|--------------|--------------------------------------|------------------------------------------------|
| hadolint     | Dockerfile linter                    | [Github](https://github.com/hadolint/hadolint) |
| kubespy      | Observing k8s resources in real time | [Github](https://github.com/pulumi/kubespy)    |
| k9s          | Kubernetes CLI/TUI management        | [Github](https://github.com/derailed/k9s)      |

## VS Code plugins

| Name                | Extension ID                       |
|---------------------|------------------------------------|
| Go                  | golang.go                          |
| GraphQL             | graphql.vscode-graphql             |
| Dart                | dart-code.dart-code                |
| Flutter             | dart-code.flutter                  |
| webhint             | webhint.vscode-webhint             |
| ESLint              | dbaeumer.vscode-eslint             |
| stylelint           | stylelint.vscode-stylelint         |
| Svelte              | svelte.svelte-vscode               |
| YAML                | redhat.vscode-yaml                 |
| Material Icon Theme | pkief.material-icon-theme          |
| Mayukai Theme       | gulajavaministudio.mayukaithemevsc |
| docker              | ms-azuretools.vscode-docker        |
| hadolint            | exiasr.hadolint                    |

<style>
table {
	width:100%;
}
</style>