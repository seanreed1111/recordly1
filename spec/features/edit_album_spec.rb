require 'rails_helper'

RSpec.feature "Signed in users can edit an album" do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:album) {FactoryGirl.create(:album, name: "Edit-Album")}
  let!(:collection) {FactoryGirl.create(:collection, user:user, album:album)}

  before do
    login_as(user)
    visit "/collections"
  end

  scenario "can change album name attributes" do

    page.find('.album_Edit-Album').click_link("Edit Album")

    fill_in "Album Name", with: "My New Album"
    click_button "Submit Album"

    expect(page).to have_content "Album was successfully updated"

  end


end