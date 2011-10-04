require 'test_helper'

class InvitationControllerTest < ActionController::TestCase
  test "should get invite" do
    get :invite
    assert_response :success
  end

  test "should get invited" do
    get :invited
    assert_response :success
  end

end
