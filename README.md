# dachstein_pistes

## metadata

Project was created with command
`flutter create --org com.gernotfeichter dachstein_pistes`
and flutter version `2.8.1`.

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
widget test environment seems to be not able to provide those. This unfortunately also means
that those 

Better use the [integration tests](#integration-tests) below.

### integration tests
`flutter test integration_test/test.dart -d "Pixel 5" --timeout 120s`

## TODO Gernot
[] longer duration test