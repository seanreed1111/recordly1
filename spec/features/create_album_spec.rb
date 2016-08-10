require 'rails_helper'

RSpec.feature "Signed in users can create an new album" do
  let!(:user) {FactoryGirl.create(:user)}

  before do
    login_as(user)
  end

  scenario "with valid album name attributes" do
    visit "/collections"
    click_link "Add New Album"

    fill_in "Name", with: "My New Album"
    click_button "Submit"

    expect(page).to have_content "Album was successfully added to your collection."

  end
end