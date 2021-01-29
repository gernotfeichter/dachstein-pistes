function onViewChange(state, piste) {
  console.debug(`onViewChange for ${piste}`);
  piste.view = !piste.view;
  writeState(state);
  pisteStateTable(state);
}

function onNotificationChange(state, piste) {
  console.debug(`onNotificationChange for ${piste}`);
  piste.notification = !piste.notification;
  writeState(state);
  pisteStateTable(state);
}

function pisteStateTable(state) {

  var myTableDiv = document.getElementById("pisteStateTable");

  var table = document.createElement('TABLE');

  var tableHeader = document.createElement('THEAD');
  table.appendChild(tableHeader);
  ['Piste', 'State', 'Notification', 'View on Widget'].forEach(currentHeader => {
    let th = document.createElement('TH');
    th.innerText = currentHeader;
    tableHeader.appendChild(th);
  })


  var tableBody = document.createElement('TBODY');
  table.appendChild(tableBody);

  Array.from(state.pistes).forEach(currentPiste => {
    let tr = document.createElement('TR');
    tableBody.appendChild(tr);
    ['name', 'state', 'notification', 'view'].forEach(pisteAttribute => {
      let td = document.createElement('TD');
      if (pisteAttribute == 'notification') {
        let notificationBell = document.createElement("I");
        if (currentPiste[pisteAttribute]) {
          notificationBell.className = 'fas fa-bell';
        } else {
          notificationBell.className = 'far fa-bell-slash';
        }
        notificationBell.addEventListener("click", () => onNotificationChange(state, currentPiste));
        td.appendChild(notificationBell);
      } else if (pisteAttribute == 'view') {
        let viewIcon = document.createElement("I");
        if (currentPiste[pisteAttribute]) {
          viewIcon.className = 'fas fa-eye';
        } else {
          viewIcon.className = 'far fa-eye-slash';
        }
        viewIcon.addEventListener("click", () => onViewChange(state, currentPiste));
        td.appendChild(viewIcon);
      } else if (pisteAttribute == 'state') {
        let statusIcon = document.createElement("I");
        if (currentPiste[pisteAttribute] == Piste.STATE.CLOSED) {
          statusIcon.className = 'fas fa-ban';
        } else if (currentPiste[pisteAttribute] == Piste.STATE.WARNING) {
          statusIcon.className = 'fas fa-exclamation-triangle';
        } else if (currentPiste[pisteAttribute] == Piste.STATE.OPEN) {
          statusIcon.className = 'fas fa-plus-circle';
        } else if (currentPiste[pisteAttribute] == undefined) {
          statusIcon.className = 'far fa-question-circle';
        } else {
          console.error(`invalid piste state ${currentPiste[pisteAttribute]}`);
        }
        td.appendChild(statusIcon);
      } else {
        td.appendChild(document.createTextNode(currentPiste[pisteAttribute]));
      }
      tr.appendChild(td);
    })
  });

  if (myTableDiv.children.length == 0) {
    myTableDiv.appendChild(table);
  } else {
    myTableDiv.replaceChild(table, myTableDiv.children[0]);
  }

}
