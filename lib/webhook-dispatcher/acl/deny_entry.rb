
require "webhook-dispatcher/acl/entry_base"

class WebHookDispatcher
  class Acl
    class DenyEntry < EntryBase
    end
  end
end

class WebHookDispatcher::Acl::DenyEntry
end
