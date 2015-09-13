
require 'RMagick'
include Magick

# 画像を透過PNGのエッジ抽出画像に変換する

files = 

["food.jpg", "bike.jpg", "coffee.jpg"].each_with_index do |file, index|
  images = ImageList.new(file)
  # images[0].colorspace = GRAYColorspace
  # images[0].alpha = ActivateAlphaChannel
  # img2 = images[0].enhance().enhance()
  # images[0] = img2.edge(1);
  # images[0] = images.fx("r", AlphaChannel)
  # images[0] = images.fx("#5588DD")
  images.edge(100).write("#{file.split(".").first}-edge-out#{index+1}.jpg")
end


# require 'rubygems'
# require "RMagick"

# include Magick

# def edgedetect
#   white = Magick::Pixel.new(255, 255, 255)
#   black = Magick::Pixel.new(0, 0, 0)
#   threshold = 1200;

#   img = ImageList.new("holy.jpg")
#   x1 = 400
#   y1 = 300

#   base =  img.pixel_color(x1, y1)
#   next_x = img.pixel_color(x1+1, y1)
#   next_y = img.pixel_color(x1, y1+1)

#   puts "#{next_x.red} #{next_x.green} #{next_x.blue}"
#   puts "#{base.red} #{base.green} #{base.blue}"
#   puts "#{next_y.red} #{next_y.green} #{next_y.blue}"
#   for y in 0...img.rows
#     for x in 0...img.columns
#       src = img.pixel_color(x, y)
#       next_x = img.pixel_color(x+1, y)
#       next_y = img.pixel_color(x, y+1)

#       dr_x = src.red - next_x.red     # 対象座標の一つ右のピクセルとのRGB差分を計算(x軸傾き)
#       dg_x = src.green - next_x.green
#       db_x = src.blue - next_x.blue

#       dr_y = src.red - next_y.red     # 対象座標の一つ下のピクセルとのRGB差分を計算(y軸傾き)
#       dg_y = src.green - next_y.green
#       db_y = src.blue - next_y.blue

#       dr = dr_x*dr_x + dr_y*dr_y      # 対象座標のRGBごとの傾きを算出
#       dg = dg_x*dg_x + dg_y*dg_y
#       db = db_x*db_x + db_y*db_y

#       if dr + dg + db > threshold     # 傾きの合計がしきい値を超えていれば黒、以下なら白を出力(黒が輪郭)
#         img.pixel_color(x, y, black)
#       else
#         img.pixel_color(x, y, white)
#       end
#     end
#   end

#   img.write "holly_edge.jpg"
# end

# edgedetect
