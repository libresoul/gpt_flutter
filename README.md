# gpt_flutter

A simple chatbot integrated with OpenAI's magic

## Getting Started

Make sure you have done installing all the prerequisites for flutter development. If not, you can follow the instructions [here](https://flutter.dev/docs/get-started/install).

## Installing dependencies

All the dependencies are listed in the `pubspec.yaml` file. You can install them by running the following command your terminal:

```bash
flutter pub get
```

## Generating files

Run the build runner to generate the necessary files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the app

You can run the app on an emulator or a physical device by running the following command in your terminal. Make sure to mention the device id if you have multiple devices connected.:

```bash
flutter run -d <device_id>
```

## Building the app

You can build the app for by running the following command in your terminal:

```bash
flutter build <platform>
```

Follow the instructions for each platform on the flutter documentation [here](https://flutter.dev/docs/deployment).
