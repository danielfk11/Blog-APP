class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.valid_password?(params[:password])
      sign_in(user) # Usando Devise para fazer login
      redirect_to root_path, notice: 'Login realizado com sucesso!'
    else
      puts "Email ou senha inválidos para o email #{params[:email]}"
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new
    end
  end

  def destroy
    sign_out(current_user) 
    redirect_to root_path, notice: 'Logout realizado com sucesso!'
  end
end
