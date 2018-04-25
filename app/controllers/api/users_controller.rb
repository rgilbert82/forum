class Api::UsersController < ApplicationController
  before_filter :set_current_user, only: [:update, :destroy]
  before_filter :set_user, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: User.all
  end

  def show
    render json: @user
  end

  def create
    new_user = User.new({
      username: user_params[:attributes][:username],
      password: user_params[:attributes][:password]
    })

    if new_user.save!
      render json: new_user
    else
      render json: new_user.errors
    end
  end

  def update
    if valid_user
      attrs = {
        username: user_params[:attributes][:username],
        password: user_params[:attributes][:password]
      }

      if @user.update(attrs)
        render json: @user
      else
        render json: @user.errors
      end
    else
      head 500
    end
  end

  def destroy
    if valid_user
      render json: @user.destroy
    else
      head 500
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @current_user = User.where(token: params[:data][:token]).first
  end

  def valid_user
    @current_user && (@current_user == @user || @current_user.admin?)
  end

  def user_params
    params.require(:data).permit({ attributes: [:username, :password] })
  end
end
