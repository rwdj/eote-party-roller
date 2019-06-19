# require 'test_helper'

# class DiceControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @die = dice(:one)
#   end

#   test "should get index" do
#     get dice_url
#     assert_response :success
#   end

#   test "should get new" do
#     get new_die_url
#     assert_response :success
#   end

#   test "should create die" do
#     assert_difference('Die.count') do
#       post dice_url, params: { die: {  } }
#     end

#     assert_redirected_to die_url(Die.last)
#   end

#   test "should show die" do
#     get die_url(@die)
#     assert_response :success
#   end

#   test "should get edit" do
#     get edit_die_url(@die)
#     assert_response :success
#   end

#   test "should update die" do
#     patch die_url(@die), params: { die: {  } }
#     assert_redirected_to die_url(@die)
#   end

#   test "should destroy die" do
#     assert_difference('Die.count', -1) do
#       delete die_url(@die)
#     end

#     assert_redirected_to dice_url
#   end
# end
