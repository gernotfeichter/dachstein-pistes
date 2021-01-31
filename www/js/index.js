/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

// Wait for the deviceready event before using any of Cordova's device APIs.
// See https://cordova.apache.org/docs/en/latest/cordova/events/events.html#deviceready
document.addEventListener('deviceready', onDeviceReady, false)

function onDeviceReady() {
    cordova.plugins.autoStart.enable()
    let inveralMilliseconds = 60 * 60 * 1000; // 1h
    startMainLoop(inveralMilliseconds)
}


function startMainLoop(inveralMilliseconds) {
    main()
    let intervalId = setInterval(function () {
        console.debug(`Interval reached: ${inveralMilliseconds}ms passed, refreshing`)
        main()
    }, inveralMilliseconds)
}

function main() {
    var state = State.readState(Cookie.name)
    console.debug(`read state : ${state}`)
    Cookie.showConsent(state)

    console.debug('starting query')
    var fetchResult = fetch('https://www.derdachstein.at/de/dachstein-aktuell/gletscherbericht', {
        method: 'GET',
    })
        .then(function (response) {
            return response.text()
        })
        .then(function (html) {
            var parser = new DOMParser()
            var doc = parser.parseFromString(html, 'text/html')

            var table = doc.getElementById('accordion-pisten-dachstein').querySelector('table'),
                rows = table.rows, rowcount = rows.length, r,
                cells, cellcount, cellIndex, cell

            console.debug("start table scan")

            for (r = 1; r < rowcount; r++) {
                cells = rows[r].cells
                cellcount = cells.length
                let currentPiste = new Piste()
                currentPiste.setDefaults()
                for (cellIndex = 0; cellIndex < cellcount; cellIndex++) {
                    cell = cells[cellIndex]
                    if (cellIndex == 0) {
                        // parse piste status
                        let cellString = cell.innerHTML
                        if (cellString.includes("status bg-danger")) {
                            currentPiste.state = Piste.STATE.CLOSED
                            continue
                        }
                        if (cellString.includes("status bg-success")) {
                            currentPiste.state = Piste.STATE.OPEN
                            continue
                        }
                        if (cellString.includes("status bg-warning")) {
                            currentPiste.state = Piste.STATE.WARNING
                            continue
                        }
                        console.error(`could not parse piste state for piste of table row ${r} cell ${cellIndex}!`)
                    }
                    // cellIndex == 1 would be type (red, black piste etc.), but irrelevant here
                    // cellIndex == 2 speculation: if type warning there would be a warning text here
                    if (cellIndex == 3) {
                        let cellString = cell.innerText.trim()
                        // parse piste name
                        if (cellString) {
                            currentPiste.name = cellString
                            // update piste state
                            state.notifyPisteState(currentPiste)
                        } else {
                            console.error(`could not parse piste name for piste of table row ${r} cell ${cellIndex}!`)
                        }
                    }
                }
            }
            console.debug("finished table scan without errors")
            return
        })
        .catch(function (error) {
            console.error(error)
        })

    fetchResult.then(() => {
        console.debug(`write state: ${state}`)
        State.writeState(state)
        pisteStateTable(state)
    })
}


