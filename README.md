# Vienna Metro App 🚇

Modern Flutter application for navigating Vienna's metro system (U-Bahn).

## Features

### 🔴 Real-Time Features
- ⏱️ **Live Departures** - Real-time train arrival times with countdown
- 📍 **GPS Location** - Automatic detection of nearest metro station
- 🗺️ **Interactive Map** - Live map with your GPS position and all stations
- 📶 **Smart Caching** - Efficient API usage with 25-second cache

### 🚇 Navigation
- 🗺️ **Metro Map** - View the complete Vienna metro network
- 🔍 **Station Search** - Find stations by name with smart filtering
- 🚉 **All Stations** - Browse all 109 stations across 5 metro lines
- 📍 **Route Planner** - Find the fastest route with transfer information
- 🎨 **Modern UI** - Clean, intuitive Material Design 3 interface

## Metro Lines

The app includes all Vienna metro lines:
- **U1** (Red) - Leopoldau ↔ Oberlaa
- **U2** (Purple) - Seestadt ↔ Karlsplatz
- **U3** (Orange) - Ottakring ↔ Simmering
- **U4** (Green) - Heiligenstadt ↔ Hütteldorf
- **U6** (Brown) - Siebenhirten ↔ Floridsdorf

## Getting Started

### Prerequisites

- Homebrew (for macOS)
- Flutter SDK (>=3.0.0) - **NOT a Python package!**
- Xcode (for iOS) or Android Studio (for Android)

### Installation on macOS

1. **Remove Python flutter package** (if you accidentally installed it):
```bash
pip uninstall flutter -y
```

2. **Install Flutter SDK via Homebrew**:
```bash
brew install --cask flutter
```

3. **Add Flutter to PATH** (for Apple Silicon):
```bash
echo 'export PATH="$PATH:/opt/homebrew/Caskroom/flutter/latest/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

For Intel Macs, the path might be different - check with `brew --prefix`.

4. **Verify installation**:
```bash
flutter --version
flutter doctor
```

5. **Clone and setup the project**:
```bash
git clone https://github.com/zaharenok/vienna_metro_app.git
cd vienna_metro_app
flutter pub get
```

6. **Run the app**:
```bash
flutter run
```

**Note**: If `flutter doctor` shows warnings about Xcode or Android SDK, install the required tools:
- For iOS: Install Xcode from App Store and CocoaPods (`sudo gem install cocoapods`)
- For Android: Install Android Studio with Android SDK

## Project Structure

```
lib/
├── models/           # Data models (Station, Line, Route)
├── screens/          # UI screens
├── widgets/          # Reusable widgets
├── services/         # Business logic (MetroData, RouteFinder)
└── main.dart        # App entry point

assets/
└── images/          # Metro map image
```

## Technical Details

- **Architecture**: Clean separation of concerns (Models, Services, UI)
- **State Management**: StatefulWidget with local state
- **Routing**: BFS algorithm for finding shortest paths
- **UI Framework**: Material Design 3
- **Search**: Real-time station search with filtering by line
- **API Integration**: Vienna Transport API (vtapi.floscodes.net)
- **Maps**: Flutter Map with OpenStreetMap tiles
- **Geolocation**: Geolocator for GPS positioning
- **Caching**: SharedPreferences for API response caching (25s TTL)
- **Permissions**: Location permissions for iOS and Android

## Author

Created by [@zaharenok](https://github.com/zaharenok)

## License

MIT License

## Acknowledgments

- Metro map data from [Wiener Linien](https://www.wienerlinien.at)
- Map source: [H. Prillinger's Vienna U-Bahn page](https://homepage.univie.ac.at/horst.prillinger/ubahn/english/network_maps.html)
