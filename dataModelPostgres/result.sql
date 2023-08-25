CREATE TABLE result (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE result ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Describes a result of an achievement.",
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
        "value" : {
            "description" : "Model Primitive Datatype = String. A grade or value representing the result of the performance, or demonstration, of the achievement.  For example, A if the recipient received a grade of A in the class. ",
            "type" : "string"
        }
    },
    "required" : [ "type","value" ]
}', data));
