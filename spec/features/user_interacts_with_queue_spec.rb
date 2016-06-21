require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and re-orders videos in the queue" do
    futurama = Fabricate(:video, title: "Futurama")
    family_guy = Fabricate(:video, title: "Family Guy")
    monk = Fabricate(:video, title: "Monk")
    sign_in
    add_video_to_queue(futurama)
    view_video_from_queue(futurama)
    add_video_to_queue(family_guy)
    add_video_to_queue(monk)
    change_order(futurama, 6)
    change_order(family_guy, 5)
    change_order(monk, 4)
    update_queue
    verify_order(monk, 1)
    verify_order(family_guy, 2)
    verify_order(futurama, 3)
  end

  def add_video_to_queue(video)
    visit home_path
    view_video_from_home(video)
    add_current_video_to_queue
  end

  def view_video_from_home(video)
    find("a[href='/videos/#{video.id}']").click
    expect(page).to have_content(video.title)
  end

  def add_current_video_to_queue
    video_id = current_path.split("/videos/")[1]
    video = Video.find(video_id)
    click_on("+ My Queue")
    expect(page).to have_content(video.title)
    expect(page).to have_content(video.category.label)
  end

  def view_video_from_queue(video)
    click_on("#{video.title}")
    expect(page).to have_current_path("/videos/#{video.id}")
    expect(page).not_to have_content("+ My Queue")
  end

  def change_order(video, new_order)
    fill_in("video_#{video.id}_order", with: new_order)
  end

  def update_queue
    click_on("Update Instant Queue")
  end

  def verify_order(video, order)
    expect(find_field("video_#{video.id}_order").value.to_i).to eq(order)
  end

end
