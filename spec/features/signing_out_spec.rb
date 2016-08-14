require 'rails_helper'

RSpec.feature "Signed-in users can sign out" do
  let!(:user) {FactoryGirl.create(:user)}

  before(:each) {pending "Sign out messages to change"}
  before do
    login_as(user)
  end

  scenario do
    visit "/"
    click_link "Sign out"
    expect(page).to have_content "Signed out successfully"
  end
end