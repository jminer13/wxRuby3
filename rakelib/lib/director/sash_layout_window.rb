###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './window'

module WXRuby3

  class Director

    class SashLayoutWindow < Window

      def setup
        super
        spec.items << 'wxLayoutAlgorithm'
      end

    end # class SashLayoutWindow

  end # class Director

end # module WXRuby3
