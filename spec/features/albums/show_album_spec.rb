require 'rails_helper'

RSpec.feature "Signed in users can show a single album" do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:album) {FactoryGirl.create(:album, name: "Sideways")}
  let!(:collection) {FactoryGirl.create(:collection, user:user, album:album)}

  before do
    login_as(user)
    visit "/collections"
  end

  scenario "-show album attributes" do

    page.find('.album_Sideways').click_link("Show Album")

    expect(page).to have_content "Sideways"
  end


end