require "test_helper"

class ContractInfosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contract_infos_index_url
    assert_response :success
  end

  test "should get show" do
    get contract_infos_show_url
    assert_response :success
  end

  test "should get new" do
    get contract_infos_new_url
    assert_response :success
  end

  test "should get create" do
    get contract_infos_create_url
    assert_response :success
  end

  test "should get edit" do
    get contract_infos_edit_url
    assert_response :success
  end

  test "should get update" do
    get contract_infos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get contract_infos_destroy_url
    assert_response :success
  end
end
