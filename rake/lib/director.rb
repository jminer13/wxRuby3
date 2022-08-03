#--------------------------------------------------------------------
# @file    director.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

require 'ostruct'
require 'set'

require_relative './extractor'
require_relative './config'

module WXRuby3

  class Director

    class Spec < OpenStruct

      IGNORED_BASES = ['wxTrackable']

      def initialize(pkg, modname, name, items, director:  nil, &block)
        @package = pkg
        @module_name = modname
        @name = name
        @folded_bases = {}
        @ignored_bases = {}
        @abstract = false
        @items = items
        @director = director
        @gc_type = nil
        @ignores = Set.new
        @no_proxies = Set.new
        @includes = Set.new
        @swig_imports = Set.new
        @swig_includes = Set.new
        @renames = Hash.new
        @swig_begin_code = []
        @begin_code = []
        @swig_runtime_code = []
        @runtime_code = []
        @swig_header_code = []
        @header_code = []
        @swig_wrapper_code = []
        @wrapper_code = []
        @swig_init_code = []
        @init_code = []
        @swig_interface_code = []
        @interface_code = []
        @extend_code = {}
        super()
        yield(self) if block_given?
      end

      attr_reader :director, :package, :module_name, :name, :items, :folded_bases, :ignored_bases, :gc_type, :ignores, :no_proxies,
                  :includes, :swig_imports, :swig_includes, :renames,
                  :swig_begin_code, :begin_code, :swig_runtime_code, :runtime_code,
                  :swig_header_code, :header_code, :swig_wrapper_code, :wrapper_code, :extend_code,
                  :swig_init_code, :init_code, :swig_interface_code, :interface_code

      def interface_file
        File.join(WXRuby3::Config.instance.classes_path, @name + '.i')
      end

      def fold_bases(*specs)
        specs.each do |foldspec|
          if ::Hash === foldspec
            foldspec.each_pair do |classnm, subclasses|
              @folded_bases[classnm] = [subclasses].flatten
            end
          else
            raise "Invalid class folding specs [#{specs.inspect}]"
          end
        end
        self
      end

      def ignore_bases(*specs)
        specs.each do |foldspec|
          if ::Hash === foldspec
            foldspec.each_pair do |classnm, subclasses|
              @ignored_bases[classnm] = [subclasses].flatten
            end
          else
            raise "Invalid class ignore specs [#{specs.inspect}]"
          end
        end
        self
      end

      def gc_never
        @gc_type = :GC_NEVER
        self
      end

      def gc_as_object
        @gc_type = :GC_MANAGE_AS_OBJECT
        self
      end

      def gc_as_window
        @gc_type = :GC_MANAGE_AS_WINDOW
        self
      end

      def gc_as_frame
        @gc_type = :GC_MANAGE_AS_FRAME
        self
      end

      def gc_as_dialog
        @gc_type = :GC_MANAGE_AS_DIALOG
        self
      end

      def gc_as_event
        @gc_type = :GC_MANAGE_AS_EVENT
        self
      end

      def gc_as_sizer
        @gc_type = :GC_MANAGE_AS_SIZER
        self
      end

      def gc_as_temporary
        @gc_type = :GC_MANAGE_AS_TEMP
        self
      end

      def abstract(v=nil)
        unless v.nil?
          @abstract = !!v
          self
        else
          @abstract
        end
      end

      def ignore(*names)
        @ignores.merge(names.flatten)
        self
      end

      def no_proxy(*names)
        @no_proxies.merge(names.flatten)
        self
      end

      def include(*paths)
        @includes.merge(paths.flatten)
        self
      end

      def swig_import(*paths)
        @swig_imports.merge(paths.flatten)
        self
      end

      def swig_include(*paths)
        @swig_includes.merge(paths.flatten)
        self
      end

      def rename(table)
        @renames.merge!(table)
        self
      end

      def add_swig_begin_code(*code)
        @swig_begin_code.concat code.flatten
        self
      end

      def add_begin_code(*code)
        @begin_code.concat code.flatten
        self
      end

      def add_swig_runtime_code(*code)
        @swig_runtime_code.concat code.flatten
        self
      end

      def add_runtime_code(*code)
        @runtime_code.concat code.flatten
        self
      end

      def add_swig_header_code(*code)
        @swig_header_code.concat code.flatten
        self
      end

      def add_header_code(*code)
        @header_code.concat code.flatten
        self
      end

      def add_swig_wrapper_code(*code)
        @swig_wrapper_code.concat code.flatten
        self
      end

      def add_wrapper_code(*code)
        @wrapper_code.concat code.flatten
        self
      end

      def add_swig_init_code(*code)
        @swig_init_code.concat code.flatten
        self
      end

      def add_init_code(*code)
        @init_code.concat code.flatten
        self
      end

      def add_swig_interface_code(*code)
        @swig_interface_code.concat code.flatten
        self
      end

      def add_interface_code(*code)
        @interface_code.concat code.flatten
        self
      end

      def add_extend_code(classname, *code)
        (@extend_code[classname] ||= []).concat code.flatten
        self
      end

    end

    class << self
      def Spec(pkg, modname, name, items, director:  nil, &block)
        WXRuby3::Director::Spec.new(pkg, modname, name, items, director: director, &block)
      end

      private

      def process_interface_specs(specs)
        specs.each do |spec|
          (spec.director || Director).new.run(spec)
        end
      end

    end

    def self.run
      process_interface_specs(WXRuby3::SPECIFICATIONS)
    end

    def run(spec)
      setup(spec)

      defmod = process(spec)

      generator.run(Generator::Spec.new(spec, defmod))
    end

    protected

    def setup(spec)
      # noop
    end

    def process(spec)
      # extract the module definitions
      defmod = Extractor.extract_module(spec.package, spec.module_name, spec.name, spec.items, doc: '')
      # handle ignores
      spec.ignores.each do |fullname|
        name = fullname
        args = nil
        const = false
        if (ix = name.index('('))   # full signature supplied?
          args = name.slice(ix, name.size)
          name = name.slice(0, ix)
          const = !!args.index(/\)\s+const/)
          args.sub(/\)\s+const/, ')') if const
        end
        item = defmod.find_item(name)
        if item
          if args
            overload = item.find_overload(args, const)
            if overload
              overload.ignore if overload
            else
              raise "Cannot find '#{fullname}' for module '#{spec.module_name}'. Possible match is '#{item.signature}'"
            end
          else
            item.ignore
          end
        else
          raise "Cannot find '#{fullname}' for module '#{spec.module_name}'"
        end
      end

      defmod
    end

    def generator
      WXRuby3::StandardGenerator.new
    end

  end # class Director

end # module WXRuby3

Dir.glob(File.join(File.dirname(__FILE__), 'generate', '*.rb')).each do |fn|
  require fn
end
Dir.glob(File.join(File.dirname(__FILE__), 'director', '*.rb')).each do |fn|
  require fn
end

require_relative './specs/interfaces'
