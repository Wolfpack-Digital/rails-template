# frozen_string_literal: true

module ApipieRecorderPatch
  def record
    super.try(:merge, title: RSpec.current_example.metadata[:doc_title] || RSpec.current_example.example_group.description)
  end
end

module Apipie
  module Extractor
    class Recorder
      prepend ApipieRecorderPatch
    end
  end
end
