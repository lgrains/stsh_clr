require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  subject { Fabricate(:user) }
  it { should be_valid }

  #associations

  #validations
  it { should validate_presence_of :email }

  it "should require email" do
    Fabricate.build(:user, email: '').should_not be_valid
  end

  it "should require password" do
    Fabricate.build(:user, :password => '').should_not be_valid
  end

  it "should require well formed email" do
    Fabricate.build(:user, :email => 'foo@bar@example.com').should have(1).error_on(:email)
  end

  it "should validate uniqueness of email" do
    Fabricate(:user, :email => 'bar_s@example.com')
    Fabricate.build(:user, :email => 'bar_s@example.com').should_not be_valid
  end

  it "should validate password is longer than 3 characters" do
    Fabricate.build(:user, password: 'bad', password_confirmation: 'bad').should_not be_valid
  end

  it "should require matching password confirmation" do
    Fabricate.build(:user, password_confirmation: 'nonmatching').should_not be_valid
  end

  it "should generate password hash and salt on create" do
    user = Fabricate(:user)
    user.password_hash.should_not be_nil
    user.password_salt.should_not be_nil
  end

  it "should authenticate by email" do
    user = Fabricate(:user, email: 'foo@bar.com', password: 'secret', password_confirmation: 'secret')
    User.authenticate('foo@bar.com', 'secret').should == user
  end

  it "should not authenticate bad password" do
    Fabricate(:user, password: 'secret', password_confirmation: 'secret')
    User.authenticate('foobar', 'badpassword').should be_nil
  end
end
