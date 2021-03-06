require 'spec_helper'

describe "Kudoer pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title('Sign up') }
  end

  describe "profile page" do
    let(:kudoer) { FactoryGirl.create(:kudoer) }
    before { visit kudoer_path(kudoer) }

    it { should have_content(kudoer.first_name) }
    it { should have_content(kudoer.last_name) }
    it { should have_title(kudoer.full_name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a kudoer" do
        expect { click_button submit }.not_to change(Kudoer, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "First name",   with: "Example"
        fill_in "Last name",    with: "User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "testtest"
        fill_in "Confirmation", with: "testtest"
      end

      it "should create a kudoer" do
        expect { click_button submit }.to change(Kudoer, :count).by(1)
      end

      describe "after saving the kudoer" do
        before { click_button submit }
        let(:kudoer) { Kudoer.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_content("Welcome to the Kudos!") }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end

      end

    end
  end

end
