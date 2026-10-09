# App Build APK

Build website menjadi APK (WebView) via GitHub Actions.

## Trigger
- Manual: Actions → Build APK → Run workflow
- API / Bot WhatsApp: `workflow_dispatch`

## Inputs
- `url` — link website
- `app_name` — nama aplikasi
- `package_name` — contoh `com.rizx.myapp`
- `icon_url` — (opsional) URL icon PNG
