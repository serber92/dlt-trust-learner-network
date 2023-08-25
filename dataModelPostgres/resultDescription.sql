CREATE TABLE resultDescription (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE resultDescription ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Describes a possible achievement result.",
    "type" : "object",
    "properties" : {
        "type" : {
            "description" : "The JSON-LD type of this object. The strongly typed value identifies the type of result.",
            "type" : "string",
            "enum" : [ "CreditHours","GradePointAverage","LetterGrade","Percent","PerformanceLevel","PredictedScore","Result","RawScore","RubricCriterion","RubricCriterionLevel","RubricScore","ScaledScore" ]
        },
        "alignment" : {
            "description" : "Describe an alignment between this result and a node in a framework.",
            "$ref" : "#/definitions/AlignmentDType"
        },
        "name" : {
            "description" : "Model Primitive Datatype = String. The name of the result.",
            "type" : "string"
        },
        "resultMin" : {
            "description" : "Model Primitive Datatype = String. The minimum possible result that may be asserted.",
            "type" : "string"
        },
        "resultMax" : {
            "description" : "Model Primitive Datatype = String. The maximum possible result that may be asserted.",
            "type" : "string"
        }
    },
    "required" : [ "type" ]
}', data));
