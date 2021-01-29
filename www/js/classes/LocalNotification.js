class LocalNotification {

  static notificationCounter = 0;

  static requestPermissionAndShow(message) {
    cordova.plugins.notification.local.schedule({
      id: this.notificationCounter,
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
      vibrate: true,
    });
    this.notificationCounter ++;
  }
}