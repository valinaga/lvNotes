require 'test_helper'

class SendersControllerTest < ActionController::TestCase
  setup do
    @sender = senders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:senders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sender" do
    assert_difference('Sender.count') do
      post :create, :sender => @sender.attributes
    end

    assert_redirected_to sender_path(assigns(:sender))
  end

  test "should show sender" do
    get :show, :id => @sender.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sender.to_param
    assert_response :success
  end

  test "should update sender" do
    put :update, :id => @sender.to_param, :sender => @sender.attributes
    assert_redirected_to sender_path(assigns(:sender))
  end

  test "should destroy sender" do
    assert_difference('Sender.count', -1) do
      delete :destroy, :id => @sender.to_param
    end

    assert_redirected_to senders_path
  end
end
