require_relative "../canvas_base_resolver"
require_relative "../../types/canvas/outcome_group"
module LMSGraphQL
  module Resolvers
    module Canvas
      class ShowOutcomeGroupGlobal < CanvasBaseResolver
        type LMSGraphQL::Types::Canvas::OutcomeGroup, null: false
        argument :id, ID, required: true
        def resolve(id:)
          context[:canvas_api].proxy(
            "SHOW_OUTCOME_GROUP_GLOBAL",
            {
              "id": id            },
            nil,
          ).parsed_response
        end
      end
    end
  end
end