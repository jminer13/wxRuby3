###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './window'

module WXRuby3

  class Director

    class StaticBitmap < Window

      def setup
        spec.add_swig_code <<~__HEREDOC
          %constant char * wxStaticBitmapNameStr = wxStaticBitmapNameStr;
          __HEREDOC
        super
      end
    end # class StaticBitmap

  end # class Director

end # module WXRuby3
