class ImagesController < ApplicationController

  layout "admin"

  def new
    @image = Image.new
    @categories = Category.find(:all, :select => 'name').map(&:name)
  end

  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to admin_index_path, notice: 'Category was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
  end
end
