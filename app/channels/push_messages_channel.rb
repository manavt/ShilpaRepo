class PushMessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "push_messages_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
