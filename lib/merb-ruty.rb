module MerbRuty
  
  # Returns version of the ruty template engine.
  def self.version
    "merb-ruty.rb 0.0.1.0"
  end
  
  # ruty base exception
  class Exception < ::Exception
  end

  # exception for runtime errors
  class TemplateRuntimeError < Exception
  end

  # exception for syntax errors
  class TemplateSyntaxError < Exception
  end

  # exception to indicate that a template a loader
  # tried to load does not exist.
  class TemplateNotFound < Exception
  end

  # load libraries
  require 'merb-ruty/constants'
  require 'merb-ruty/parser'
  require 'merb-ruty/context'
  require 'merb-ruty/datastructure'
  require 'merb-ruty/loaders'
  require 'merb-ruty/filters'
  require 'merb-ruty/tags'

  # ruty context
  RUTY_CONTEXT = {
    :block_start =>     Constants::BLOCK_START,
    :block_end =>       Constants::BLOCK_END,
    :var_start =>       Constants::VAR_START,
    :var_end =>         Constants::VAR_END,
    :comment_start =>   Constants::COMMENT_START,
    :comment_end =>     Constants::COMMENT_END,
    :version =>         MerbRuty.version
  }
  
  # template class
  class Template

    # load a template from a sourcecode or nodelist.
    def initialize source
      if source.is_a?(Datastructure::NodeList)
        @nodelist = source
      else
        @nodelist = Parser.new(source).parse
      end
    end

    # render the template. Pass it a hash or hashlike
    # object (must support [] and has_key?) which is
    # used as data storage for the root namespace
    def render namespace
      context = Context.new(namespace)
      context.push(
        :ruty =>      RUTY_CONTEXT,
        :nil =>       nil,
        :true =>      true,
        :false =>     false
      )
      result = ''
      @nodelist.render_node(context, result)
      result
    end
  end
end
