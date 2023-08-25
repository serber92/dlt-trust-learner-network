CREATE TABLE verification (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE verification ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Information a reviewer can use to verify an Assertion or an Endorsement.",
    "type" : "object",
    "properties" : {
        "type" : {
            "description" : "The JSON-LD type of this object. The strongly typed value indicates the verification method.",
            "type" : "string",
            "enum" : [ "Hosted","Signed" ]
        },
        "allowedOrigins" : {
            "description" : "Model Primitive Datatype = String. The host registered name subcomponent of an allowed origin. Any given id URI will be considered valid.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "type" : "string"
            }
        },
        "creator" : {
            "description" : "Model Primitive Datatype = AnyURI. The URI of the CryptographicKey with the public key used to verify the signed Assertion. If not present, verifiers will check the publicKey property of the referenced issuer Profile. If present, the URI must match the CryptographicKey id in the issuer Profile as well.",
            "type" : "string",
            "format" : "uri"
        },
        "startsWith" : {
            "description" : "Model Primitive Datatype = String. The URI fragment that the verification property must start with. Valid Assertions must have an id within this scope. Multiple values allowed, and Assertions will be considered valid if their id starts with one of these values.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "type" : "string"
            }
        },
        "verificationProperty" : {
            "description" : "Model Primitive Datatype = String. The property to be used for verification. Only id is supported. Verifiers will consider id the default value if verificationProperty is omitted or if an issuer Profile has no explicit verification instructions, so it may be safely omitted.",
            "type" : "string"
        }
    },
    "required" : [ "type" ]
}', data));
