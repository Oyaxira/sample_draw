// import ActionCable from 'actioncable'
import "./components/room.scss"
// (function () {
//   window.App || (window.App = {});

//   App.cable = ActionCable.createConsumer();

// }).call(this);
var $ = require('jquery')
import Konva from 'konva'

$(document).ready(function () {
  App.chatChannel = App.cable.subscriptions.create({
    channel: "ChatChannel",
    room: "1"
  }, {
    received: (data) => {
      let scrollDiv = document.createElement('div')
      scrollDiv.className = "speak-item"
      console.log(data)
      scrollDiv.textContent = data.message
      document.getElementById('speaker').appendChild(scrollDiv)
      $('#speaker').scrollTop($('#speaker')[0].scrollHeight)
    },
    speak: function (messages) {
      this.perform('speak', {
        message: messages
      })
    }
  })

  $("body").on('keypress', 'input.talk', (event) => {
    if (event.keyCode == 13) {
      App.chatChannel.speak(event.target.value)
      event.target.value = ""
      event.preventDefault()
    }
  })
  let sWidth = $("#draw")[0].offsetWidth
  let sHeight = $("#draw")[0].offsetHeight
  let stage = new Konva.Stage({
    container: 'draw',
    width: sWidth,
    height: sHeight
  });
  console.log(stage)
  let layer = new Konva.Layer();
  stage.add(layer);
  let canvas = document.createElement('canvas');
  canvas.width = stage.width() / 2;
  canvas.height = stage.height() / 2;
  console.log(canvas)
  let isPaint = false

  stage.addEventListener('mouseup touchend', function () {
    isPaint = false;
  });

  let image = new Konva.Image({
    image: canvas,
    x: stage.width() / 4,
    y: stage.height() / 4,
    stroke: 'green',
    shadowBlur: 5
  });
  layer.add(image);
  console.log(layer)
  console.log(image)
  stage.draw();

  let context = canvas.getContext('2d');
  context.strokeStyle = '#df4b26';
  context.lineJoin = 'round';
  context.lineWidth = 5;
  let lastPointerPosition;

  image.on('mousedown touchstart', function () {
    isPaint = true;
    lastPointerPosition = stage.getPointerPosition();
  });

  stage.addEventListener('mousemove touchmove', function () {
    if (!isPaint) {
      return;
    }
    context.globalCompositeOperation = 'source-over';
    context.beginPath();

    var localPos = {
      x: lastPointerPosition.x - image.x(),
      y: lastPointerPosition.y - image.y()
    };
    context.moveTo(localPos.x, localPos.y);
    var pos = stage.getPointerPosition();
    localPos = {
      x: pos.x - image.x(),
      y: pos.y - image.y()
    };
    context.lineTo(localPos.x, localPos.y);
    context.closePath();
    context.stroke();

    lastPointerPosition = pos;
    layer.batchDraw();
  });
})
