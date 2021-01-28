class State {
    constructor(pistes) {
        this.pistes = pistes;
    }

    toString() {
        return JSON.stringify({ pistes: Array.from(this.pistes) });
    }

    static fromString(serializedString) {
        var stateJson = JSON.parse(serializedString);

        var pisteObects = stateJson.pistes; // type Object
        var pistes = []; // Array of type Piste items
        pisteObects.forEach(currentPisteObject => {
            pistes.push(new Piste(currentPisteObject.name, currentPisteObject.state, currentPisteObject.notification, currentPisteObject.view));
        });

        return new State(new Set(pistes));
    }

    notifyPisteState(pisteNew) {
        console.debug(`notify piste state: ${pisteNew}`);
        let pisteOld = Array.from(this.pistes).find(obj => { return obj.name == pisteNew.name });
        if (pisteOld) {
            if (pisteOld.state == pisteNew.state) {
                console.debug(`piste state of ${pisteNew.name} remains ${pisteNew.state}: no notification`);
            } else {
                console.debug(`updating piste state of ${pisteNew} to ${pisteNew.state}`);
                let pisteOldInState = Array.from(this.pistes).find( piste => piste.name == pisteNew.name);
                console.debug(`found piste in state: ${pisteOldInState}`);
                pisteOldInState.state = pisteNew.state;
                console.debug(`piste state of ${pisteNew.name} changed ${pisteOld.state} from to ${pisteNew.state}: show notification if configured`);
                if (pisteOld.notification) { // Why not use pisteNew here? -> new Piste objects defaults to false for notifications, need to read from current state here!
                    console.debug(`notification is configured for piste ${pisteNew.name}, showing it to the user`);
                    try {
                        BrowserNotification.requestPermissionAndShow(`Piste ${pisteNew.name} changed from state ${pisteOld.state} to ${pisteNew.state}!`);   
                    } catch (error) {
                        console.error(`error showing piste notifications: ${error}`);
                    }
                } else {
                    console.debug(`notification is not configured for piste ${pisteNew.name}, not showing it to the user`);
                }
            }
        } else {
            console.debug(`adding new piste: ${pisteNew}: show notification if configured`);
            this.pistes.add(pisteNew);
            if (pisteNew.notification) {
                console.debug(`notification is configured for piste ${pisteNew.name}, showing it to the user`);
                BrowserNotification.requestPermissionAndShow(`Piste ${pisteNew.name} changed from state unknown to ${pisteNew.state}!`);
            } else {
                console.debug(`notification is not configured for piste ${pisteNew.name}, not showing it to the user`);
            }
        }
    }

    static default() {
        return new State(
            new Set(
                [
                    new Piste("Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)", Piste.STATE.UNKNOWN, true, true),
                    new Piste("Skitour Route Obertraun", Piste.STATE.UNKNOWN, true, true)
                ]
            )
        );
    }

}
