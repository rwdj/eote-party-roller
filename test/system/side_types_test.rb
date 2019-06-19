# require "application_system_test_case"

# class SideTypesTest < ApplicationSystemTestCase
#   setup do
#     @side_type = side_types(:one)
#   end

#   test "visiting the index" do
#     visit side_types_url
#     assert_selector "h1", text: "Side Types"
#   end

#   test "creating a Side type" do
#     visit side_types_url
#     click_on "New Side Type"

#     fill_in "Advantage", with: @side_type.advantage
#     fill_in "Dark", with: @side_type.dark
#     fill_in "Despair", with: @side_type.despair
#     fill_in "Light", with: @side_type.light
#     fill_in "Success", with: @side_type.success
#     fill_in "Triumph", with: @side_type.triumph
#     click_on "Create Side type"

#     assert_text "Side type was successfully created"
#     click_on "Back"
#   end

#   test "updating a Side type" do
#     visit side_types_url
#     click_on "Edit", match: :first

#     fill_in "Advantage", with: @side_type.advantage
#     fill_in "Dark", with: @side_type.dark
#     fill_in "Despair", with: @side_type.despair
#     fill_in "Light", with: @side_type.light
#     fill_in "Success", with: @side_type.success
#     fill_in "Triumph", with: @side_type.triumph
#     click_on "Update Side type"

#     assert_text "Side type was successfully updated"
#     click_on "Back"
#   end

#   test "destroying a Side type" do
#     visit side_types_url
#     page.accept_confirm do
#       click_on "Destroy", match: :first
#     end

#     assert_text "Side type was successfully destroyed"
#   end
# end
