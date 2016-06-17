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
      current_user.normalise_queue_item_orders
    end
    flash[:success] = 'Video has been removed from your queue'
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalise_queue_item_orders
      flash[:success] = "Your queue has been updated"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Please enter only integer List Order numbers"
    end
    redirect_to my_queue_path
  end

  private
  def new_item_order
    current_user.queue_items.size + 1
  end

  def current_user_already_queued(video)
    !QueueItem.where(user: current_user, video: video, deleted: false).empty?
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(order: queue_item_data[:order], rating: queue_item_data[:rating]) if queue_item.user == current_user
      end
    end
  end
end
