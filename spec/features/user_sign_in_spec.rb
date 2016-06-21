require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    john = Fabricate(:user)
    sign_in(john)
    expect(page).to have_content john.fullname
  end
end
