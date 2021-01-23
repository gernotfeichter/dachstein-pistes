class BrowserNotification {

    static requestPermissionAndShow(message) {
        // Let's check if the browser supports notifications
        if (!("Notification" in window)) {
          console.error("This browser does not support desktop notifications");
        }
      
        // Let's check whether notification permissions have already been granted
        else if (Notification.permission === "granted") {
          // If it's okay let's create a notification
          this.show(message);
        }
      
        // Otherwise, we need to ask the user for permission
        else if (Notification.permission !== "denied") {
          Notification.requestPermission().then(function (permission) {
            // If the user accepts, let's create a notification
            if (permission === "granted") {
              this.show(message);
            }
          });
        }
      
        // At last, if the user has denied notifications, and you
        // want to be respectful there is no need to bother them any more.
      }

    static show(message) {
        let notification = new Notification(message);
    }

}
