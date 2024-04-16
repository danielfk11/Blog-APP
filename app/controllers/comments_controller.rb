class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to @post, notice: 'Comentário adicionado com sucesso!'
    else
      redirect_to @post, alert: 'Falha ao adicionar comentário!'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'Comentário removido com sucesso!'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
