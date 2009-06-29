
class WebHookDispatcher
  @open_timeout = nil
  @read_timeout = nil
  @user_agent   = nil

  class << self
    attr_accessor :open_timeout, :read_timeout, :user_agent
  end
end
