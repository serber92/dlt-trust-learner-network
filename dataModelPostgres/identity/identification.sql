CREATE TABLE identification (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Identification', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE identification ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Association is based on the CASE CFAssociation object. An Association associates (relates) one Achievement with another Achievement.",
    "type" : "object",
    "properties" : {
        "identificationType" : {
            "description" : "The type of the relationship, used to define the alignment between two achievements.  ",
            "type" : "string",
            "enum" : [ "profileProfile","identityProfile","profileIdentity","identityIdentity" ]
        },
        "sequenceNumber" : {
            "description" : "Model Primitive Datatype = Integer. This is used to order associated objects. Identifications  can be created through mapping rather than strict hierarchy. As such the presentation of the list cannot be ordered by the objects in the list. They may be different based on the parent being viewed.",
            "type" : "integer",
            "format" : "int32"
        },
        "sourceId" : {
            "description" : "Model Primitive Datatype = NormalizedString. The id of source Identity or Profile",
            "type" : "string"
        },
        "targetId" : {
            "description" : "Model Primitive Datatype = NormalizedString. The id of target Identity or Profile",
            "type" : "string"
        }
    },
    "required" : [ "identificationType","sourceId","targetId" ]
}', data));
