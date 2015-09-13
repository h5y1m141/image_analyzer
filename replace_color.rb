require "rubygems"
require "RMagick"

include Magick

img = ImageList.new("food.jpg")

compare = Magick::Pixel.new(142*256,72*256,2*256) # この色と近い領域を探す
replace = Magick::Pixel.new(255*256,0,0) # この色で塗りつぶす
for y in 0...img.rows
  for x in 0...img.columns
    src = img.pixel_color(x, y) # 元画像のピクセルを取得

    dr = src.red - compare.red # 赤要素の差
    dg = src.green - compare.green # 緑要素の差
    db = src.blue - compare.blue # 青要素の差

    # RGB空間上において2つの色が近ければ置換する
    img.pixel_color(x, y, replace) if dr*dr + dg*dg + db*db < (30*256*30*256)*3
  end
end

img.write("food-out.jpg")
