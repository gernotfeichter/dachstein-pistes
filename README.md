# Execute

## Run

`cordova run browser`
`cordova run android`

## Debug

open url in chrome: `chrome://inspect/#devices` and connect to your device (emulator or real phone)

## Developer Notes
### cors
* cors is allowed via cordova whitelisting plugin for mobile devices
* for local development/usage allow the domain via a cors browser plugin
### state
* all state is handled via cookies
* resetting via chrome does not work (at leat for android emultated app)\
  snippet to run in js console for manual reset:
  ```js
  document.cookie = `${Cookie.name}={};expires=Thu, 01 Jan 1970 00:00:00 GMT;path=<${Cookie.path}`;
  ```

# Status

TODO:
* Regular Polling
* Tabular Response Parsing
* Regex Table Reduce
* Notifications on Status Change
* Publish
