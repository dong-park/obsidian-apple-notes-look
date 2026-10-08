# obsidian-apple-notes-look

Obsidian을 macOS 메모 앱처럼 보이게 하고, Apple 메모와 양방향 동기화까지 한 번에 설정합니다.

- **외관:** SF Pro와 Apple SD Gothic Neo 14px, 노란 강조색, 회색 사이드바, 노란 폴더 아이콘, 동그란 체크박스
- **동기화:** [Apple Notes Sync](https://github.com/coddingtonbear/obsidian-apple-notes) 플러그인과 [icloud-md](https://github.com/coddingtonbear/icloud-md) CLI. 둘 다 이 레포가 아니라 Adam Coddington이 만든 것입니다.

## 설치

Obsidian을 종료한 뒤 실행합니다. 켜져 있으면 Obsidian이 종료할 때 설정을 덮어씁니다.

```bash
git clone https://github.com/dong-park/obsidian-apple-notes-look
cd obsidian-apple-notes-look
./install.sh ~/path/to/vault            # 외관 + 동기화
./install.sh ~/path/to/vault --no-sync  # 외관만
```

설치 후 Obsidian에서:

1. 설정 → 커뮤니티 플러그인 → 제한 모드를 끕니다. 처음 한 번만 합니다.
2. 설정 → Apple Notes Sync → **Connect**를 눌러 iCloud에 로그인합니다.
3. 메모는 보관함의 `Apple Notes/` 폴더로 들어옵니다. 기본 10분마다 동기화합니다.

## 스크립트가 바꾸는 것

| 파일 | 변경 |
|---|---|
| `.obsidian/snippets/` | `apple-notes.css`, `apple-notes-headings.css` 복사 |
| `appearance.json` | 글꼴 14px, 강조색 `#e2a400`, 반투명 끔, 스니펫 2개 켬 |
| `app.json` | 줄 길이 제한 끔. 본문이 창 전체 폭을 씁니다 |
| `plugins/icloud-notes/` | 플러그인 최신 릴리스 다운로드. `data.json`이 없을 때만 동기화 폴더를 `Apple Notes`로 정합니다 |
| `community-plugins.json` | `icloud-notes` 추가 |

기존 설정 키와 켜져 있던 다른 스니펫은 그대로 둡니다. `icloud-md`가 없으면 `npm install -g icloud-md`로 깝니다.

## 알아둘 점

- **헤딩:** 동기화 플러그인은 Apple 메모의 제목과 헤딩을 `**굵게**`로 저장합니다. `apple-notes-headings.css`가 첫 줄을 28px, 빈 줄 바로 다음의 굵은 줄을 21px로 키웁니다. 편집 화면에서만 동작하고 읽기 모드에서는 안 됩니다. 빈 줄 뒤 굵은 글씨로 시작하는 일반 문장도 커집니다. 싫으면 이 스니펫만 끕니다.
- **숨기는 것:** 노트 위 속성 블록, Obsidian 자체 제목, 하단 상태바, 상단 경로 표시를 모든 노트에서 숨깁니다.
- **못 하는 것:** 메모 상단 가운데 날짜와 폴더별 메모 개수는 CSS로 만들 수 없습니다.
- **체크박스:** 동그란 체크박스는 `- [ ]` 문법 줄에만 나옵니다. ✅ 같은 이모지는 그대로 보입니다.
- **icloud-md를 못 찾을 때:** Finder로 연 Obsidian은 터미널 PATH를 모릅니다. 설정 → Apple Notes Sync → *icloud-md binary location*에 `which icloud-md` 결과를 넣습니다.

확인한 환경: macOS, Obsidian 1.14.4, 라이트 모드. 다크 모드 색은 넣었지만 화면으로 확인하지 않았습니다.

## 지우기

설정 → 외관 → CSS 스니펫에서 두 개를 끄고 `.obsidian/snippets/apple-notes*.css`를 지웁니다.

## License

MIT
