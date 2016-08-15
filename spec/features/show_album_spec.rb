require 'rails_helper'

RSpec.feature "Signed in users can show an album" do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:album) {FactoryGirl.create(:album, name: "Show-Album")}
  let!(:collection) {FactoryGirl.create(:collection, user:user, album:album)}

  before do
    login_as(user)
    visit "/collections"
  end

  scenario "can show album attributes" do

    page.find('.album_Show-Album').click_link("Show Album")

    expect(page).to have_css "#show_album"
  end


end