function pisteStateTable(pistes) {
  var myTableDiv = document.getElementById("pisteStateTable");

  var table = document.createElement('TABLE');

  var tableBody = document.createElement('TBODY');
  table.appendChild(tableBody);

  ['Piste', 'State', 'Notification', 'View on Widget'].forEach( currentHeader => {
    let th = document.createElement('TH');
    th.innerText = currentHeader;
    tableBody.appendChild(th);
  })

  Array.from(pistes).forEach(currentPiste => {
    let tr = document.createElement('TR');
    tableBody.appendChild(tr);
    ['name', 'state', 'notification', 'view'].forEach( pisteAttribute => {
      let td = document.createElement('TD');
      if (pisteAttribute == 'notification') {
        let notificationBell = document.createElement("I");
        if (currentPiste[pisteAttribute]) {
          notificationBell.className = 'fas fa-bell';
        } else {
          notificationBell.className = 'far fa-bell';
        }
        td.appendChild(notificationBell);
      } else if ( pisteAttribute == 'view' ) {
        let viewIcon = document.createElement("I");
        if (currentPiste[pisteAttribute]) {
          viewIcon.className = 'fas fa-eye';
        } else {
          viewIcon.className = 'far fa-eye';
        }
        td.appendChild(viewIcon);
      } else if ( pisteAttribute == 'state' ) {
        let statusIcon = document.createElement("I");
        if (currentPiste[pisteAttribute] == Piste.STATE.CLOSED ) {
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

  myTableDiv.appendChild(table);
}
