class Api::MessagesController < ApplicationController
  before_filter :set_current_user, only: [:create, :update, :destroy]
  before_filter :set_message, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: Message.all
  end

  def show
    render json: @message
  end

  def create
    conversation = Conversation.find(message_params[:relationships][:conversation][:data][:id])

    if @user && (conversation.sender == @user || conversation.recipient == @user)
      new_message = Message.new({
        body: message_params[:attributes][:body],
        conversation: conversation,
        user_id: @user.id,
        unread: true
      })

      if new_message.save!
        render json: new_message
      else
        render json: new_message.errors
      end
    else
      head 500
    end
  end

  def update
    if valid_user
      attrs = {
        body: message_params[:attributes][:body],
        unread: message_params[:attributes][:unread]
      }

      if @message.update(attrs)
        render json: @message
      else
        render json: @message.errors
      end
    else
      head 500
    end
  end

  def destroy
  end

  private

  def message_params
    params.require(:data).permit({ attributes: [:body, :unread], relationships: [conversation: [data: [:id]]] })
  end

  def valid_user
    @user && (@message.conversation.sender == @user || @message.conversation.recipient == @user)
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def set_current_user
    @user = User.where(token: params[:data][:token]).first
  end
end
