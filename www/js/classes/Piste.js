// GPL-2.0-only
class Piste {
    constructor(name, status, notification, view) {
        this.name = name
        this.state = status
        this.notification = notification
        this.view = view
    }

    setDefaults() {
        this.name = null
        this.state = Piste.STATE.UNKNOWN
        this.notification = false
        this.view = false
    }

    toString() {
        return JSON.stringify({ name: this.name, status: this.state, notification: this.notification, view: this.view })
    }

    static STATE = {
        OPEN: 'open',
        CLOSED: 'closed',
        WARNING: 'warning',
        UNKNOWN: 'unknown'
    }

}
