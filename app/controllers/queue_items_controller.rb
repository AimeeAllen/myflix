class QueueItemsController < ApplicationController
  def index
    @queue_items = current_user.queue_items #AR relationship
  end

  def create
    video = Video.find(params[:video_id])
    unless current_user_already_queued(video)
      QueueItem.create(user: current_user, video: video, order: new_item_order)
    end
    redirect_to my_queue_path
  end

  private
  def new_item_order
    current_user.queue_items.size + 1
  end

  def current_user_already_queued(video)
    !QueueItem.where(user: current_user, video: video).empty?
  end
end
