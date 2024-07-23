# Birthy - A Birthday Reminder App

## About

Birthy is a mobile application built with Flutter that helps you remember and manage birthdays. It allows you to store birthdays, receive timely notifications, and never miss a chance to celebrate your loved ones' special days.

## Technologies Used

- **Flutter:** The core framework used to build the app's user interface and logic.
- **Dart:** The programming language used with Flutter.
- **Hive:** A lightweight and blazing fast key-value database used for local storage of birthday data.
- **Flutter Local Notifications:** A plugin for scheduling and displaying local notifications.
- **Intl:** Provides internationalization and localization capabilities for formatting dates and times.

## Project Structure

The project follows a standard Flutter structure:

- **lib:** Contains the Dart source code for the app.
  - **main.dart:** The entry point of the application.
  - **splash_screen.dart:** Displays a splash screen while the app initializes.
  - **birthday_list_screen.dart:** Shows the list of saved birthdays.
  - **add_birthday_screen.dart:** Allows users to add or edit birthdays.
  - **birthday_model.dart:** Defines the data model for a birthday entry.
  - **notification_service.dart:** Handles scheduling and managing local notifications.
  - **month_day_picker.dart:** Provides a custom widget for selecting month and day.
  - **theme.dart:** Defines the app's theme and styling.
  - **adapters.dart:** Contains Hive adapters for custom data types.
- **assets:** Stores assets like images used in the app.
- **android:** Contains Android-specific project files.
- **ios:** Contains iOS-specific project files.

## Main Components

### BirthdayListScreen

- Displays the list of birthdays fetched from the Hive database.
- Allows users to add new birthdays and edit existing ones.
- Enables deleting birthdays using swipe-to-dismiss gestures.

### AddBirthdayScreen

- Provides a form for adding or editing birthday details.
- Uses a `MonthDayPicker` for convenient date selection.
- Saves the birthday data to the Hive database.

### BirthdayModel

- Represents a single birthday entry with properties for name, date of birth, and ID.
- Provides methods for converting to and from JSON format.

### NotificationService

- Uses the `flutter_local_notifications` plugin to schedule birthday notifications.
- Cancels existing notifications when a birthday is deleted or edited.

## Building and Running

1. **Install Flutter:** Follow the instructions at [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) to install Flutter on your system.

2. **Clone the repository:** `git clone https://github.com/your-username/birthy.git`

3. **Navigate to the project directory:** `cd birthy`

4. **Install dependencies:** `flutter pub get`

5. **Run the app:** `flutter run`

This will launch the app on an emulator or connected device.
