class ArticlesController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_if_should_be_archived

  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def report
    @article = Article.find(params[:id])
    @article.increment!(:report_count)
    if @article.report_count >= 3
      @article.update(archived: true)
    end
    redirect_to @article, notice: "you report this article"
  end



  def destroy
    @article.destroy!
    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :report_count, :avatar)
  end
end
