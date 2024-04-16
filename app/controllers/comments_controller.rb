class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user  # Defina o user_id corretamente aqui
    
    if @comment.save
      redirect_to @post, notice: 'Comentário adicionado com sucesso!'
    else
      redirect_to @post, alert: 'Falha ao adicionar comentário!'
    end
  end
  
  
  def destroy
    @comment = @post.comments.find(params[:id])
    
    if @comment.user == current_user
      @comment.destroy
      redirect_to @post, notice: 'Comentário removido com sucesso!'
    else
      redirect_to @post, alert: 'Você não tem permissão para remover este comentário!'
    end
  end
  

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id]) if params[:id].present?
  end
  

  def comment_params
    params.require(:comment).permit(:content, :anonymous)
  end
end
