require 'test_helper'

class BanosControllerTest < ActionController::TestCase
  setup do
    @bano = banos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:banos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bano" do
    assert_difference('Bano.count') do
      post :create, bano: { descripcion: @bano.descripcion, latitud: @bano.latitud, longitud: @bano.longitud }
    end

    assert_redirected_to bano_path(assigns(:bano))
  end

  test "should show bano" do
    get :show, id: @bano
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bano
    assert_response :success
  end

  test "should update bano" do
    patch :update, id: @bano, bano: { descripcion: @bano.descripcion, latitud: @bano.latitud, longitud: @bano.longitud }
    assert_redirected_to bano_path(assigns(:bano))
  end

  test "should destroy bano" do
    assert_difference('Bano.count', -1) do
      delete :destroy, id: @bano
    end

    assert_redirected_to banos_path
  end
end
