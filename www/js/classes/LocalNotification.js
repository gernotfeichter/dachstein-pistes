class LocalNotification {

  static requestPermissionAndShow(message) {
    cordova.plugins.notification.local.schedule({
      title: message,
      foreground: true,
      autoClear: false,
      launch: true,
      led: true,
      lockscreen: true,
      silent: false,
      sound: true,
      sticky: false,
      timeoutAfter: false,
      vibrate: true
    });

  }
}