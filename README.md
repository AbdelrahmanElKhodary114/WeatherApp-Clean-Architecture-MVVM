# 🌦️ WeatherApp (Clean Architecture + MVVM)

<p align="center">
  <img src="images/appstore.png" alt="Screenshot" width="150"/>
</p>

<p align="center" style="display: flex; gap: 10px;">
<img src="images/screen1.png" width="375" height="812" />
<img src="images/screen2.png" width="375" height="812" />
</p>

## 🌟 Overview

**WeatherApp** is a modern iOS application built with:
- **SwiftUI** for declarative UI
- **Clean Architecture** for maintainability
- **MVVM** pattern with Combine and async
- **TDD** approach with 60%+ test coverage

Key highlights:

✅ Protocol-oriented networking layer  

✅ Dependency injection for testability 

✅ This architecture helps in maintaining a scalable and testable codebase.

## 🎯 Features

### 🏗️ Architecture
- **Clean Architecture** with clear separation of:
  - Presentation (SwiftUI with MVVM) = ViewModels + Views
  - Domain (Entities & Use Cases & Repositories Interfaces) 
  - Data (Repositories & API)
- **MVVM** pattern with `ObservableObject` ViewModels
- **Dependency Injection** using Factory

### 🌦️ Weather Functionality
- Current weather conditions display
- 1-day forecast
- Weather condition animations

### 🧪 Testing
- 60%+ unit test coverage
- Mock implementations for all services
- Isolated ViewModel tests
- Network layer protocol testing


## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/AbdelrahmanElKhodary114/WeatherApp-Clean-Architecture-MVVM.git
    ```
2. Open the project in Xcode:
    ```bash
    open WeatherApp.xcodeproj
    ```
3. Build and run the application.

## Contributing

Feel free to open issues or submit pull requests. Please ensure your code adheres to the project's coding standards and includes appropriate tests.
