require 'rails_helper'

RSpec.feature "Signed in users can show a single album" do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:album) {FactoryGirl.create(:album, name: "BackinBlack")}
  let!(:collection) {FactoryGirl.create(:collection, user:user, album:album)}

  before do
    login_as(user)
    visit "/collections"
  end

  scenario "album attributes" do

    page.find('.album_BackInBlack').click_link("Show Album")

    expect(page).to have_content "BackinBlack"
  end


end