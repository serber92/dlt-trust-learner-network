CREATE TABLE identity (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'id', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE identity ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "A collection of information about the recipient of an achievement assertion.",
    "type" : "object",
    "properties" : {
        "identity" : {
            "description" : "Model Primitive Datatype = String. Either the hash of the identity or the plaintext value. If its possible that the plaintext transmission and storage of the identity value would leak personally identifiable information where there is an expectation of privacy, it is strongly recommended that an IdentityHash be used.",
            "type" : "string"
        },
        "hashed" : {
            "description" : "Model Primitive Datatype = Boolean. Whether or not the identity value is hashed.",
            "type" : "boolean"
        },
        "salt" : {
            "description" : "Model Primitive Datatype = String. If the recipient is hashed, this should contain the string used to salt the hash. If this value is not provided, it should be assumed that the hash was not salted.",
            "type" : "string"
        }
    },
    "required" : [ "identity","hashed" ]
}', data));
