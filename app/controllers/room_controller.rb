class RoomController < ApplicationController
  def index
  end

  def question
    datas = %w(苹果 香蕉 生梨 相机 太阳 月亮 大海 沙漠 鸟)
    question = datas.sample
    Redis::Value.new("chat_1_question").value = question
    render json: {
      question: question
    }
  end
end
