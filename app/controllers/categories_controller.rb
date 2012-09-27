class CategoriesController < ApplicationController
  
  layout "admin"

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_index_path, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_index_path, notice: 'Category was successfully updated.' }
        format.json { render json: @category, status: :updated, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def index
    @categories = Category.all
  end

  def show
    render :layout => 'application'
    @category = Category.find(params[:id])
    @images = @category.images
  end
end
