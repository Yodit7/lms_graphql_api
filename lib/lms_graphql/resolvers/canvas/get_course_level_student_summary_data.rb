require_relative "../canvas_base_resolver"

module LMSGraphQL
  module Resolvers
    module Canvas
      class GetCourseLevelStudentSummaryDatum < CanvasBaseResolver
        type Boolean, null: false
        argument :course_id, ID, required: true
        argument :sort_column, String, required: false
        argument :student_id, ID, required: false
        def resolve(course_id:, sort_column: nil, student_id: nil, get_all: false)
          result = context[:canvas_api].call("GET_COURSE_LEVEL_STUDENT_SUMMARY_DATA").proxy(
            "GET_COURSE_LEVEL_STUDENT_SUMMARY_DATA",
            {
              "course_id": course_id,
              "sort_column": sort_column,
              "student_id": student_id            },
            nil,
            get_all,
          )
          get_all ? result : result.parsed_response
        end
      end
    end
  end
end