require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  def new_user(attributes = {})
    attributes[:email] ||= 'foo@example.com'
    attributes[:password] ||= 'abc123'
    attributes[:password_confirmation] ||= attributes[:password]
    User.new(attributes)
  end

  before(:each) do
    User.delete_all
  end

  it "should be valid" do
    Fabricate(:user).should be_valid
  end

  it "should require email" do
    # Fabricate(:user, email: '').should_not be_valid
    new_user(:email => '').should have(2).error_on(:email)
  end

  it "should require password" do
    new_user(:password => '').should have(1).error_on(:password)
  end

  it "should require well formed email" do
    new_user(:email => 'foo@bar@example.com').should have(1).error_on(:email)
  end

  it "should validate uniqueness of email" do
    new_user(:email => 'bar@example.com').save!
    new_user(:email => 'bar@example.com').should have(1).error_on(:email)
  end

  it "should validate password is longer than 3 characters" do
    new_user(:password => 'bad').should have(1).error_on(:password)
  end

  # it "should require matching password confirmation" do
  #   Fabricate(:user, :password_confirmation => 'nonmatching').should_not be_valid
  # end

  it "should generate password hash and salt on create" do
    user = new_user
    user.save!
    user.password_hash.should_not be_nil
    user.password_salt.should_not be_nil
  end

  it "should authenticate by email" do
    user = new_user(:email => 'foo@bar.com', :password => 'secret')
    user.save!
    User.authenticate('foo@bar.com', 'secret').should == user
  end

  it "should not authenticate bad password" do
    new_user(:password => 'secret').save!
    User.authenticate('foobar', 'badpassword').should be_nil
  end
end
