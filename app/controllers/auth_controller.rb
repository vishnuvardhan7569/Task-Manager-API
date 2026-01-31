class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[signup login]
  include JsonWebToken

  def signup
    user = User.create!(user_params)
    render json: auth_response(user), status: :created
  end

  def login
    login_params = params[:user] || params
    user = User.find_by(email: login_params[:email])

    if user&.authenticate(login_params[:password])
      render json: auth_response(user), status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :gender)
  end

  def auth_response(user)
    {
      token: encode_token(user_id: user.id)
    }
  end
end
