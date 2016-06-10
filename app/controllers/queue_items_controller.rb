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

  def destroy
    queue_item_to_delete = QueueItem.find(params[:id])
    if queue_item_to_delete.user == current_user
      queue_item_to_delete.delete!
      re_order_later_queue_items(queue_item_to_delete)
    end
    flash[:success] = 'Video has been removed from your queue'
    redirect_to my_queue_path
  end

  private
  def new_item_order
    current_user.queue_items.size + 1
  end

  def current_user_already_queued(video)
    !QueueItem.where(user: current_user, video: video, deleted: false).empty?
  end

  def re_order_later_queue_items(queue_item)
    queue_items_to_correct = QueueItem.where('"order" > ?', queue_item.order)
    queue_items_to_correct.each do |item|
      item.order -= 1
      item.save
    end    
  end
end
