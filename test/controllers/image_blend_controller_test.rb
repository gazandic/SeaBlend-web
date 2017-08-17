require 'test_helper'

class ImageBlendControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get image_blend_index_url
    assert_response :success
  end

end
