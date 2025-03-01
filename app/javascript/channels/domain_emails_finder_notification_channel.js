import consumer from "./consumer";

consumer.subscriptions.create("DomainEmailsFinderNotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data.message);
    const statusElement = document.querySelector("#processing-status");
    if (Array.isArray(data.message)) {
      statusElement.textContent = "";
      const emailList = document.createElement("ul");
      data.message.forEach((email) => {
        const li = document.createElement("li");
        li.textContent = email;
        emailList.appendChild(li);
      });
      statusElement.appendChild(emailList);
    } else {
      statusElement.textContent = data.message;
    }
  },

  notify: function () {
    return this.perform("notify");
  },
});
