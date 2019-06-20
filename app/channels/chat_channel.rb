class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"
  end

  def receive(data)
    # ActionCable.server.broadcast("chat_#{params[:room]}", data)
  end

  def checkStatus(data)
    if Redis::Value.new("chat_#{params[:room]}").value == "started"
      message = {
        type: "startDraw"
      }
      ActionCable.server.broadcast("chat_#{params[:room]}", message)
    end
  end

  def speak(data)
    if data["message"] == "结束"
      Redis::Value.new("chat_#{params[:room]}").value = nil
      message = {
        type: "endDraw"
      }
      ActionCable.server.broadcast("chat_#{params[:room]}", message)
    else
      message = {
        type: "newMessage",
        data: data["message"]
      }
      ActionCable.server.broadcast("chat_#{params[:room]}", message)
    end
  end

  def startDraw(data)
    message = {
      type: "startDraw"
    }
    ActionCable.server.broadcast("chat_#{params[:room]}", message)
    Redis::Value.new("chat_#{params[:room]}").value = "started"
  end

  def broadcastJpg(img)
    message = {
      type: "broadcastJpg",
      data: img
    }
    ActionCable.server.broadcast("chat_#{params[:room]}", message)
  end
end