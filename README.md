# Pocket Chips - poker counter
<img src="assets/init_logo.png" alt="drawing" height="150"/> 

[![Google Play](https://img.shields.io/badge/Google_Play-%23414141.svg?logo=googleplay&logoColor=white)](https://play.google.com/store/apps/details?id=com.goliksim.pocketchips&hl=en&gl=US) [![RuStore](https://img.shields.io/badge/RuStore-%234e60af.svg?)](https://apps.rustore.ru/app/com.goliksim.pocketchips) [![RuStore](https://img.shields.io/badge/Web_Verson-%23968ad2.svg?)](https://apps.rustore.ru/app/com.goliksim.pocketchips) 

Pocket poker chips for your phone. Play poker with only cards.

## Content

1. [Description](#description)
2. [Installation](#installation)
3. [Stack](#features)
4. [Firebase setup](#firebase-setup)
5. [Usage](#usage)
6. [Testing](#testing)
7. [Contributing](#contributing)
8. [License](#license)

## Description

This application is designed to play poker without real chips.

Everything you need for the game: friends, cards and phone!
The application stores players' chips, and also allows you to place bets and divide the final stack based on the rules of unlimited Texas Hold'em. This is extremely convenient for beginners! The app does everything for you!

- Play with a company of up to 10 people
- Save favourite players in the device memory
- Full saving of the game state when exiting
- Automatic counting of stacks, minimum bets, raises and re-raises
- Distribution of the final pot by side-pot
- Choose the funny avatar of the player that best suits you!
- Unique interface design
- Auto-decide who is the winner on showdown with Solver feature

## Stack

- **Flutter/Dart**: My app is built with Flutter on Dart.
- **State Management**: Riverpod + ChangeNotifier.
- **API Integration**: Offline app.
- **Database**: Shared preferences + FlutterSecureStorage.
- **Testing**: Unit/Integration tests with flutter_test/patrol and mockito. Run at GitHub Actions and Firebase Test Lab
- **Firebase**: Crashlytics, Analytics, Remote Config, Test Lab


## Installation

Instructions on how to install your application. This may include cloning the repository, installing dependencies, and other necessary steps.

```bash
git clone https://github.com/goliksim/pocket_chips.git
cd pocket_chips
fvm flutter pub get
fvm flutter gen-l10n
fvm dart run build_runner build --delete-conflicting-outputs
```

To build android release app you need to add:
* google-services.json
* key.properties
* keystore.jks
* firebase.json


## Google Cloud setup
Download CLI if you don't have it
```bash
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz 
tar -xf google-cloud-cli-darwin-arm.tar.gz 
./google-cloud-sdk/install.sh

```

## Firebase setup
Install firebase if you don't have it
```bash
curl -sL https://firebase.tools | bash
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Login in and init project
```bash
firebase login
firebase init

flutterfire configure
```

## Usage
```bash
fvm flutter run
```

## Testing 
To run unit test just run
```bash
fvm flutter test
```

To run patrol integration-test
```bash
fvm dart pub global activate patrol_cli 3.11.0

export PATH="$PATH:$HOME/.pub-cache/bin"

fvm flutter build ios --config-only --debug --simulator

cd ios && pod install --repo-update && cd ..

patrol test
```

## Contributing
If you want to contribute to the development of this application, please follow the instructions below:

1. Fork the project.
2. Create your branch (git checkout -b feature/new-feature).
3. Make your changes and commit them (git commit -m 'Add new feature').
4. Push your branch (git push origin feature/new-feature).
5. Create a pull request (PR).

## License and links
[PrivacyPolicy](https://pocket-chips.blogspot.com/p/privacy-policy.html)

**Game on Stores**</br>
[![Google Play](https://img.shields.io/badge/Google_Play-%23414141.svg?logo=googleplay&logoColor=white)](https://play.google.com/store/apps/details?id=com.goliksim.pocketchips&hl=en&gl=US) [![RuStore](https://img.shields.io/badge/RuStore-%234e60af.svg?)](https://apps.rustore.ru/app/com.goliksim.pocketchips) [![RuStore](https://img.shields.io/badge/Web_Verson-%23968ad2.svg?)](https://apps.rustore.ru/app/com.goliksim.pocketchips) 

