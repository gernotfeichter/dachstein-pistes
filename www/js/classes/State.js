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
        return new State(new Set(stateJson.pistes), new Set(stateJson.notificationsForPistes));
    }

    notifyPisteState(pisteNew) {
        console.debug(`notify piste state: ${pisteNew}`);
        if (this.pistes.has(pisteNew.name)) {
            var pisteOld = this.pistes.get(pisteNew.name);
            if (pisteOld.state == pisteNew.state) {
                console.debug(`piste state of ${pisteNew.name} remains ${pisteNew.state}: no notification`);
            } else{
                console.debug(`piste state of ${pisteNew.name} changed from to ${pisteNew.state}: show notification if configured`);
                if (this.notificationsForPistes.get(pisteNew.name)) {
                    console.debug(`notification is configured for piste ${pisteNew.name}, showing it to the user`);
                }
            }
        } else{
            console.debug(`adding new piste: ${pisteNew}`);
        }
        this.pistes.add(pisteNew);
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
