# oa-flutter-cicd-lab

Демонстраційний репозиторій до лекції 10 курсу «Flutter для мобільних пристроїв:
архітектура та оптимізація» (Острозька академія).

[![CI](https://github.com/LyahovchukSergiy/oa-flutter-cicd-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/LyahovchukSergiy/oa-flutter-cicd-lab/actions/workflows/ci.yml)

Застосунок тут навмисно простий, це табло вильотів без мережі й без бази.
Уся суть лежить у `.github/workflows`.

## Що всередині

| Workflow | Коли | Навіщо |
| --- | --- | --- |
| `ci.yml` | push у `main`, будь-який PR | Гейт: формат, аналіз, тести |
| `release.yml` | тег `v*` | Підписаний APK, артефакт і GitHub Release |
| `secrets-lab.yml` | руками | Що саме GitHub маскує в логах, а що ні |
| `ci-three-jobs.yml` | руками | Той самий гейт у поганій формі, для заміру часу |

## Локальний запуск

```bash
cp define.example.json define.json
flutter pub get
flutter run --dart-define-from-file=define.json
```

Ті самі перевірки, що робить гейт:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test
```

## Ключ підпису

У репозиторії його немає і бути не може. Секрети `KEYSTORE_BASE64`,
`KEYSTORE_PASSWORD`, `KEY_ALIAS` і `BOARD_TOKEN` живуть у налаштуваннях
репозиторію. Ключ, яким підписані релізи цього репозиторію, створений
одноразово під курс і нічого не публікує в жодному сторі.

Свій такий робиться так:

```bash
keytool -genkeypair -v -keystore oa-demo.jks -storetype PKCS12 \
  -keyalg RSA -keysize 2048 -validity 10000 -alias oa-demo
base64 -i oa-demo.jks | pbcopy
gh secret set KEYSTORE_BASE64
```
