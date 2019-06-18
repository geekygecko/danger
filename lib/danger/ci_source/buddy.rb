require "danger/request_sources/github/github"

module Danger
  # ### CI Setup
  #
  # With Buddy https://buddy.works you need to add an action with Ruby support.
  #
  #  ``` shell
  #   bundle exec danger
  #  ```
  #
  # ### Token Setup
  #
  # Add the environment variables,
  # https://buddy.works/knowledge/deployments/how-use-environment-variables
  #
  # #### GitHub
  # Add the `DANGER_GITHUB_API_TOKEN`
  #
class Buddy < CI
    def self.validates_as_ci?(env)
      env.key? "BUDDY"
    end

    def self.validates_as_pr?(env)
      pull_request_no = env["BUDDY_EXECUTION_PULL_REQUEST_NO"]
      !pull_request_no.nil? && !pull_request_no.empty? && pull_request_no.to_i > 0
    end

    def supported_request_sources
      @supported_request_sources ||= [Danger::RequestSources::GitHub]
    end

    def initialize(env)
      self.repo_slug = env["BUDDY_REPO_SLUG"]
      if env["BUDDY_EXECUTION_PULL_REQUEST_NO"].to_i > 0
        self.pull_request_id = env["BUDDY_EXECUTION_PULL_REQUEST_NO"]
      end
      self.repo_url = env["BUDDY_SCM_URL"]
    end
  end
end
