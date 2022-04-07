# frozen_string_literal: true

# Create new category, show individual category details, list categories (index)
class CategoriesController < ApplicationController
  before_action :require_admin, except: %i[index show]
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = 'Category was successfully created'
      redirect_to @category
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    # pagination

    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def show
    @category = Category.find(params[:id]) 
    @articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    unless logged_in? && current_user.admin?
      flash[:alert] = 'Only admins can perfom that action'
      redirect_to categories_path
    end
  end
end
