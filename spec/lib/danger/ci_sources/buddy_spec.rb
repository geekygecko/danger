require "danger/ci_source/buddy"

RSpec.describe Danger::Buddy do
  let(:valid_env) do
    {
      "BUDDY" => "true",
      "BUDDY_EXECUTION_PULL_REQUEST_NO" => "42",
      "BUDDY_REPO_SLUG" => "danger/danger",
      "BUDDY_SCM_URL" => "https://github.com/danger/danger"
    }
  end
  let(:invalid_env) do
    {
      "POP" => "true"
    }
  end
  let(:source) { described_class.new(valid_env) }

  describe ".validates_as_ci?" do
    it "validates when required env variables are set" do
      expect(described_class.validates_as_ci?(valid_env)).to be true
    end

    it "doesnt validate when require env variables are not set" do
      expect(described_class.validates_as_ci?(invalid_env)).to be false
    end
  end

  describe ".validates_as_pr?" do
    it "validates when the required variables are set" do
      expect(described_class.validates_as_pr?(valid_env)).to be true
    end

    it "doesn't not validate if `BUDDY_EXECUTION_PULL_REQUEST_NO` is missing" do
      valid_env["BUDDY_EXECUTION_PULL_REQUEST_NO"] = nil
      expect(described_class.validates_as_pr?(valid_env)).to be false
    end

    it "doesn't validate_as_pr if `BUDDY_EXECUTION_PULL_REQUEST_NO` is the empty string" do
      valid_env["BUDDY_EXECUTION_PULL_REQUEST_NO"] = ""
      expect(described_class.validates_as_pr?(valid_env)).to be false
    end
  end

  describe ".repo_slug" do
    it "sets the repo slug" do
      expect(source.repo_slug).to eq("danger/danger")
    end
  end

  describe ".repo_url" do
    it "sets the pull request url" do
      expect(source.repo_url).to eq("https://github.com/danger/danger")
    end
  end

  describe "#new" do
    it "sets the pull request id" do
      expect(source.pull_request_id).to eq("42")
    end
  end

  describe "#supported_request_sources" do
    it "supports GitHub" do
      expect(source.supported_request_sources).to include(Danger::RequestSources::GitHub)
    end
  end
end
