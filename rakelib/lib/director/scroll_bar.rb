###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './window'

module WXRuby3

  class Director

    class ScrollBar < Window

      def setup
        super
      end

      def process(gendoc: false)
        defmod = super
        # fix documentation errors for scroll events
        def_item = defmod.find_item('wxScrollBar')
        if def_item
          def_item.event_types.each do |evt_spec|
            case evt_spec.first
            when 'EVT_COMMAND_SCROLL_THUMBRELEASE', 'EVT_COMMAND_SCROLL_CHANGED'
              if evt_spec[2] == 0
                evt_spec[2] = 1       # incorrectly documented without 'id' argument
                evt_spec[4] = true    # ignore extracted docs
              end
            end
          end
        end
        defmod
      end
    end # class ScrollBar

  end # class Director

end # module WXRuby3
