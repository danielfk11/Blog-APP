# app/controllers/passwords_controller.rb

class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(phone_number: params[:phone_number])
    if user
      # Gerar e salvar token
      token = rand(100000..999999).to_s
      user.update(reset_password_token: token, reset_password_sent_at: Time.now)
  
      # Enviar token via SMS
      send_sms(user.phone_number, "Seu código de verificação é: #{token}")
  
      redirect_to verify_token_path(email: user.email), notice: 'Token enviado com sucesso'
    else
      flash.now[:alert] = 'Número de telefone não encontrado'
      render :new
    end
  end
  

  def edit
    @user = User.find_by(reset_password_token: params[:reset_password_token])
    if @user.nil?
      redirect_to root_path, alert: 'Token inválido ou expirado'
    end
  end
  
  def update
    @user = User.find_by(email: params[:user][:email])
    
    if @user&.update(user_params)
      bypass_sign_in(@user)  # Adicione esta linha para autenticar o usuário
      redirect_to root_path, notice: 'Senha atualizada com sucesso!'
    else
      render :edit
    end
  end
  
  
  def verify_token
  end
  
  def validate_token
    user = User.find_by(email: params[:email])
    
    if user && user.reset_password_token == params[:token]
      redirect_to edit_password_path(reset_password_token: user.reset_password_token), notice: 'Token validado com sucesso'
    else
      flash.now[:alert] = 'Token inválido'
      render :verify_token
    end
  end  

  private

  def send_sms(to, body)
    Twilio::REST::Client.new.messages.create(
      to: to,
      from: '+12563056344', # Twilio celular 
      body: body
    )
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
