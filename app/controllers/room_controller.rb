class RoomController < ApplicationController
  def index
  end

  def question
    datas = %w(苹果 香蕉 生梨 相机 太阳 月亮 大海 沙漠 鸟)
    datas2 = "对牛弹琴、冰糖葫芦、刻舟求剑、口红、七上八下、放风筝、台灯、钻戒、三头六臂、愚公移山、乌鸦喝水、如来神掌、跑步、火车、理发师、雷人、不入虎穴焉得虎子、仙人掌、耳机、打火机、汉堡、画饼充饥、虎头蛇尾、泪流满面、捧腹大笑、画蛇添足、一手遮天、掩耳盗铃、布娃娃、娃哈哈、CD、落地灯、内裤、烟斗、鹦鹉、钻戒、网址、牛肉面、母亲、刘翔、棉花、实验室、首饰、水波、衣橱、鲜花、小霸王、鲜橙多、土豆、音响、牛奶糖、语文书、扬州炒饭、NBA、篮球架、牛肉干、狮子座、油、秦始皇兵马俑、圣经、丸子、排插、守门员、KTV、全家桶、老爷车、空格键、医生、纸杯、腰带、针筒、手套、沙僧、升旗、工资、虎、除草剂、结婚证、蝴蝶、长江三峡、冬瓜、刀、教师、耳机、飞碟、大树、荷花、大头鱼、烘干机、击剑、豆沙包、耳、花朵、赤壁、监狱、环保、护膝、长颈漏斗".split("、")
    datas = datas + datas2
    question = datas.sample
    Redis::Value.new("chat_1_question").value = question
    render json: {
      question: question
    }
  end
end
