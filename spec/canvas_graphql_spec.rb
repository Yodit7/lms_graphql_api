require "byebug"
require "lms_graphql_api"

describe LMSGraphQL::Types::Canvas::Schema do

  it "executes the list_courses_for_user query" do
    canvas_api_proc = double
    canvas_api = double
    canvas_api_response = double

    expect(canvas_api_response).to receive(:parsed_response).and_return({})
    expect(canvas_api).to receive(:proxy).and_return(canvas_api_response)
    expect(canvas_api_proc).to receive(:call).with("LIST_COURSES_FOR_USER").and_return(canvas_api)

    variables = {
      "userId"=>"1234"
    }
    query = "query listCoursesForUser($userId: ID!) {\n  listCoursesForUser(userId: $userId) { id } \n}"
    operation_name = "listCoursesForUser"
    context = {
      canvas_api: canvas_api_proc
    }
    result = LMSGraphQL::Types::Canvas::Schema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    expect(result["data"]["listCoursesForUser"]).to eq []
  end

  it "runs an introspection query" do
    query = <<-CODE
      query IntrospectionQuery {
        __schema {
          queryType { name }
          mutationType { name }
          subscriptionType { name }
          types {
            ...FullType
          }
          directives {
            name
            description
            locations
            args {
              ...InputValue
            }
          }
        }
      }
      fragment FullType on __Type {
        kind
        name
        description
        fields(includeDeprecated: true) {
          name
          description
          args {
            ...InputValue
          }
          type {
            ...TypeRef
          }
          isDeprecated
          deprecationReason
        }
        inputFields {
          ...InputValue
        }
        interfaces {
          ...TypeRef
        }
        enumValues(includeDeprecated: true) {
          name
          description
          isDeprecated
          deprecationReason
        }
        possibleTypes {
          ...TypeRef
        }
      }
      fragment InputValue on __InputValue {
        name
        description
        type { ...TypeRef }
        defaultValue
      }
      fragment TypeRef on __Type {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
                ofType {
                  kind
                  name
                  ofType {
                    kind
                    name
                    ofType {
                      kind
                      name
                    }
                  }
                }
              }
            }
          }
        }
      }
    CODE
    result = LMSGraphQL::Types::Canvas::Schema.execute(query)
    root_query = result["data"]["__schema"]["types"].detect{|type| type["name"] == "Query"}
    listCoursesForUser = root_query["fields"].detect{|field| field["name"] == "listCoursesForUser"}
    expect(listCoursesForUser["name"]).to eq "listCoursesForUser"
  end

end
