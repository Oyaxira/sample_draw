class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"
    count = Redis::Value.new("chat_#{params[:room]}_member")
    count.value = 0 if count.value.to_i < 0
    count.value = count.value.to_i + 1
  end

  def unsubscribed
    count = Redis::Value.new("chat_#{params[:room]}_member")
    count.value = count.value.to_i - 1
    count.value = 0 if count.value.to_i < 0
    if count.value.to_i == 0
      Redis::Value.new("chat_#{params[:room]}").value = nil
    end
    message = {
      type: "enter",
      message: "#{current_user}离开了房间, 当前人数(#{count.value})"
    }
    ActionCable.server.broadcast("chat_#{params[:room]}", message)
  end

  def receive(data)
    # ActionCable.server.broadcast("chat_#{params[:room]}", data)
  end

  def checkStatus(data)
    if Redis::Value.new("chat_#{params[:room]}").value == "started"
      message = {
        type: "startDraw",
        img: Redis::Value.new("chat_#{params[:room]}_last_draw").value,
        user_name: Redis::Value.new("chat_#{params[:room]}_last_drawer").value,
      }
      ActionCable.server.broadcast("chat_#{params[:room]}", message)
    end
    count = Redis::Value.new("chat_#{params[:room]}_member")
    message = {
      type: "enter",
      message: "#{current_user}进入了房间, 当前人数(#{count.value})"
    }
    ActionCable.server.broadcast("chat_#{params[:room]}", message)
  end

  def speak(data)
    if data["message"] == "结束"
      Redis::Value.new("chat_#{params[:room]}").value = nil
      Redis::Value.new("chat_#{params[:room]}_last_draw").value = {}.to_json
      message = {
        type: "endDraw"
      }
      ActionCable.server.broadcast("chat_#{params[:room]}", message)
      Redis::Value.new("chat_#{params[:room]}_last_drawer").value = nil
    else
      question = Redis::Value.new("chat_1_question").value
      is_finished = question.present? && data["message"] == question
      msg = data['message']
      if current_user.present?
        msg = "#{current_user}：#{msg}"
      end
      message = {
        type: "newMessage",
        data: msg,
        is_finished: is_finished,
        finish_name: current_user
      }
      ActionCable.server.broadcast("chat_#{params[:room]}", message)
      if is_finished
        Redis::Value.new("chat_#{params[:room]}").value = nil
        Redis::Value.new("chat_#{params[:room]}_last_draw").value = {}.to_json
        Redis::Value.new("chat_1_question").value = nil
        Redis::Value.new("chat_#{params[:room]}_last_drawer").value = nil
      end
    end
  end

  def startDraw(data)
    message = {
      type: "startDraw",
      user_name: current_user
    }
    ActionCable.server.broadcast("chat_#{params[:room]}", message)
    Redis::Value.new("chat_#{params[:room]}").value = "started"
    Redis::Value.new("chat_#{params[:room]}_last_draw").value = {}.to_json
    Redis::Value.new("chat_#{params[:room]}_last_drawer").value = current_user
  end

  def broadcastJpg(img)
    message = {
      type: "broadcastJpg",
      data: img
    }
    Redis::Value.new("chat_#{params[:room]}_last_draw").value = img.to_json
    ActionCable.server.broadcast("chat_#{params[:room]}", message)
  end
end