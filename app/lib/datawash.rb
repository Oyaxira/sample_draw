class Datawash

  def self.import_word
    datas = {
      "成语": %w(对牛弹琴 刻舟求剑 七上八下 愚公移山 乌鸦喝水 泪流满面 画饼充饥 捧腹大笑 画蛇添足 一手遮天 掩耳盗铃),
      "水果": %w(苹果 香蕉 生梨 桃子 西瓜 芒果),
      "名人": %w(爱因斯坦 马克思 恩格斯 秦始皇 关羽 张飞 刘备),
      "神话人物": %w(孙悟空 唐僧 猪八家 沙和尚 玉皇大帝 太上老君 如来佛祖),
      "名词": %w(蘑菇 大树 草坪 沙漠 天空 地球 宇宙 星星 太阳 月亮 虫子 显示器 键盘 鼠标 眼镜 眼镜 胡子),
      "动词": %w(画画 打球 吃饭 喝水 睡觉 偷懒)
    }

    datas.each do | k,v |
      v.each do |data|
        Word.find_or_create_by(name: data, word_type: k)
      end
    end
  end
end