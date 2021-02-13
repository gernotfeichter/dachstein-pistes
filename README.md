# Dachstein Pistes

Get notifications when piste state changes and view the current state of all pistes.

## End User Guide
Currently only an android version exists that is published on Google Play store.

Supporting other platforms is currently not planned.

## Developer Guide

### Dependencies
* node: v14.15.4
* cordova: 10.0.0
* Android Studio: 201.6953283-linux

### Run

`cordova run browser`\
`cordova run android`

### Release
`cordova build android --release`

### Debug

open url in chrome: `chrome://inspect/#devices` and connect to your device (emulator or real phone)

### Developer Notes
#### cors
* cors is allowed via cordova whitelisting plugin for mobile devices
* for local development/usage allow the domain via a cors browser plugin
#### state
* all state is handled via cookies
* resetting via chrome does not work for webview (at leat for android emultated app)\
  snippet to run in js console for manual reset:
  ```js
  document.cookie = `${Cookie.name}={};expires=Thu, 01 Jan 1970 00:00:00 GMT;path=<${Cookie.path}`
  ```

## License

This program is published under the [GNU GENERAL PUBLIC LICENSE
                       Version 2](LICENSE).

See also the [NOTICE](www/NOTICE.html).