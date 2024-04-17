class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Perfil atualizado com sucesso!'
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'Usuário cadastrado com sucesso!'
    else
      render :new
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(params[:id])
  
    # Verifica se a senha atual é válida
    if @user.authenticate(params[:user][:current_password])
      # Atualiza a senha
      @user.password = params[:user][:new_password]
      @user.password_confirmation = params[:user][:new_password_confirmation]
  
      if @user.save
        redirect_to @user, notice: 'Senha atualizada com sucesso.'
      else
        render :edit_password
      end
    else
      flash.now[:alert] = 'Senha atual inválida.'
      render :edit_password
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :phone_number)
  end
end
