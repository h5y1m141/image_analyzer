# https://gist.github.com/dannvix/2157015
require 'RMagick'
include Magick

class Sobel
  require 'RMagick'
  include Magick
  @@kernels = {
    :up => [1, 2, 1, 0, 0, 0, -1, -2, -1],
    :down => [-1, -2, -1, 0, 0, 0, 1, 2, 1],
    :left => [1, 0, -1, 2, 0, -2, 1, 0, -1],
    :right => [-1, 0, 1, -2, 0, 2, -1, 0, 1]
  }

  def self.apply (source, type=:all)
    result = source.dup.quantize(256, GRAYColorspace)

    vertical = lambda { result = result.convolve(3, @@kernels[:up]).convolve(3, @@kernels[:down]) }
    horizental = lambda { result = result.convolve(3, @@kernels[:left]).convolve(3, @@kernels[:right]) }

    case type
    when :all
      vertical.call
      horizental.call
    when :vertical
      vertical.call
    when :horizental
      horizental.call
    end

    result
  end
end

["food.jpg", "bike.jpg", "coffee.jpg","coffee-blur.jpg"].each_with_index do |file, index|
  img = ImageList.new(file)
  result = Sobel.apply(img, :horizental)
  result.write("#{file.split(".").first}-sobel-out#{index+1}.jpg")
end
