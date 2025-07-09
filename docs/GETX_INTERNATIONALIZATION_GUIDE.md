# Internationalization Setup with GetX and get_cli

This guide explains how to set up internationalization (i18n) in your Flutter project using the [GetX](https://pub.dev/packages/get) package and the [get_cli](https://pub.dev/packages/get_cli) tool.

---

## Prerequisites

- Flutter project using GetX for state management and navigation.
- [get_cli](https://pub.dev/packages/get_cli) installed globally:
  ```sh
  dart pub global activate get_cli
  ```

---

## Step 1: Create the Locales Directory

Create a folder named `locales` inside your `assets` directory. This will store your translation files.

```sh
mkdir -p assets/locales
```

---

## Step 2: Add Locales to pubspec.yaml

Include the new `locales` folder in your `pubspec.yaml` under the `assets` section:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/lottie/
    - assets/locales/
```

---

## Step 3: Create Translation Files

Create JSON files for each supported locale. For example:

- `assets/locales/en_US.json` (English)
- `assets/locales/ja_JP.json` (Japanese)

Example `en_US.json`:

```json
{
  "hello": "Hello",
  "welcome": "Welcome"
}
```

Example `ja_JP.json`:

```json
{
  "hello": "こんにちは",
  "welcome": "ようこそ"
}
```

---

## Step 4: Generate Locale Files with get_cli

Run the following command to generate Dart translation keys:

```sh
get generate locales assets/locales
```

This will create a file at `lib/generated/locales.g.dart` containing the `AppTranslation` class.

---

## Step 5: Update main.dart

1. Import the generated translation file:
   ```dart
   import 'generated/locales.g.dart';
   ```
2. Add the `translationsKeys` property to your `GetMaterialApp`:
   ```dart
   GetMaterialApp(
     // ... other properties ...
     translationsKeys: AppTranslation.translations,
     // ...
   )
   ```
3. Set the default locale and supported locales as needed:
   ```dart
   locale: const Locale('ja', 'JP'), // or Get.deviceLocale
   supportedLocales: [
     Locale('en', 'US'),
     Locale('ja', 'JP'),
   ],
   fallbackLocale: const Locale('en', 'US'),
   ```

---

## Step 6: Using Translations in Your App

- Use the `.tr` extension with the generated `LocaleKeys` class to access translations in a type-safe way:

```dart
import 'generated/locales.g.dart';

Text(LocaleKeys.hello.tr) // Displays "Hello" or "こんにちは" based on locale
Text(LocaleKeys.welcome.tr) // Displays "Welcome" or "ようこそ" based on locale
```

This approach avoids hardcoding string keys and provides compile-time safety.

---

## Step 7: Adding New Languages

1. Add a new JSON file in `assets/locales/` (e.g., `fr_FR.json`).
2. Add the new locale to `supportedLocales` in `main.dart`.
3. Re-run:
   ```sh
   get generate locales assets/locales
   ```

---

## References

- [GetX Internationalization Docs](https://pub.dev/packages/get#internationalization)
- [get_cli Documentation](https://pub.dev/packages/get_cli)

---

**You are now ready to support multiple languages in your Flutter app using GetX and get_cli!**
