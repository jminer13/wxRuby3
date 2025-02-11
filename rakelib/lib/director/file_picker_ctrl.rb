###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './window'

module WXRuby3

  class Director

    class FilePickerCtrl < Window

      def setup
        super
        spec.make_concrete 'wxFilePickerCtrl'
        spec.do_not_generate(:variables, :defines, :enums, :functions) # with FileDirPickerEvent
      end
    end # class FilePickerCtrl

  end # class Director

end # module WXRuby3
