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
    @count = Image.count + 1

    @file_name = to_lower_underscore "#{@count} #{image[:category]} #{image[:title]}"

    @image.aws_file_name = @file_name
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
    @file_name = to_lower_underscore "#{@image.id} #{@image.category} #{@image.title}"

    if @file_name != @image.aws_file_name 
      if AWS::S3::S3Object.exists? @image.aws_file_name, current_bucket     
        AWS::S3::S3Object.rename(@image.aws_file_name, @file_name, current_bucket) 
      end

      @image.aws_file_name = @file_name
    end

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
    @categories = Category.find(:all, :select => 'name').map(&:name)
  end

  def destroy
    @image = Image.find(params[:id])

    if not @image.aws_file_name.blank?
      if AWS::S3::S3Object.exists? @image.aws_file_name, current_bucket
        AWS::S3::S3Object.delete @image.aws_file_name, current_bucket
      end
    end

    if @image.destroy
      redirect_to admin_index_path, notice: "Image was successfully deleted."
    else
      redirect_to back, error: "Image was unable to be deleted"
    end
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
