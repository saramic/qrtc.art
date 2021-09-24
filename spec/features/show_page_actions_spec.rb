require "rails_helper"

feature "Show page actions", js: true do
  context "when in default production mode" do
    scenario "User does not have any actions" do
      When "a user visits the app" do
        visit root_path
      end

      Then "there are no actinos" do
        expect(
          page.find_all("[data-testid=action]"),
        ).to be_empty
      end
    end
  end

  context "when the user has new feature turned on" do
    background do
      visit feature_path
      page.find(".button", text: "NEW-PAGE").click
    end

    scenario "user has trackable actions" do
      When "a user visits the app" do
        visit root_path
      end

      Then "they see some actions" do
        pending "looking at an actual qrtc and some buttons"
        expect(
          page.find_all("[data-testid=action]"),
        ).to contain_exactly([
          "coffee",
          "next qrtc",
        ])
      end
    end
  end
end
