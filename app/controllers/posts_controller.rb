class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:tag]
      @tag = Tag.find_by(name: params[:tag])
      @posts = @tag.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    else
      @posts = Post.all.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    end
  end
  

  def show
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post criado com sucesso!'
    else
      render :new
    end
  end

  def edit
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to posts_path, alert: 'Você não tem permissão para editar este post.'
    end
  end
  

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: 'Post atualizado com sucesso!'
    else
      render :edit
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: 'Você não tem permissão para editar este post.'
  end
  

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: 'Post removido com sucesso!'
    else
      redirect_to @post, alert: 'Você não tem permissão para remover este post!'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :tag_ids, tag_ids: [])
  end
end
