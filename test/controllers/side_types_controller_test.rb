# require 'test_helper'

# class SideTypesControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @side_type = side_types(:one)
#   end

#   test "should get index" do
#     get side_types_url
#     assert_response :success
#   end

#   test "should get new" do
#     get new_side_type_url
#     assert_response :success
#   end

#   test "should create side_type" do
#     assert_difference('SideType.count') do
#       post side_types_url, params: { side_type: { advantage: @side_type.advantage, dark: @side_type.dark, despair: @side_type.despair, light: @side_type.light, success: @side_type.success, triumph: @side_type.triumph } }
#     end

#     assert_redirected_to side_type_url(SideType.last)
#   end

#   test "should show side_type" do
#     get side_type_url(@side_type)
#     assert_response :success
#   end

#   test "should get edit" do
#     get edit_side_type_url(@side_type)
#     assert_response :success
#   end

#   test "should update side_type" do
#     patch side_type_url(@side_type), params: { side_type: { advantage: @side_type.advantage, dark: @side_type.dark, despair: @side_type.despair, light: @side_type.light, success: @side_type.success, triumph: @side_type.triumph } }
#     assert_redirected_to side_type_url(@side_type)
#   end

#   test "should destroy side_type" do
#     assert_difference('SideType.count', -1) do
#       delete side_type_url(@side_type)
#     end

#     assert_redirected_to side_types_url
#   end
# end
