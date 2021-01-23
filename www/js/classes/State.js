class State {
    constructor(pistes, notificationsForPistes) {
        this.pistes = pistes;
        this.notificationsForPistes = notificationsForPistes;
    }

    toString() {
        return JSON.stringify({ pistes: Array.from(this.pistes), notificationsForPistes: Array.from(this.notificationsForPistes) });
    }

    static fromString(serializedString) {
        var stateJson = JSON.parse(serializedString);

        var pisteObects = stateJson.pistes; // type Object
        var pistes = []; // type Piste
        pisteObects.forEach(currentPisteObject => {
            pistes.push(new Piste(currentPisteObject.name, currentPisteObject.status));
        });

        return new State(new Set(pistes), new Set(stateJson.notificationsForPistes));
    }

    notifyPisteState(pisteNew) {
        console.debug(`notify piste state: ${pisteNew}`);
        let pisteOld = Array.from(this.pistes).find( obj =>{ return obj.name == pisteNew.name });
        if ( pisteOld ) {
            if (pisteOld.state == pisteNew.state) {
                console.debug(`piste state of ${pisteNew.name} remains ${pisteNew.state}: no notification`);
            } else{
                console.debug(`piste state of ${pisteNew.name} changed from to ${pisteNew.state}: show notification if configured`);
                if (this.notificationsForPistes.has(pisteNew.name)) {
                    console.debug(`notification is configured for piste ${pisteNew.name}, showing it to the user`);
                    BrowserNotification.requestPermissionAndShow(`Piste ${pisteNew.name} changed from state ${pisteOld.state} to ${pisteNew.state}!`);
                } else {
                    console.debug(`notification is not configured for piste ${pisteNew.name}, not showing it to the user`);
                }
            }
        } else{
            console.debug(`adding new piste: ${pisteNew}: show notification if configured`);
            this.pistes.add(pisteNew);
            if (this.notificationsForPistes.has(pisteNew.name)) {
                console.debug(`notification is configured for piste ${pisteNew.name}, showing it to the user`);
                BrowserNotification.requestPermissionAndShow(`Piste ${pisteNew.name} changed from state unknown to ${pisteNew.state}!`);
            } else {
                console.debug(`notification is not configured for piste ${pisteNew.name}, not showing it to the user`);
            }
        }
    }

    static default() {
        let notificationsForPistes = new Set();
        notificationsForPistes.add("Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)");
        notificationsForPistes.add("Skitour Route Obertraun");
        return new State(
            new Set(),
            notificationsForPistes
        );
    }

}
