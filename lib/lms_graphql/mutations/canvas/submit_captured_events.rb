require_relative "../canvas_base_mutation"

module LMSGraphQL
  module Mutations
    module Canvas
      class SubmitCapturedEvent < BaseMutation
        argument :course_id, ID, required: true
        argument :quiz_id, ID, required: true
        argument :id, ID, required: true
        argument :quiz_submission_events, [String], required: true
        field :return_value, Boolean, null: false
        def resolve(course_id:, quiz_id:, id:, quiz_submission_events:)
          context[:canvas_api].call("SUBMIT_CAPTURED_EVENTS").proxy(
            "SUBMIT_CAPTURED_EVENTS",
            {
              "course_id": course_id,
              "quiz_id": quiz_id,
              "id": id
            },
            {
              "quiz_submission_events": quiz_submission_events
            },
          ).parsed_response
        end
      end
    end
  end
end