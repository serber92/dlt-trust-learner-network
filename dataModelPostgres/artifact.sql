CREATE TABLE artifact (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Artifact', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE artifact ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "An artifact that is part of an evidence object.",
    "type" : "object",
    "properties" : {
        "description" : {
            "description" : "Model Primitive Datatype = String. A description of the artifact.",
            "type" : "string"
        },
        "name" : {
            "description" : "Model Primitive Datatype = String. The name of the artifact.",
            "type" : "string"
        },
        "url" : {
            "description" : "Model Primitive Datatype = AnyURI. IRI of the artifact. May be a Data URI or the URL where the artifact may be found.",
            "type" : "string",
            "format" : "uri"
        }
    }
'}, data));
