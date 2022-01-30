# dachstein_pistes

Get notifications when piste state changes and view the current state of all pistes.

## End User Information
Currently only an android version exists that is published on [Google Play store](
https://play.google.com/store/apps/details?id=com.dachstein.pistes
).

Supporting other platforms is currently not planned.

## Development Information

### metadata

Project was created with command
`flutter create --org com.gernotfeichter dachstein_pistes`
and flutter version `2.8.1`.

### build & installation without debug flag
`flutter build apk`
`adb install ./build/app/outputs/apk/release/app-release.apk`

### test execution

#### unit tests
`flutter test`
Remark: Executes all files in test folder ending in test.dart!

#### widget tests
The widget tests can only be successfully run, with the `flutter run` instead of the `flutter test`
command for some reason, here is the snippet that works:
`flutter run -t test/widget/test_widget.dart -v -d "Pixel 5"`

Then check for output string `All tests passed!`.

Caveat: This command seems to run forever.

I believe that `flutter test` does not work due to some platform specific functionality that I use 
in some of my widget code that is only available in a real android application, the standard 
widget test environment seems to be not able to provide those.

Better use the [integration tests](#integration-tests) below.

#### integration tests
`flutter test integration_test/test.dart -d "Pixel 5" --timeout 120s`

### releasing
1. run [integration tests](#integration-tests)
1. increase version number in [pubspec.yaml](pubspec.yaml)
1. `flutter build appbundle`
1. upload [app bundle](build/app/outputs/bundle/release/app-release.aab) to 
   [Google Play Console](https://play.google.com/console) for Internal Testing
1. commit state: `g commit -a -m "chore(release): <version number>"`   

## License

This program is published under the [GNU GENERAL PUBLIC LICENSE
Version 2](LICENSE).