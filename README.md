# Anglara Weather App

A Flutter-based weather application developed as part of the **Anglara Flutter Developer Challenge**.

The application provides current weather information for searched cities and the user's current location, with proper loading, refresh, error handling, and a clean separation between UI, state management, services, and data models.

---

## Features

* Branded splash screen
* Current weather information

   * City name
   * Temperature
   * Weather condition
   * Weather condition icon
   * Wind speed
* Search weather by city name
* Use current device location to fetch weather
* Manual refresh
* Pull-to-refresh
* Separate initial loading and refresh states
* Previous weather data remains visible if a refresh fails
* User-friendly error messages for:

   * Invalid/non-existent city
   * No internet connection
   * Request timeout
   * API rate limiting
   * Location permission issues
   * Disabled location services
* Responsive and simple Material 3 based UI

---

## Tech Stack

* **Flutter**
* **Dart**
* **GetX** – State management
* **Dio** – REST API communication
* **Geolocator** – Device location
* **Open-Meteo API** – Weather and geocoding data

---

## API

The application uses [Open-Meteo](https://open-meteo.com/) for weather data.

Two Open-Meteo APIs are used:

### Geocoding API

Used to convert a searched city name into latitude and longitude.

```text
https://geocoding-api.open-meteo.com/v1/search
```

### Weather API

Used to retrieve current weather information based on coordinates.

```text
https://api.open-meteo.com/v1/forecast
```

The application requests:

```text
temperature_2m
weather_code
wind_speed_10m
```

---

## Project Structure

```text
lib/
├── controllers/
│   └── weather_controller.dart
│
├── data/
│   ├── models/
│   │   └── weather_model.dart
│   │
│   └── services/
│       ├── location_service.dart
│       └── weather_service.dart
│
├── views/
│   ├── splash_view.dart
│   └── weather_view.dart
│
└── main.dart
```

### Responsibilities

**`main.dart`**

Initializes the Flutter application, GetX, theme, and the initial splash screen.

**`views/`**

Contains the application's UI screens.

* `SplashView` – branded splash screen and navigation
* `WeatherView` – weather dashboard, search, refresh, location, and weather display

**`controllers/`**

Contains application state and coordinates communication between the UI and services.

* `WeatherController` – manages weather data, loading states, refresh states, location requests, and user-facing errors.

**`data/services/`**

Contains external-service related logic.

* `WeatherService` – communicates with Open-Meteo APIs.
* `LocationService` – handles device location services and permissions.

**`data/models/`**

Contains the application's weather data model and weather-condition mapping.

---

## State Management

The application uses **GetX** for state management.

The main reactive states are:

```dart
isLoading
isRefreshing
isGettingLocation
weather
errorMessage
```

The application distinguishes between the initial loading state and refreshing an already displayed result.

### Initial Load

```text
No weather data
      ↓
Loading
      ↓
API request
      ↓
Success → Display weather
```

### Refresh

```text
Existing weather
      ↓
Refreshing
      ↓
API request
   ↙       ↘
Success    Failure
  ↓          ↓
Update     Keep existing
weather    weather visible
```

This prevents the existing weather information from disappearing simply because a refresh request failed.

---

## Weather Conditions

Open-Meteo returns weather conditions using **WMO weather codes**.

The application converts these codes into human-readable conditions and appropriate Material icons.

Examples:

| WMO Code | Displayed Condition    |
| -------- | ---------------------- |
| 0        | Clear Sky              |
| 1–2      | Partly Cloudy          |
| 3        | Overcast               |
| 45, 48   | Fog                    |
| 51–57    | Drizzle                |
| 61–67    | Rain                   |
| 71–77    | Snow                   |
| 80–82    | Rain Showers           |
| 85–86    | Snow Showers           |
| 95       | Thunderstorm           |
| 96, 99   | Thunderstorm with Hail |

---

## Error Handling

The application handles common API and device-related failures without crashing the UI.

Examples include:

### City Not Found

If the geocoding API does not return a matching city:

```text
City not found
```

### No Internet Connection

```text
No internet connection. Please check your network.
```

### Request Timeout

```text
Request timed out. Please try again.
```

### Rate Limiting

If the API returns HTTP `429`:

```text
Too many requests. Please try again later.
```

### Location Errors

The application also handles:

* Location services disabled
* Location permission denied
* Location permission permanently denied

---

## Current Location

The application supports fetching weather using the device's current location.

The flow is:

```text
Request current location
        ↓
Check GPS/service availability
        ↓
Check/request permission
        ↓
Get latitude & longitude
        ↓
Request weather from Open-Meteo
        ↓
Display current weather
```

### Android Permissions

The Android application declares the required location permissions:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

The application also requests runtime location permission when required.

---

## Getting Started

### Prerequisites

Make sure Flutter is installed and configured correctly.

Check your Flutter installation:

```bash
flutter doctor
```

### Clone the repository

```bash
git clone https://github.com/tahaa-workspace/anglara-weather-app.git
cd anglara-weather-app
```

### Install dependencies

```bash
flutter pub get
```

### Run the application

```bash
flutter run
```

If using FVM:

```bash
fvm flutter pub get
fvm flutter run
```

---

## Testing the Application

The following flows can be tested manually:

1. Launch the application and verify the splash screen.
2. Verify the initial weather information.
3. Search for another city.
4. Search for an invalid city.
5. Refresh the current weather.
6. Pull down on the weather screen to refresh.
7. Temporarily disable network connectivity and test refresh behavior.
8. Use **Current Location**.
9. Test location permission handling.
10. Disable device location services and test the corresponding error message.

---

## Development Approach

This project was developed using a **Vibe Coding / AI-assisted development approach**.

AI tools were used during the development process to assist with implementation, debugging, code suggestions, and iteration.

However, the implementation was not treated as a black-box generated solution. The development process focused on:

1. Understanding the assignment requirements.
2. Understanding the purpose and functionality of each feature.
3. Breaking the application into manageable components.
4. Understanding the generated/assisted code before integrating it.
5. Testing the functionality on the Flutter emulator.
6. Debugging issues encountered during implementation.
7. Reviewing the final architecture and application flow.

The goal was to use AI as a **development productivity tool while retaining an understanding of the complete application functionality and implementation decisions**.

This approach also helped with faster iteration while maintaining the ability to explain the application's architecture, state management, API integration, asynchronous operations, error handling, and location functionality.

---

## Architecture Overview

The application's basic flow is:

```text
                     ┌─────────────────┐
                     │   Weather View  │
                     └────────┬────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │ Weather Controller│
                    └───────┬─────┬─────┘
                            │     │
              ┌─────────────┘     └──────────────┐
              ▼                                  ▼
     ┌─────────────────┐                ┌─────────────────┐
     │ Weather Service │                │ Location Service│
     └────────┬────────┘                └────────┬────────┘
              │                                  │
              ▼                                  ▼
     ┌─────────────────┐                ┌─────────────────┐
     │  Open-Meteo API │                │ Device Location │
     └─────────────────┘                └─────────────────┘
```

This keeps UI-related code separate from API communication and device-location logic.

---

## Limitations / Future Improvements

The current implementation intentionally focuses on the functionality required for the challenge rather than adding unnecessary complexity.

Potential future improvements could include:

* Local caching of the last successful weather response
* Weather forecast information
* Multiple saved cities
* More detailed weather information
* Improved weather illustrations
* Automated unit and widget tests
* More advanced search/autocomplete

These features are outside the core scope of the current challenge implementation.

---

## Author

**Tahaa Mandsorwala**

Flutter Developer | MCA Student

GitHub:
https://github.com/tahaa-workspace

---