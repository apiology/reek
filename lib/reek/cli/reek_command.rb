require 'reek/examiner'

module Reek
  module Cli

    #
    # A command to collect smells from a set of sources and write them out in
    # text report format.
    #
    class ReekCommand
      def self.create(sources, reporter, config_files = [])
        new(reporter, sources, config_files)
      end

      def initialize(reporter, sources, config_files = [])
        @sources = sources
        @reporter = reporter
        @config_files = config_files
      end

      def execute(view)
        examiners = @sources.map do |source|
          Examiner.new(source, @config_files)
        end

        examiners = examiners.sort_by { |examiner| examiner.smells_count }
        
        examiners.each do |examiner|
          view.output @reporter.report(examiner)
        end

        total_smells_count = examiners.map(&:smells_count).inject(0, :+)
        
        if total_smells_count > 0
          view.report_smells
        else
          view.report_success
        end

        view.output_smells_total(total_smells_count) if @sources.count > 1
      end
    end
  end
end
