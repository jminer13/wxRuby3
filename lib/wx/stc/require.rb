# Wx::STC sub package for wxRuby3
# Copyright (c) M.J.N. Corino, The Netherlands

require_relative './events/evt_list'
require_relative './keyword_defs'

Wx::Dialog.setup_dialog_functors(Wx::STC)
