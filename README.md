# SkyCast - Flutter Weather App

Responsive Flutter web app: search any city, see current weather, 24-hour and 7-day forecast, °C/°F toggle.
Data comes from the free Open-Meteo API (no API key needed).

## Run locally

```bash
flutter create . --platforms=web --project-name skycast   # one time: generates web/ (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run -d chrome
```

## Build

```bash
flutter build web --release --base-href "/YOUR_REPO_NAME/"
```

## Deploy to GitHub Pages

1. Create a GitHub repo (e.g. `skycast`) and push this folder to the `main` branch.
2. On GitHub: Settings -> Pages -> Source: **GitHub Actions**.
3. The workflow in `.github/workflows/deploy.yml` builds and publishes automatically.
4. Live URL: `https://<your-username>.github.io/<repo-name>/`
