require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  subject { Fabricate(:user) }
  it { should be_valid }

  describe "email" do
    context "email is required" do
      let!(:user){ Fabricate.build(:user, email: '')}
      subject{ user }

      it "should be invalid" do
        subject.should_not be_valid
      end
    end

    context "malformed email should not be valid" do
      let!(:user){ Fabricate.build(:user, email: 'foo@bar@example.com')}
      subject { user }

      it "should be invalid" do
        subject.should_not be_valid
      end

      it "should have one error" do
        subject.should have(1).error_on(:email)
      end
    end

    context "email should be unique" do
      let!(:user1){ Fabricate(:user, email: 'user@example.com') }
      let!(:user2){ Fabricate.build(:user, email: 'user@example.com')}
      subject{ user2 }

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
      let!(:user){ Fabricate.build(:user, password: '', password_confirmation: '')}
      subject{ user }

      it "should be invalid" do
        subject.should_not be_valid
      end
    end

    context "password is less than 6 characters" do
      let!(:user){ Fabricate.build(:user, password: 'bad45', password_confirmation: 'bad45')}
      subject{ user }

      it "should be invalid" do
        subject.should_not be_valid
      end

      it "should have one error" do
        subject.should have(1).error_on(:password)
      end
    end

    context "pasword and password_confirmation must match" do
      let!(:user){ Fabricate.build(:user, password_confirmation: 'nonmatching')}
      subject{ user }

      it "should be invalid" do
        subject.should_not be_valid
      end
    end

    context "should generate password hash and salt on create" do
      let!(:user){ Fabricate(:user) }
      subject{ user }

      it "password_hash should not be nil" do
        subject.password_hash.should_not be_nil
      end

      it "password_salt should not be nil" do
        subject.password_salt.should_not be_nil
      end
    end
  end

  describe "authentication"  do
    context "should authenticate by email" do
      let!(:user){ Fabricate(:user, email: 'foo@bar.com', password: 'secret', password_confirmation: 'secret')}
      subject{ user }

      it "should authenticate" do
        subject.should == User.authenticate('foo@bar.com', 'secret')
      end
    end

    context "should not authenticate with bad password" do
      let!(:user){ Fabricate(:user, email: 'user@example.com', password: 'secret', password_confirmation: 'secret')}
      subject{ user }

      it "should not authenticate with bad password" do
        User.authenticate(subject.email, 'badpassword').should be_nil
      end
    end
  end
end
