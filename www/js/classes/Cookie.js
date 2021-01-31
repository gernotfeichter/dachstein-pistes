// GPL-2.0-only
class Cookie {
    static name = "state"

    static expires = "Fri, 31 Dec 9999 23:59:59 GMT"

    static path = "/"

    static sameSite = "Strict"

    static showConsent(state) {
        console.debug(`Check if showing cookies consent is required: state.cookiesAccepted=${state.cookiesAccepted}`)
        if ( !state.cookiesAccepted ) {
            console.debug(`Showing cookies consent`)
            alert(`
            This app uses cookies.
    
            If you disagree, do NOT click "OK", instead close and uninstall the app.
    
            We use cookies for the following purposes:
            * Store the application state and use settings related to it
            * This includes the piste names, the state of the piste (open, closed, etc) and whether you want to be notified about piste state changes.
            `)
            state.cookiesAccepted = true;
        }
    }

}