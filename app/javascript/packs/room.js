// import ActionCable from 'actioncable'
import "./components/room.scss"
// (function () {
//   window.App || (window.App = {});

//   App.cable = ActionCable.createConsumer();

// }).call(this);
var $ = require('jquery')
let layer;
let isStarted = false
import Konva from 'konva'
let mode = "huabi"
let isMain = false
function gHuaban(){
  let sWidth = $("#draw")[0].offsetWidth
  let sHeight = $("#draw")[0].offsetHeight
  let stage = new Konva.Stage({
    container: 'draw',
    width: sWidth,
    height: sHeight
  });
  console.log(stage)
  layer = new Konva.Layer();
  stage.add(layer);
  let canvas = document.createElement('canvas');
  canvas.width = stage.width();
  canvas.height = stage.height();
  console.log(canvas)
  let isPaint = false

  stage.addEventListener('mouseup touchend', function () {
    isPaint = false;
    let img = layer.toDataURL({
      mimeType: "image/jpeg",
      quality: 1,
      pixelRatio: 0.5,
    })
    console.log(layer.toJSON())
    App.chatChannel.broadcastJpg(img);
  });

  let image = new Konva.Image({
    image: canvas,
    x: 0,
    y: 0,
    stroke: 'green',
    shadowBlur: 5
  });
  layer.add(image);
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

    if (mode == "huabi") {
      context.globalCompositeOperation = 'source-over';
      context.lineWidth = 5;
    } else if (mode == "xiangpi") {
      context.globalCompositeOperation = 'destination-out';
      context.lineWidth = 10;
    }
    context.beginPath();

    let localPos = {
      x: lastPointerPosition.x - image.x(),
      y: lastPointerPosition.y - image.y()
    };
    context.moveTo(localPos.x, localPos.y);
    let pos = stage.getPointerPosition();
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
}

function gShowBan(){
  $(".main-container").hide()
  $(".show-container").show()
}

$(document).ready(function () {
  App.chatChannel = App.cable.subscriptions.create({
    channel: "ChatChannel",
    room: "1"
  }, {
    received: (data) => {
      if (data.type == "broadcastJpg"){
        if(!isMain){
          let image = document.createElement('img')
          image.src = data.data.img
          image.style = "width:100%;height:100%"
          document.getElementById('speaker')
          $(".show-container").children().remove()
          $(".show-container").append(image)
        }
      } else if (data.type == "endDraw") {
        let message = "有人结束了画画"
        isStarted = false
        $(".show-container").children().remove()
        $(".show-container").hide()
        $(".draw-container").hide()
        $(".main-container").show()
        let scrollDiv = document.createElement('div')
        scrollDiv.className = "speak-item"
        scrollDiv.textContent = message
        document.getElementById('speaker').appendChild(scrollDiv)
        $('#speaker').scrollTop($('#speaker')[0].scrollHeight)
      } else{
        let message = ""
        if (data.type == "newMessage") {
          message = data.data
        } else if (data.type == "startDraw" && !isStarted) {
          message = "有人开始画画啦"
          isStarted = true
          !isMain && gShowBan()
          if (data.img){
            let image = document.createElement('img')
            image.src = JSON.parse(data.img).img
            image.style = "width:100%;height:100%"
            $(".show-container").children().remove()
            $(".show-container").append(image)
          }

        }
        let scrollDiv = document.createElement('div')
        scrollDiv.className = "speak-item"
        scrollDiv.textContent = message
        document.getElementById('speaker').appendChild(scrollDiv)
        $('#speaker').scrollTop($('#speaker')[0].scrollHeight)
      }
    },
    speak: function (messages) {
      this.perform('speak', {
        message: messages
      })
    },
    startDraw: function () {
      this.perform('startDraw', {
        user: "用户1"
      })
    },
    broadcastJpg: function(img) {
      this.perform('broadcastJpg', {
        img: img
      })
    },
    connected: function (data) {
      this.perform("checkStatus",{})
    }
  })

  $("#draw-tool").on("click",".tool", function(event){
    let name = $(this).data("name")
    if(name == "clear"){
      gHuaban()
      let img = layer.toDataURL({
        mimeType: "image/jpeg",
        quality: 1,
        pixelRatio: 0.5,
      })
      App.chatChannel.broadcastJpg(img);
    }else{
      $("#draw-tool .tool").removeClass("selected")
      $(this).addClass("selected")
      mode = name
    }

  })

  $("body").on('keypress', 'input.talk', (event) => {
    if (event.keyCode == 13) {
      App.chatChannel.speak(event.target.value)
      event.target.value = ""
      event.preventDefault()
    }
  })

  $("#start-draw").on("click", function () {
    App.chatChannel.startDraw();
    isMain = true
    isStarted = true
    $(".main-container").hide()
    $(".draw-container").show()
    gHuaban()
  })

})
