CREATE TABLE alignment (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Alignment', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE alignment ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Alignment is based on the schema.org AlignmentObject.",
    "type" : "object",
    "properties" : {
        "frameworkName" : {
            "description" : "Model Primitive Datatype = String. The name of the framework to which the resource being described is aligned.",
            "type" : "string"
        },
        "targetCode" : {
            "description" : "Model Primitive Datatype = String. If applicable, a locally unique string identifier that identifies the alignment target within its framework.",
            "type" : "string"
        },
        "targetDescription" : {
            "description" : "Model Primitive Datatype = String. Short description of the alignment target.",
            "type" : "string"
        },
        "targetName" : {
            "description" : "Model Primitive Datatype = String. The name of a node in an established educational framework.",
            "type" : "string"
        },
        "targetUrl" : {
            "description" : "Model Primitive Datatype = AnyURI. The URL of a node in an established educational framework. When the alignment is to a CASE framework, the URL should be the uri of the target node.",
            "type" : "string",
            "format" : "uri"
        }
    },
    "required" : [ "targetName","targetUrl" ]
}', data));
