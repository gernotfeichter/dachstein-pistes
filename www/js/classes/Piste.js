class Piste {
    constructor(name, status) {
        this.name = name;
        this.status = status;
    }

    toString() {
        return JSON.stringify({ name: this.name, status: this.status });
    }

    static fromString(serializedString) {
        var pisteJson = JSON.parse(serializedString);
        return new Piste(pisteJson.name, pisteJson.status);
    }

    static STATUS = {
        OPEN: 1,
        CLOSED: 2,
        WARNING: 3
    };

}
