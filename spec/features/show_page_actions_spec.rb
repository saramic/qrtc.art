require "rails_helper"

feature "Show page actions", js: true do
  background do
    Given "a qrtc exists" do
      Location.find_or_create_by(code: "DEMO", status: "active")
    end
  end

  context "when in default production mode" do
    scenario "User does not have any actions" do
      When "a user visits the app and visits first best QRTC" do
        visit root_path
        page.find("[data-testid=qrtc-code-link]").click
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
      Given "the new-page feature is ON" do
        visit feature_path
        page.find(".button", text: "NEW-PAGE").click
      end
    end

    scenario "user has trackable actions" do
      When "a user visits the app and visits first best QRTC" do
        visit root_path
        page.find("[data-testid=qrtc-code-link]").click
      end

      Then "they see some actions" do
        expect(
          page
            .find_all("[data-testid=action]")
            .map(&:text),
        ).to contain_exactly(
          "COFFEE",
          "NEXT QRTC",
        )
      end
    end
  end
end
