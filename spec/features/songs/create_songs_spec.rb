require 'rails_helper'

RSpec.feature "Add song to album from show album page" do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:album) {FactoryGirl.create(:album, name: "Cars")}
  let!(:collection) {FactoryGirl.create(:collection, user:user, album:album)}

  before(:each) {pending "add ids for RSpec to find entry points"}
  before do
    login_as(user)
    visit "/collections"
    page.find('.album_Cars').click_link("Show")
    click_link "Add Song To Album"
  end


  scenario "with valid Song name" do

    fill_in "Song Name", with: "FastCars"
    page.find("#MySongForm").click_button("Submit")

    expect(page).to have_content "Song was successfully created"
  end

  scenario "with invalid Song name(left blank)" do
    fill_in "Song Name", with: ""
    page.find("#MySongForm").click_button("Submit")
    expect(page).to have_content "Song has not been created"
  end


  scenario "with invalid Song name(duplicated on album)" do
    fill_in "Song Name", with: "DoubleTrouble"
    page.find("#MySongForm").click_button("Submit")

    visit "/collections"
    page.find('.album_Cars').click_link("Show")
    click_link "Add Song To Album"

    fill_in "Song Name", with: "DoubleTrouble"
    click_button "Submit"

    expect(page).to have_content "Song has not been created"
  end
end