require 'RMagick'
require 'open-uri'
 
class ImageAnalyzer
 
  def self.run(attrs={})
    check attrs[:url]
  end
 
  private
  def self.check(url)
    url_image = open(url)
    img = Magick::ImageList.new.from_blob(url_image.read).first

    t = 0
    f = 0

    # 1pxずつ取り出して、RGBをチェックする
    img.color_histogram.inject({}) do |hash, key_val|
      red = key_val.first.red
      green = key_val.first.green
      blue = key_val.first.blue

      # ここが肌色判定のロジック
      if red > 60 && green < (red*0.85) && blue < (red*0.7) && green > (red*0.4) && blue > (red*0.2)
        t += 1
      else
        f += 1
      end
    end

    # 肌色が全体の50%以上か判定
    if t > f
      p "porno! #{t}, #{f} : #{url}"
    end  rescue => e
    p e.message
  end
end
