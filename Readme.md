# GitHub Client (Light)

A lightweight SwiftUI app to browse GitHub users and their repositories using GitHub's public API.

![App Screenshots](AppScreens.png)

## Architecture

The project follows a clean architecture approach with:

- **UI Layer**: SwiftUI with MVVM architecture
- **Networking**: Native async/await API calls
- **Image Handling**: Efficient local caching using NSCache
- **State Management**: Native SwiftUI state tools (@State, @StateObject, etc.)
- **Dependency Injection**: Protocol-based DI for flexibility & testability
- **Testing**: Unit tests with dependency injection

## Features

- GitHub user search and profile viewer
- Public repository listing with sorting options
- In-app WebView to preview GitHub user profiles and repositories
- Full support for Dark Mode
- Fast image loading with local cache
- Secure access token handling via .xcconfig
- Comprehensive unit & UI test coverage


## Project Structure

```
GithubClient/
├── Core/          # Core application logic
├── Components/    # Reusable UI components
├── Extensions/    # Swift extensions
├── Models/        # Data models
├── Mock/          # Mock data for testing
├── Networking/    # Network layer, API endpoints, environment configs
├── Resources/     # Assets: colors, fonts, icons
├── Services/      # API services
└── Utility/       # Helpers and utilities
```

## Requirements

- iOS 18.0+
- Xcode 16.0+
- Swift 5
- GitHub personal access token

## Installation

1. Clone the repository:
```bash
git clone https://github.com/AungHtooMyatKhaing/GithubClientApp.git
```

2. Open `GithubClient.xcodeproj` in Xcode

3. Create a `Secrets.xcconfig` file with your GitHub API credentials:
```
GITHUB_ACCESS_TOKEN = your_github_access_token
```

4. Build and run the project

## Testing

The project includes both unit tests and UI tests:

- Unit tests are located in `GithubClientTests/`
- UI tests are located in `GithubClientUITests/`

Run tests using Cmd+U in Xcode or through the Test navigator.

<!-- ## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request -->

## Acknowledgments

- GitHub API
