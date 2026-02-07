# dotfiles (chezmoi)

macOS 초기화(새 맥) 후에도 같은 개발 환경을 최대한 동일하게 재현하기 위한 dotfiles.

- Dotfiles manager: `chezmoi`
- Package manager: Homebrew (`Brewfile`)
- Runtime/tool manager: `mise`
- Keyboard remap: `Karabiner-Elements`
- Launcher: Raycast (export/import)

## One Command (After Clone)

```bash
./bootstrap-mac.sh
```

`bootstrap-mac.sh`가 하는 일:

- Xcode Command Line Tools 확인(없으면 설치 유도)
- Homebrew 설치/초기화
- `Brewfile` 설치(`brew bundle`, formula/cask)
- 이 레포를 source로 `chezmoi apply`
- `oh-my-zsh` 설치(기본 `~/.zshrc`가 사용)
- `mise install` 실행(가능한 경우)
- (가능하면) Raycast export 파일을 `~/Downloads/rayconfig`로 복사 후 열기

옵션:

```bash
./bootstrap-mac.sh --help
```

## Fresh Mac Setup (Manual Notes)

### Karabiner-Elements

이 레포는 아래 Karabiner 설정을 포함한다.

- `Caps Lock` <-> `Left Control` 스왑
- `Right Command` 단독 탭: 입력 소스 전환 (`Control+Space`)

필수:

- macOS 권한 허용:
  - 시스템 설정 -> 개인정보 보호 및 보안 -> 손쉬운 사용(Accessibility)
  - 시스템 설정 -> 개인정보 보호 및 보안 -> 입력 모니터링(Input Monitoring)

입력 소스 전환 설정 (한/영 전환이 목적이면 중요):

- 시스템 설정 -> 키보드 -> 키보드 단축키 -> 입력 소스
  - 입력 소스 전환이 `Control+Space`인지 확인
- 입력 소스는 2개만 두는 걸 추천 (예: `ABC`, `2-Set Korean`)

주의:

- macOS “수정 키(Modifier Keys)”에서 Caps Lock/Control을 따로 바꿔두면 Karabiner와 중복 적용될 수 있다.
  - 이 레포를 그대로 쓸 땐 macOS 쪽 수정 키는 기본값으로 두는 게 제일 깔끔하다.

### Raycast (Export/Import)

Raycast Pro(Cloud Sync) 없이도 export/import로 대부분의 설정/데이터를 옮길 수 있다.

- 이 레포에는 Raycast export 파일이 `rayconfig`로 포함되어 있다.
- `bootstrap-mac.sh`는 이를 `~/Downloads/rayconfig`로 복사하고(가능하면) 열어준다.

새 맥에서 Import가 자동으로 뜨지 않으면:

1. Raycast 실행
1. 설정에서 Import/Restore 흐름으로 `~/Downloads/rayconfig`를 선택

Raycast export 파일을 갱신하는 방법(기존 맥에서):

1. Raycast에서 Export 기능으로 `rayconfig` 파일을 새로 생성
1. 이 레포에서 아래 스크립트로 덮어쓰기

```bash
./scripts/update-raycast-export.sh /path/to/rayconfig
```

### VS Code Extensions

`Brewfile`에 `vscode` 확장 목록이 포함되어 있다. `brew bundle`로 설치하려면 `code` CLI가 필요할 수 있다.

1. VS Code 실행
1. Command Palette에서 “Shell Command: Install 'code' command in PATH” 실행
1. 다시 실행:

```bash
brew bundle install --file "$(pwd)/Brewfile" --vscode
```

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
