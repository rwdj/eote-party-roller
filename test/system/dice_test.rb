# require "application_system_test_case"

# class DiceTest < ApplicationSystemTestCase
#   setup do
#     @die = dice(:one)
#   end

#   test "visiting the index" do
#     visit dice_url
#     assert_selector "h1", text: "Dice"
#   end

#   test "creating a Die" do
#     visit dice_url
#     click_on "New Die"

#     click_on "Create Die"

#     assert_text "Die was successfully created"
#     click_on "Back"
#   end

#   test "updating a Die" do
#     visit dice_url
#     click_on "Edit", match: :first

#     click_on "Update Die"

#     assert_text "Die was successfully updated"
#     click_on "Back"
#   end

#   test "destroying a Die" do
#     visit dice_url
#     page.accept_confirm do
#       click_on "Destroy", match: :first
#     end

#     assert_text "Die was successfully destroyed"
#   end
# end
