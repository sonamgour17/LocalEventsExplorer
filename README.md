# Local Events Explorer (iOS)

A SwiftUI app to browse events, see details, bookmark favorites, and open directions in Apple Maps. Works offline.

## Features

- Event list from a mock REST API, with pull to refresh
- Event details with distance to the event and Open in Apple Maps
- Bookmarks saved on the device (Core Data)
- Offline mode: shows the last loaded events with an offline banner
- API cache with 5-minute TTL
- Image cache with a 50-image limit (LRU)
- Background refresh every 4 hours (low frequency)

## Requirements

- Xcode 26+
- iOS 17.6+
- Swift 6

## How to Run

1. Open `LocalEventsExplorer.xcodeproj`.
2. Select an iPhone simulator and press **Cmd + R**.
3. Allow location. In the Simulator: **Features → Location → Apple**.
4. Run tests with **Cmd + U**.

API: `https://6a7e37d0f8b2ed99ca4f25b9.mockapi.io/api/v1/events`

## Architecture

**MVVM + Dependency Injection**

View → ViewModel → Services (Network, Cache, Core Data, Location)

- Views only talk to ViewModels.
- ViewModels use services through protocols, so they can be tested with mocks.
- `AppContainer` creates all services once (no singletons).

**Loading events:**
1. Check the in-memory cache (5 min TTL).
2. If empty or expired, call the network.
3. On success, save to the cache and Core Data.
4. If the network fails, show saved events from Core Data.

## Folder Structure

```
App/        # Entry point, AppContainer (DI)
Core/       # Navigation, Location, Services (Network, Cache, Persistence, Background)
Features/   # EventList, EventDetail, Bookmarks (View + ViewModel)
Resources/  # Assets (app icon, colors)
Shared/     # Model, Constants, reusable UI, Logger
```

## Engineering Standards

- MVVM with protocol-based services and dependency injection (SOLID)
- One state enum per screen: loading, loaded, empty, error
- Swift 6 concurrency: caches are `actor`s, UI runs on the main actor
- Constants in one place (`AppConstants`)
- Logging with `Logger` instead of `print`
- SwiftLint for code style
- Location is used only on the device and never stored

## Testing

6 unit tests for `EventListViewModel`:
- Success shows events
- Empty response shows empty state
- No internet shows an error
- No internet with saved data shows offline events
- Fresh cache skips the network
- Pull to refresh skips the cache

Only the network is mocked. Cache and Core Data use the real classes (Core Data in memory).

## Trade-offs

- 5-minute TTL balances fresh data and fewer network calls.
- Images are cached in memory only, so offline after a restart a placeholder is shown.
- The API gives only a city name, so distance uses geocoding.
- Background refresh runs only on a real device, not in the Simulator.

## Not Covered

Due to the time limit:
- Diagrams are described in text.
- Code comments are minimal.
- Unit tests cover `EventListViewModel` only.

## Future Improvements

- Full test coverage for all ViewModels (EventList, EventDetail, Bookmarks)
- Unit tests for services (Network, Cache, Core Data)
- UI tests for the main flows
- Better code comments and documentation
- Sort events by distance
- Architecture and sequence diagrams

## Demo Video
