#--------------------------------------------------------------------
# @file    calendar_date_attr.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  class Director

    class CalendarDateAttr < Director

      def setup
        spec.gc_as_object
        spec.do_not_generate(:variables, :enums, :defines, :functions)
        super
      end
    end # class CalendarDateAttr

  end # class Director

end # module WXRuby3
