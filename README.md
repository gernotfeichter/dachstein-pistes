# dachstein_pistes

## metadata

Project was created with command
`flutter create --org com.gernotfeichter dachstein_pistes`
and flutter version `2.8.1`.

## test execution

### unit tests
`flutter test`

### widget tests
The widget tests can only be successfully run, with the `flutter run` instead of the `flutter test`
command for some reason, here is the snippet that works:
`flutter run -t test/widget/test_widget.dart -v -d linux`
Caveat: This command seems to run forever.

Ideas: 

### integration tests
TODO: Could possibly solve the widgets test problem, but right now there are none.