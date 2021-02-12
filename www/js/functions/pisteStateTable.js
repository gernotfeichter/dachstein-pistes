// GPL-2.0-only
function onViewChange(state, piste) {
  console.debug(`onViewChange for ${piste}`)
  piste.view = !piste.view
  State.writeState(state)
  pisteStateTable(state)
}

function onNotificationChange(state, piste) {
  console.debug(`onNotificationChange for ${piste}`)
  piste.notification = !piste.notification
  State.writeState(state)
  pisteStateTable(state)
}

function pisteStateTable(state) {

  var myTableDiv = document.getElementById("pisteStateTable")

  var table = document.createElement('TABLE')

  var tableHeader = document.createElement('THEAD')
  table.appendChild(tableHeader);
  ['Piste', 'State', 'Notify'].forEach(currentHeader => {
    let th = document.createElement('TH')
    th.innerText = currentHeader
    tableHeader.appendChild(th)
  })

  var tableBody = document.createElement('TBODY')
  table.appendChild(tableBody)
  Array.from(state.pistes).forEach(currentPiste => {
    let tr = document.createElement('TR')
    tableBody.appendChild(tr);
    ['name', 'state', 'notification'].forEach(pisteAttribute => {
      let td = document.createElement('TD')
      if (pisteAttribute == 'notification') {
        let notificationBell = document.createElement("I")
        if (currentPiste[pisteAttribute]) {
          notificationBell.textContent = 'notifications_active'
        } else {
          notificationBell.textContent = 'notifications_off';
        }
        notificationBell.className = 'material-icons'
        notificationBell.addEventListener("click", () => onNotificationChange(state, currentPiste))
        td.appendChild(notificationBell)
      } else if (pisteAttribute == 'view') { // feature is disabled, currently there is no widget to handle visibility
        let viewIcon = document.createElement("I")
        if (currentPiste[pisteAttribute]) {
          viewIcon.className = 'view-on'
        } else {
          viewIcon.className = 'view-off'
        }
        viewIcon.addEventListener("click", () => onViewChange(state, currentPiste))
        td.appendChild(viewIcon)
      } else if (pisteAttribute == 'state') {
        let statusIcon = document.createElement("I")
        if (currentPiste[pisteAttribute] == Piste.STATE.CLOSED) {
          statusIcon.textContent = 'block'
        } else if (currentPiste[pisteAttribute] == Piste.STATE.WARNING) {
          statusIcon.textContent = 'warning'
        } else if (currentPiste[pisteAttribute] == Piste.STATE.OPEN) {
          statusIcon.textContent = 'check_box'
        } else if (currentPiste[pisteAttribute] == undefined) {
          statusIcon.textContent = 'live_help'
        } else {
          console.error(`invalid piste state ${currentPiste[pisteAttribute]}`)
        }
        statusIcon.className = 'material-icons';
        td.appendChild(statusIcon)
      } else {
        td.appendChild(document.createTextNode(currentPiste[pisteAttribute]))
      }
      tr.appendChild(td)
    })
  })

  if (myTableDiv.children.length == 0) {
    myTableDiv.appendChild(table)
  } else {
    myTableDiv.replaceChild(table, myTableDiv.children[0])
  }

}
