# dachstein_pistes

## metadata

Project was created with command
`flutter create --org com.gernotfeichter dachstein_pistes`
and flutter version `2.8.1`.

## build & installation without debug flag
`flutter build apk`
`adb install ./build/app/outputs/apk/release/app-release.apk`

## test execution

### unit tests
`flutter test`
Remark: Executes all files in test folder ending in test.dart!

### widget tests
The widget tests can only be successfully run, with the `flutter run` instead of the `flutter test`
command for some reason, here is the snippet that works:
`flutter run -t test/widget/test_widget.dart -v -d "Pixel 5"`

Then check for output string `All tests passed!`.

Caveat: This command seems to run forever.

I believe that `flutter test` does not work due to some platform specific functionality that I use 
in some of my widget code that is only available in a real android application, the standard 
widget test environment seems to be not able to provide those.

Better use the [integration tests](#integration-tests) below.

### integration tests
`flutter test integration_test/test.dart -d "Pixel 5" --timeout 120s`

## releasing
1. increase version number in [pubspec.yaml](pubspec.yaml)
2. `flutter build appbundle`
3. upload [app bundle](build/app/outputs/bundle/release/app-release.aab) to 
   [Google Play Console](https://play.google.com/console)
   
## TODO Gernot
[] last refreshed overlaps pistes
[] first launch on Pixel 5 via play store failed with exception:
```
01-27 20:29:28.962  9397  9397 I DachsteinPistesJobLogger: job started: MainPageState.instanceSet=true isolate=336844168 pid=9397
01-27 20:29:29.570  9397  9397 W DachsteinPistesJobLogger: job failed with error Null check operator used on a null value
```