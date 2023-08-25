CREATE TABLE criteria (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Criteria', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE criteria ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Descriptive metadata about the achievements necessary to be recognized with an Assertion of a particular AchievementType. This data is added to the AchievementType so that it may be rendered when that AchievementType is displayed, instead of simply a link to human-readable criteria external to the Achievement Assertion. Embedding criteria allows either enhancement of an external criteria page or increased portability and ease of use by allowing issuers to skip hosting the formerly-required external criteria page altogether.",
    "type" : "object",
    "properties" : {
        "narrative" : {
            "description" : "Model Primitive Datatype = String. A narrative of what is needed to earn the achievement. Markdown allowed.",
            "type" : "string"
        }
    },
    "patternProperties" : {
        "^[^:][^:]*:[^:][^:]*$" : {
            "oneOf": [{ "type": "string" }, { "type": "array" }, { "type": "boolean" }, { "type": "number" }, { "type": "integer" }]
        }
    }
}', data));
