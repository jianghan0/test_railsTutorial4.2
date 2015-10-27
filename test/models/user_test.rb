require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = User.new(name: "Example User", email: "user@example.com",
  		password: "foobar", password_confirmation: "foobar")
  end

  #バリデーション検証
  test "should valid" do
  	assert @user.valid?
  end

  #名前が空の場合:not valid
  test "name should be present" do
  	@user.name = ""
  	assert_not @user.valid?
  end

  #emailが空の場合: not valid
  test "email should be present" do
  	@user.email = " "
  	assert_not @user.valid?
  end

  #nameの長さ制限検証
  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  #emailの長さ制限検証
  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  #emailのフォーマット検証
  test "email validation should accept valid addresses" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn ] #検証用パターン
  	valid_addresses.each do |valid_address|
  		assert @user.valid?, "#{valid_address.inspect} should be valid"
  	end
  end

  #emailの一意性検証
  test "email adress should be unique" do
  	duplicate_user = @user.dup
  	@user.save
  	assert_not duplicate_user.valid?
  end

  #emailが小文字で保存されるか
  test "email addresses should be saved as lower-case" do
  	mixied_case_email = "Foo@EXAMPLE.COM"
  	@user.email = mixied_case_email
  	@user.save
  	assert_equal mixied_case_email.downcase, @user.reload.email
  end

  #passwordが空の場合: not valid
  test "password should be present(nonblank)" do
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

  #passwordのmin制限検証
  test "password should have a minimum length" do
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do 
    assert_not @user.authenticated?("")
  end





end
