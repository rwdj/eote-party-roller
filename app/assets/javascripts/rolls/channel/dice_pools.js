this.App = {};

App.cable = ActionCable.createConsumer();

App.dice_pools = App.cable.subscriptions.create('DicePoolsChannel', {
  received: function(data) {
    const wasScrolledToBottom = this.isScrolledToBottom();
    $('#dice-pools').append(this.renderDicePool(data));

    if (!wasScrolledToBottom) window.scrollBy(0, 10000);
    return;
  },

  renderDicePool: function(data) {
    spoiler_line = /^<div class="tooltip">dnr/i.test(data.purpose) ? ' class="spoiler"' : ''; // TODO: cleanup
    return [
      '<tr' + spoiler_line + '>',
      '<td>' + data.roller + '</td>',
      '<td>' + data.purpose + '</td>',
      '<td>' + data.dice + '</td>',
      '<td>' + data.result + '</td>',
      '</tr>'
    ].join();
  },

  isScrolledToBottom: function() {
    return window.scrollTop + $( window ).height() == this.getHeight(document);
  },

  getHeight: function(doc) {
    return Math.max(
        doc.body.scrollHeight, doc.documentElement.scrollHeight,
        doc.body.offsetHeight, doc.documentElement.offsetHeight,
        doc.body.clientHeight, doc.documentElement.clientHeight
    );
  },
});
