class CategoriesController < ApplicationController
  
  layout "admin"

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_index_path, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @user }
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
  end

  def update
  end

  def destroy
  end

  def index
  end

  def show
  end
end
