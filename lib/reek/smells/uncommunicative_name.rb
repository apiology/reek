$:.unshift File.dirname(__FILE__)

require 'reek/smells/smell'

module Reek
  module Smells

    #
    # An Uncommunicative Name is a name that doesn't communicate its intent
    # well enough.
    # 
    # Poor names make it hard for the reader to build a mental picture
    # of what's going on in the code. They can also be mis-interpreted;
    # and they hurt the flow of reading, because the reader must slow
    # down to interpret the names.
    #
    # Currently +UncommunicativeName+ checks for
    # * 1-character names
    # * names consisting of a single character followed by a number
    #
    class UncommunicativeName < Smell

      #
      # Checks the given +method+ for uncommunicative method name,
      # parameter names, local variable names and instance variable names.
      # Any smells found are added to the +report+; returns true in that case,
      # and false otherwise.
      #
      def self.examine(method, report)
        smell_reported = consider(method.name, method, report, 'method')
        method.parameters.each do |param|
          smell_reported = consider(param, method, report, 'parameter') || smell_reported
        end
        method.local_variables.each do |lvar|
          smell_reported = consider(lvar, method, report, 'local variable') || smell_reported
        end
        method.instance_variables.each do |ivar|
          smell_reported = consider(ivar, method, report, 'field') || smell_reported
        end
        smell_reported
      end

      def self.consider(sym, method, report, type)  # :nodoc:
        name = sym.to_s
        if is_bad_name?(name)
          report << new(name, method, type)
          return true
        end
        return false
      end

      def self.is_bad_name?(name)
        return false if name == '*'
        name = name[1..-1] while /^@/ === name
        return true if name.length < 2
        return true if /^.[0-9]$/ === name
        false
      end

      def initialize(name, context, symbol_type)
        super(context, symbol_type)
        @bad_name = name
        @symbol_type = symbol_type
      end

      def detailed_report
        "#{@context} uses the #{@symbol_type} name '#{@bad_name}'"
      end
    end

  end
end