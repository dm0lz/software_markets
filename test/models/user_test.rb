require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = build(:user)
  end

  test "factory is valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email_address = ""
    assert_not @user.valid?
    assert_includes @user.errors[:email_address], "can't be blank"
  end

  test "email should be unique" do
    create(:user, email_address: "test@example.com")
    duplicate_user = build(:user, email_address: "test@example.com")
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email_address], "has already been taken"
  end

  test "email should be in the correct format" do
    invalid_emails = [ "test", "test@", "test@.", "test@example", "@example.com" ]
    invalid_emails.each do |invalid_email|
      @user.email_address = invalid_email
      assert_not @user.valid?, true
      assert_includes @user.errors[:email_address], "is invalid"
    end
    valid_emails = [ "test@example.com", "test.user@example.co.uk", "test_user@example.com" ]
    valid_emails.each do |valid_email|
      @user.email_address = valid_email
      assert @user.valid?, true
    end
  end

  test "password_digest should be present" do
    @user.password_digest = ""
    assert_not @user.valid?
    assert_includes @user.errors[:password_digest], "can't be blank"
  end
end
