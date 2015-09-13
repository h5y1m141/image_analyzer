require 'RMagick'
require 'paint'

class RmagickCompileColor
  # この百分率未満は非表示
  RATE_MIN = 0.1
  attr_accessor :colors

  def initialize(file, out_file)
    @img = Magick::ImageList.new(file)
    # web safe color用の設定
    @map = Magick::ImageList.new "netscape:"
    @out_file = out_file
    # ピクセル数
    @px_x = @img.columns       # 横
    @px_y = @img.rows          # 縦
    @px_total = @px_x * @px_y  # トータル
    @colors = []
  end

  # 使用色集計
  def compile
    begin
      # @img.quantize(256)
      mapped = @img.map @map, false
      after = mapped.append false
      after.write(Pathname.pwd.join('target', @out_file))
      reduce_img = Magick::ImageList.new(Pathname.pwd.join('target', @out_file))
      # @img.write(Pathname.pwd.join('target', @out_file))
      # @img.write(@out_file)

      # 画像の Depth を取得
      img_depth = reduce_img.depth

      # カラーヒストグラムを取得してハッシュで集計
      hist = reduce_img.color_histogram.inject({}) do |hash, key_val|
        # 各ピクセルの色を16進で取得
        color = key_val[0].to_color(Magick::AllCompliance, false, img_depth, true)
        # Hash に格納
        hash[color] ||= 0
        hash[color] += key_val[1]
        hash
      end

      # ヒストブラムのハッシュを値の大きい順にソート
      @hist = hist.sort{|a, b| b[1] <=> a[1]}
    rescue => e
      STDERR.puts "[ERROR][#{self.class.name}.compile] #{e}"
      exit 1
    end
  end

  # 結果表示
  def display
    begin
      @hist.each do |color, count|
        rate = (count / @px_total.to_f) * 100
        break if rate < RATE_MIN
        @colors.push({color: color, count: count })
        puts "#{color} => #{count} px ( #{sprintf("%2.4f", rate)} % )"
      end
      puts
      puts "Image Size: #{@px_x} px * #{@px_y} px"
      # puts "TOTAL     : #{@px_total} px, #{@hist.size} colors"
    rescue => e
      STDERR.puts "[ERROR][#{self.class.name}.display] #{e}"
      exit 1
    end
  end
end


Dir.glob("img/*").each_with_index do |file, index|

  # obj_main = RmagickCompileColor.new(file, Pathname.pwd.join('/target/', file.split("/").last))
  obj_main = RmagickCompileColor.new(file, file.split("/").last)
  obj_main.compile
  obj_main.display
  # obj_main.colors.each{|o| puts o[:color]}
  # puts obj_main.colors.count
end
