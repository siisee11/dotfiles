# dotfiles (chezmoi)

macOS 초기화(새 맥) 후에도 같은 개발 환경을 빠르게 재현하기 위한 dotfiles.

- Dotfiles manager: `chezmoi`
- Package manager: Homebrew (`Brewfile`)
- Runtime/tool manager: `mise`
- Keyboard remap: `Karabiner-Elements`

## Fresh Mac Setup

### 1) Bootstrap: chezmoi 설치 + 적용

Homebrew가 없어도 되는 방식:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply siisee11
```

이미 `chezmoi`가 설치돼 있으면:

```bash
chezmoi init --apply siisee11
```

참고:

- 포크해서 쓰는 경우 `siisee11`을 본인 GitHub 유저명으로 바꾸면 된다.

### 2) oh-my-zsh 설치

이 레포의 `~/.zshrc`는 `oh-my-zsh`를 사용한다.

```bash
git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

### 3) Homebrew 패키지/앱 동기화

`chezmoi apply` 후 `Brewfile`은 `~/Brewfile`로 배치된다.

```bash
brew bundle --file ~/Brewfile
```

만약 `brew`가 없다면 (Xcode CLT 설치가 필요할 수 있음):

```bash
xcode-select --install
```

그리고 Homebrew 설치:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

설치 후 다시:

```bash
brew bundle --file ~/Brewfile
```

### 4) mise 툴 설치

`mise` 설정은 `~/.config/mise/config.toml`로 배치된다.

```bash
mise install
```

### 5) Karabiner-Elements (권한 + 동작 확인)

이 레포는 아래 Karabiner 설정을 포함한다.

- `Caps Lock` <-> `Left Control` 스왑
- `Right Command` 단독 탭: 입력 소스 전환 (`Control+Space`)

필수:

1. `Karabiner-Elements` 실행
1. macOS 권한 허용:
   - 시스템 설정 -> 개인정보 보호 및 보안 -> 손쉬운 사용(Accessibility)
   - 시스템 설정 -> 개인정보 보호 및 보안 -> 입력 모니터링(Input Monitoring)

입력 소스 전환 설정 (한/영 전환이 목적이면 매우 중요):

1. 입력 소스 전환이 `Control+Space`(기본값)인지 확인
   - 시스템 설정 -> 키보드 -> 키보드 단축키 -> 입력 소스
1. 입력 소스는 2개만 두는 걸 추천 (예: `ABC`, `2-Set Korean`)

주의:

- macOS “수정 키(Modifier Keys)”에서 Caps Lock/Control을 따로 바꿔두면 Karabiner와 중복 적용될 수 있다.
  - 이 레포를 그대로 쓸 땐 macOS 쪽 수정 키는 기본값으로 두는 게 제일 깔끔하다.

### 6) VS Code 확장 설치 (선택)

`Brewfile`에 `vscode` 확장 목록이 포함되어 있다. `brew bundle`로 설치하려면 `code` CLI가 필요할 수 있다.

1. VS Code 실행
1. Command Palette에서 “Shell Command: Install 'code' command in PATH” 실행
1. 다시 실행:

```bash
brew bundle --file ~/Brewfile
```

### 7) Raycast 설정 Import (선택)

`rayconfig` 파일이 `~/rayconfig`로 배치된다. Raycast에서 import 기능이 있는 경우 해당 파일을 선택해서 복구한다.

## 유지관리

```bash
chezmoi update
brew update
brew upgrade
brew cleanup
```

## Legacy (필요할 때만)

과거 설정 파일(vim/tmux)은 자동 적용이 아니라서 필요할 때만 수동으로 링크한다.

```bash
ln -s -f "$(chezmoi source-path)/vim/.vimrc" ~/.vimrc
ln -s -f "$(chezmoi source-path)/tmux/.tmux.conf" ~/.tmux.conf
```
