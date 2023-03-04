###
# wxRuby3 rake file
# Copyright (c) M.J.N. Corino, The Netherlands
###

namespace 'wxruby' do

  namespace 'startup' do

    task :config do
      if WXRuby3.config.windows?
        if WXRuby3.config.get_config('with-wxwin')
          File.open('lib/wx/startup.rb', 'a') do |f|
            f.puts <<~__CODE
              begin
                require 'ruby_installer'
                if RubyInstaller::Runtime.respond_to?(:add_dll_directory)
                  RubyInstaller::Runtime.add_dll_directory('#{File.expand_path('ext')}')
                else
                  RubyInstaller::Build.add_dll_directory('#{File.expand_path('ext')}')
                end
              rescue LoadError
              end
            __CODE
          end
        elsif WXRuby3.config.get_config('wxwin') && File.directory?(WXRuby3.config.get_config('wxwininstdir'))
          File.open('lib/wx/startup.rb', 'a') do |f|
            f.puts <<~__CODE
              begin
                require 'ruby_installer'
                if RubyInstaller::Runtime.respond_to?(:add_dll_directory)
                  RubyInstaller::Runtime.add_dll_directory('#{WXRuby3.config.get_config('wxwininstdir')}')
                else
                  RubyInstaller::Build.add_dll_directory('#{WXRuby3.config.get_config('wxwininstdir')}')
                end
              rescue LoadError
              end
            __CODE
          end
        end
      end
    end

  end

end
