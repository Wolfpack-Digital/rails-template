# frozen_string_literal: true

module ApipieRecorderPatch
  def record
    super.try(:merge, title: RSpec.current_example.metadata[:doc_title] || 'Default')
  end
end

module Apipie
  module Extractor
    class Recorder
      prepend ApipieRecorderPatch
    end
  end
end
