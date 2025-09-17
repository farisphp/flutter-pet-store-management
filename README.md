# PetStore - Flutter Pet Management App

A modern Flutter application for managing pet information, built with clean architecture principles. This app allows users to view, create, edit, and delete pet records with photo management capabilities.

## Features

- 📱 **Pet Management**: Create, view, edit, and delete pet records
- 🖼️ **Photo Gallery**: Display multiple pet photos with thumbnail previews
- 🏷️ **Tag System**: Organize pets with customizable tags
- 📊 **Status Tracking**: Track pet status (Available, Pending, Sold)
- 🎨 **Modern UI**: Clean Material Design interface with responsive layout
- 🔄 **API Integration**: Full CRUD operations with REST API
- 🎯 **Clean Architecture**: Well-structured codebase with separation of concerns

## Tech Stack

- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **HTTP** - API communication
- **Material Design** - Modern UI components

## Getting Started

### Prerequisites

- Flutter SDK (version 3.6.0 or higher)
- Dart SDK

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run -d web-server` to start the application

### Development

```bash
# Run in development mode
flutter run -d web-server

# Build for production
flutter build web --release
```

## Project Structure

```
lib/
├── domain/          # Business logic and entities
│   └── entities/    # Domain models (Pet, Category, Tag, etc.)
├── data/           # Data sources and repositories
│   └── repositories/# API and data handling
├── ui/             # Presentation layer
│   ├── home/       # Home screen and widgets
│   │   └── widgets/# Reusable UI components
│   └── common/     # Shared UI utilities
└── main.dart       # Application entry point
```

## Key Components

### Domain Layer
- **Pet Entity**: Core pet model with id, name, status, category, tags, and photoUrls
- **PetStatus Enum**: Available, Pending, Sold status tracking
- **Category & Tag**: Supporting entities for pet organization

### UI Layer
- **Home Screen**: Main dashboard displaying pet cards
- **PetCard Widget**: Reusable card component showing pet details and photos
- **Image Gallery**: Thumbnail display of pet photos with error handling

### Data Layer
- **API Integration**: HTTP client for pet store API operations
- **Repository Pattern**: Abstraction layer for data operations

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Built with ❤️ using Flutter
