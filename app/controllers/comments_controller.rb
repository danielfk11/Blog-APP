def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to post_path(@comment.post), notice: 'Comentário criado com sucesso!'
    else
      redirect_to post_path(@comment.post), alert: 'Erro ao criar o comentário.'
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
  