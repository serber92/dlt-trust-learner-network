CREATE TABLE association (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Association', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE association ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Association is based on the CASE CFAssociation object. An Association associates (relates) one Achievement with another Achievement.",
    "type" : "object",
    "properties" : {
        "associationType" : {
            "description" : "The type of the relationship, used to define the alignment between two achievements.  ",
            "type" : "string",
            "enum" : [ "exactMatchOf","exemplar","hasSkillLevel","isChildOf","isParentOf","isPartOf","isPeerOf","isRelatedTo","precedes","replacedBy" ]
        },
        "sequenceNumber" : {
            "description" : "Model Primitive Datatype = Integer. This is used to order associated objects. Associations can be created through mapping rather than strict hierarchy. As such the presentation of the list cannot be ordered by the objects in the list. They may be different based on the parent being viewed.",
            "type" : "integer",
            "format" : "int32"
        },
        "targetId" : {
            "description" : "Model Primitive Datatype = NormalizedString. The id of another Achievement, or target of the association.",
            "type" : "string"
        }
    },
    "required" : [ "associationType","targetId" ]
}', data));
