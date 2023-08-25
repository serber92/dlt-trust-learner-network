CREATE TABLE endorsementClaim (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'EndorsementClaim', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE endorsementClaim ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "An entity, identified by an id and additional properties that the endorser would like to claim about that entity.",
    "type" : "object",
    "properties" : {
        "endorsementComment" : {
            "description" : "Model Primitive Datatype = String. An endorers comment about the quality or fitness of the endorsed entity. Markdown allowed.",
            "type" : "string"
        }
    },
    "patternProperties" : {
        "^[^:][^:]*:[^:][^:]*$" : {
            "oneOf": [{ "type": "string" }, { "type": "array" }, { "type": "boolean" }, { "type": "number" }, { "type": "integer" }]
        }
    }
}', data));
