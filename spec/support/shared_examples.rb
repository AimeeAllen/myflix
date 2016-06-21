shared_examples "no logged in user" do
  it "redirects to login" do
    no_logged_in_user
    action
    expect(response).to redirect_to(login_path)
  end
end
