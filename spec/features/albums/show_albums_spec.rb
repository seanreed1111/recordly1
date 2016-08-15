require 'rails_helper'

RSpec.feature "Signed in users can show their albums" do
  let!(:user) {FactoryGirl.create(:user)}

  before do
    login_as(user)
    visit "/collections"
  end

  scenario "with no albums present" do
    expect(page).to have_content "No Albums Yet!"
  end


end