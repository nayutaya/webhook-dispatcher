
require "webhook-dispatcher/acl/entry_base"

class WebHookDispatcher
  class Acl
    class AllowEntry < EntryBase
      def value
        return true
      end
    end
  end
end
