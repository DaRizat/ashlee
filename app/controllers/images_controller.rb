class ImagesController < ApplicationController

  layout "admin"

  require("aws/s3")
  before_filter :connect_to_s3, :only => [:create, :destroy]

  def new
    @image = Image.new
    @categories = Category.find(:all, :select => 'name').map(&:name)
  end

  def create
    image = params[:image]
    @image = Image.new :title => image[:title], :category_id => Category.find_by_name(image[:category]), :caption => image[:caption], :feature => image[:feature]

    @file_name = to_lower_underscore "#{image[:category]} #{image[:title]}"

    @image.url = "http://s3.amazonaws.com/#{current_bucket}/#{@file_name}"

    AWS::S3::S3Object.store(@file_name, open(image[:file]), current_bucket, :access => :public_read)

    respond_to do |format|
      if @image.save
        format.html { redirect_to admin_index_path, notice: 'Image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
      if @image.save
        format.html { redirect_to admin_index_path, notice: 'Image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
  end

  def edit
    @image = Image.find params[:id]
  end

  def destroy
    Image.destroy params[:id]
    redirect_to admin_index_path, notice: "Image was successfully deleted."
  end

  def index
    @images = Image.all
  end

private

  def current_bucket
    @current_bucket ||= "ashlee"
  end

  def to_lower_underscore string
    string.downcase!
    string.gsub!(/\s/, "_")
  end

end
