# frozen_string_literal: true

module RequestSpecHelper
  def response_json
    body = JSON.parse(response.body, symbolize_names: true)
    body.try(:with_indifferent_access) || body
  end
end
