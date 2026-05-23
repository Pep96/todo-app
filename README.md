# ✅ Todo App

A beautiful and functional task manager built with Flutter, featuring local persistence, dark mode, and priority management.

## Features

- Add, edit, and delete tasks with swipe gestures
- Light and dark theme toggle (persisted locally)
- Priority levels: Low / Medium / High
- Progress overview with stats card and progress bar
- Filter tasks by All / Active / Completed
- Offline-first persistence with Hive
- Smooth animations and Material 3 design

## Architecture

```
lib/
├── bloc/
│   ├── todo_bloc.dart       # BLoC state management
│   ├── todo_event.dart
│   ├── todo_state.dart
│   └── theme_cubit.dart     # Theme toggle cubit
├── models/
│   ├── todo.dart            # Hive model
│   └── todo.g.dart          # Generated adapter
├── screens/
│   ├── home_screen.dart
│   └── add_todo_screen.dart
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── todo_tile.dart
│   └── stats_card.dart
└── main.dart
```

## Tech Stack

| Package | Purpose |
|---|---|
| `flutter_bloc` ^8.1.3 | BLoC pattern state management |
| `hive` + `hive_flutter` | Offline local database |
| `flutter_slidable` | Swipe-to-action list tiles |
| `uuid` | Unique ID generation |
| `intl` | Date formatting |

## Getting Started

```bash
git clone https://github.com/Pep96/todo_app.git
cd todo_app
flutter pub get
flutter run
```

> Requires Flutter 3.0+ and Dart 3.0+

---

Built with Flutter by [@Pep96](https://github.com/Pep96)
