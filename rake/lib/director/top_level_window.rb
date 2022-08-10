#--------------------------------------------------------------------
# @file    top_level_window.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  class Director

    class TopLevelWindow < Director

      def setup
        # for all wxTopLevelWindow (derived) classes
        spec.add_swig_begin_code <<~__HEREDOC
          SWIG_WXTOPLEVELWINDOW_NO_USELESS_VIRTUALS(wxFrame);
        __HEREDOC
        spec.no_proxy %w{
          wxTopLevelWindow::IsFullScreen
          wxWindow::GetDropTarget
          wxWindow::GetValidator
        }
        if spec.module_name == 'wxTopLevelWindow'
          spec.ignore %w{
            wxTopLevelWindow::SaveGeometry
            wxTopLevelWindow::RestoreToGeometry
          }
          spec.set_only_for :wxuniversal, %w{
            wxTopLevelWindow::IsUsingNativeDecorations
            wxTopLevelWindow::UseNativeDecorations
            wxTopLevelWindow::UseNativeDecorationsByDefault
          }
          spec.set_only_for :wxmsw, 'wxTopLevelWindow::MSWGetSystemMenu'
        end
        super
      end
    end # class Frame

  end # class Director

end # module WXRuby3
