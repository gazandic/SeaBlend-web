require "rubygems"
require "bundler/setup"
require "rails/all"
require "base64"
require "opencv"
include OpenCV

class ImageBlendController < ApplicationController
  protect_from_forgery with: :null_session

  def index

  end

  def create
    x = params['x']
    y = params['y']
    width = params['width']
    height = params['height']
    begin
      img = Base64.decode64(params['img']['data:image/png;base64,'.length .. -1])
      temp2 = Rails.root.join('public', "img", "frame.png").to_s
      image = CvMat.decode_image(img, 1)
      crop = image.sub_rect(x, y, width, height)
      if width > 700
        width /= (width / 700)
        height /= (height / 700)
      end
      image2 = CvMat.load(temp2,  CV_LOAD_IMAGE_UNCHANGED) # Read the file.
      size = CvSize.new(height, width)
      crop2 = image2.resize(size)
      crop = crop.resize(size)
      i = 0
      while i < crop2.size.height do
        j = 0
        while j < crop2.size.width do
          crop[i,j] = crop2[i,j] unless 255 == crop2[i,j].to_a[0]
          j += 1
        end
        i += 1
      end
      name = Time.now.to_s + ".jpg"
      puts name
      temp = Rails.root.join('public', "img", name).to_s
      crop.save_image(temp)
      data = Base64.encode64(File.read(temp)).gsub("\n", '')
      uri  = "data:image/jpg;base64,#{data}"
      File.delete(temp) if File.exist?(temp)
      respond_to do |format|
        format.json { render json: {"status" => "success", "data" => uri}}
      end
    rescue => e
      puts e.message
      respond_to do |format|
        format.json { render json: {"status" => "error"}}
      end
      exit
    end
  end
end
