class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]
  include JsonWebToken

  def signup
    user = User.create!(user_params)
    token = encode_token(user_id: user.id)
    render json: { token: token }, status: :created
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render json: { token: encode_token(user_id: user.id) }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
