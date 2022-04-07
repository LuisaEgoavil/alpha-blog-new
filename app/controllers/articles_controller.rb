# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :require_user, except: %i[show index]
  before_action :require_same_user, only: %i[edit update destroy]

  def show; end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    # binding.break
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      # flash helper
      flash[:notice] = 'Article was created successfully.'
      redirect_to @article
    else
      # on lesson this part is: "render 'new'" but the turbo library doesn't like 200 responses from POST submissions, that's why the solution below works. Issue here: https://github.com/hotwired/turbo-rails/issues/12#issuecomment-750326081
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      flash[:notice] = 'Article was updated successfully.'
      redirect_to @article
    else
      # on lesson this part is: "render 'edit' but doesn't work so solution down here:"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set_article
    @article.destroy
    # See issue here: https://guides.rubyonrails.org/getting_started.html
    redirect_to articles_path, status: :see_other
  end

  private

  # Define a method to be reusable
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:alert] = 'You can only edit or delete your own article'
      redirect_to @article
    end
  end
end
