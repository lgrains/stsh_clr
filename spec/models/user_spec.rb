require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  let!(:existing_user){ Fabricate(:user) }
  let!(:user){ Fabricate.build(:user, email: email, password: password, password_confirmation: password_confirmation)}

  let(:email){''}
  let(:password){''}
  let(:password_confirmation){''}

  subject { user }


  describe "email" do
    context "email is required" do

      it "should be invalid" do
        subject.should_not be_valid
      end
    end

    context "malformed email should not be valid" do
      let!(:email){ 'foo@bar@example.com' }

      it "should be invalid" do
        subject.should_not be_valid
      end

      it "should have one error" do
        subject.should have(1).error_on(:email)
      end
    end

    context "email should be unique" do
      let!(:email){ existing_user.email }

      it "should be invalid" do
        subject.should_not be_valid
      end

      it "should have one error" do
        subject.should have(1).error_on(:email)
      end
    end
  end

  describe "password" do
    context "password is required" do
      it "should be invalid" do
        subject.should_not be_valid
      end
    end

    context "password is less than 6 characters" do
      let!(:password){'12345'}
      let!(:password_confirmation){ '12345' }

      it "should be invalid" do
        subject.should_not be_valid
      end

      it "should have one error" do
        subject.should have(1).error_on(:password)
      end
    end

    context "pasword and password_confirmation must match" do
      let!(:password){ 'abc123' }
      let!(:password_confirmation){ 'xyz987'}

      it "should be invalid" do
        subject.should_not be_valid
      end
    end

    context "should be valid when correct data given" do
      subject{ existing_user }

      it "should be valid" do
        subject.should be_valid
      end

      it "password_hash should not be nil" do
        subject.password_hash.should_not be_nil
      end

      it "password_salt should not be nil" do
        subject.password_salt.should_not be_nil
      end
    end
  end

  describe "authentication"  do
    context "should authenticate by email and password" do
      subject{ existing_user }

      it "should authenticate" do
        subject.should == User.authenticate(subject.email, subject.password)
      end
    end

    context "should not authenticate with bad password" do
      subject{ existing_user }

      it "should not authenticate with bad password" do
        User.authenticate(subject.email, 'badpassword').should be_nil
      end
    end
  end
end
