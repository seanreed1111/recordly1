require 'rails_helper'

RSpec.feature "Add song to album" do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:album) {FactoryGirl.create(:album, name: "Cars")}
  let!(:collection) {FactoryGirl.create(:collection, user:user, album:album)}

  before do
    login_as(user)
    visit "/collections"
    page.find('.album_Cars').click_link("Show")
    click_link "Add Song To Album"
  end

  scenario "with valid Song name" do

    fill_in "Song Name", with: "FastCars"
    click_link "Submit"

    expect(page).to have_content "Song was successfully created"
  end

  scenario "with invalid Song name(left blank)" do
    click_link "Submit"
    expect(page).to have_content "Song has not been created"
  end

  scenario "with invalid Song name(duplicated on album)" do
    fill_in "Song Name", with: "DoubleTrouble"
    click_link "Submit"

    fill_in "Song Name", with: "DoubleTrouble"
    click_link "Submit"

    expect(page).to have_content "Song has not been created"
  end
end