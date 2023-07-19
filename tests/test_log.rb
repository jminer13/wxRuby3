
require_relative './lib/wxapp_runner'

class LogTests < Test::Unit::TestCase

  class TestLogBase < Wx::Log

    def initialize
      super
      @logs = ::Array.new(Wx::LOG_Trace + 1)
      @logsInfo = ::Array.new(Wx::LOG_Trace + 1)
    end

    def get_log(level)
      @logs[level].to_s
    end

    def get_info(level)
      @logsInfo[level]
    end

    def clear
      @logs.each { |l| l.clear() }
      @logsInfo = ::Array.new(Wx::LOG_Trace + 1)
    end

  end

  class TestLog < TestLogBase

    protected

    def do_log_record(level, msg, info)
      @logs[level] = msg
      # do not keep log info objects because these (and their state) are purely transient data
      # that can only be reliably accessed (or passed on) within this call scope
      @logsInfo[level] = { filename: info.filename, line: info.line, func: info.func, component: info.component }
    end

  end

  def setup
    super
    @logOld = Wx::Log.set_active_target(@log = TestLog.new)
    @logWasEnabled = Wx::Log.enable_logging
  end

  def cleanup
    Wx::Log.set_active_target(@logOld)
    Wx::Log.enable_logging(@logWasEnabled)
    super
  end

  def test_functions
    Wx.log_message("Message")
    assert_equal("Message", @log.get_log(Wx::LOG_Message))

    Wx.log_error("Error %d", 17)
    assert_equal("Error 17", @log.get_log(Wx::LOG_Error))

    Wx.log_debug("Debug")
    if Wx::WXWIDGETS_DEBUG_LEVEL > 0
      assert_equal( "Debug", @log.get_log(Wx::LOG_Debug))
    else
      assert_equal( "", @log.get_log(Wx::LOG_Debug))
    end
  end

  def test_null
    Wx::LogNull.no_log do
      Wx.log_warning("%s warning", "Not important")

      assert_equal("", @log.get_log(Wx::LOG_Warning))
      end

    Wx.log_warning("%s warning", "Important")
    assert_equal("Important warning", @log.get_log(Wx::LOG_Warning))
  end

  def test_component
    Wx.log_message('Message')
    assert_equal('wxapp',
                 @log.get_info(Wx::LOG_Message)[:component])

    # completely disable logging for this component
    Wx::Log.set_component_level('test/ignore', Wx::LOG_FatalError)

    # but enable it for one of its subcomponents
    Wx::Log.set_component_level('test/ignore/not', Wx::LOG_Max)

    Wx::Log.for_component('test/ignore') do
      # this shouldn't be output as this component is ignored
      Wx::log_error('Error')
      assert_equal('', @log.get_log(Wx::LOG_Error))

      # and so are its subcomponents
      Wx.log_error('Error', component: 'test/ignore/sub/subsub') # explicit component: overrules scoped setting
      assert_equal('', @log.get_log(Wx::LOG_Error))

      Wx.log_error('Error', component: 'test/ignore/not')
      assert_equal('Error', @log.get_log(Wx::LOG_Error))

      # restore the original component value
    end
  end
  
end
