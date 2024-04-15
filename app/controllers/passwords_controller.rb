class PasswordsController < ApplicationController
    def new
    end
  
    def create
      user = User.find_by(email: params[:email])
      if user
        # Implementar envio de email com instruções para resetar senha
        redirect_to root_path, notice: 'Email enviado com instruções para resetar senha'
      else
        flash.now[:alert] = 'Email não encontrado'
        render :new
      end
    end
  
    # Implementar métodos edit e update para resetar a senha
  end
  