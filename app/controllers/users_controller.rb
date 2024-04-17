class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'Usuário cadastrado com sucesso!'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :phone_number)
  end
end
