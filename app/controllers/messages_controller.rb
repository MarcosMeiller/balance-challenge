class MessagesController < ApplicationController

  def create
    message = Message.new(params_message)
    if message.save
      render json: message, status: :created
    else
      render json: message.errors.full_messages, status: :unprocessable_entity
    end
  end

  def index
    messages = Message.all
    render json: messages, status: :ok, each_serializer: MessagesSerializer
  end

  private

  def params_message
    params.require(:message).permit(:content)
  end
end
