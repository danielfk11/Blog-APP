class ProfilesController < ApplicationController
    before_action :authenticate_user!
  
    def show
      @user = current_user
      @posts = @user.posts
    end
  
    def edit
      @user = current_user
    end
  
    def update
      @user = current_user
      if @user.update(user_params)
        redirect_to profile_path, notice: 'Perfil atualizado com sucesso.'
      else
        render :edit
      end
    end
  
    def edit_password
      @user = current_user
    end
  
    def update_password
      @user = current_user
      if @user.update_with_password(password_params)
        bypass_sign_in(@user)
        redirect_to profile_path, notice: 'Senha atualizada com sucesso.'
      else
        render :edit_password
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :phone_number)
    end
  
    def password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
  end
  