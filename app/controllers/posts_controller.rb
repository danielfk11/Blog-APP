class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
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
    @post.destroy
    redirect_to posts_path, notice: 'Post deletado com sucesso!'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
