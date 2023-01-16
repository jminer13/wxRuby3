###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './event'

module WXRuby3

  class Director

    class FindDialogEvent < Director::Event

      def setup
        spec.make_enum_untyped('wxFindReplaceDialogStyles', 'wxFindReplaceFlags')
        super
      end

    end # class FindDialogEvent

  end # class Director

end # module WXRuby3
