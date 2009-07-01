
require "webhook-dispatcher/acl/entry_base"

class WebHookDispatcher
  class Acl
    class DenyEntry < EntryBase
      def value
        return false
      end
    end
  end
end
