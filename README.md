# dachstein_pistes

## metadata

Project was created with command
`flutter create --org com.gernotfeichter dachstein_pistes`
and flutter version `2.8.1`.

## test execution

### unit tests (currently there are none)
`flutter test`

### widget tests (currently broken)
The widget tests can only be successfully run, with the `flutter run` instead of the `flutter test`
command for some reason, here is the snippet that works:
`flutter run -t test/widget/test_widget.dart -v -d "Pixel 5"`
Caveat: This command seems to run forever.
Better use the [integration tests](#integration-tests) below.

### integration tests
`flutter test integration_test/test.dart -d "Pixel 5" --timeout 60s`

## TODOS
[] bug?: W/AlarmService(  751): Attempted to start a duplicate background isolate. Returning...
[] reset interval in seed to 60 minutes