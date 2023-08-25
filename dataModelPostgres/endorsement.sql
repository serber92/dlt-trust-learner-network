CREATE TABLE endorsement (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Endorsement', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE endorsement ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "An endorsement claim.",
    "type" : "object",
    "properties" : {
        "id" : {
            "description" : "Model Primitive Datatype = NormalizedString. Globally unique IRI for the Endorsement. If this Endorsement will be verified using Hosted verification, the value should be the URL of the hosted version of the Endorsement.",
            "type" : "string"
        },
        "type" : {
            "description" : "Model Primitive Datatype = NormalizedString. The JSON-LD type of this entity. Normally Endorsement.",
            "type" : "string"
        },
        "claim" : {
            "description" : "An entity, identified by an id and additional properties that the endorser would like to claim about that entity.",
            "$ref" : "#/definitions/EndorsementClaimDType"
        },
        "issuedOn" : {
            "description" : "Model Primitive Datatype = DateTime. Timestamp of when the endorsement was published.",
            "type" : "string",
            "format" : "date-time"
        },
        "issuer" : {
            "description" : "The issuers Profile.",
            "$ref" : "#/definitions/EndorsementProfileDType"
        },
        "revocationReason" : {
            "description" : "Model Primitive Datatype = String. If revoked, optional reason for revocation.",
            "type" : "string"
        },
        "revoked" : {
            "description" : "Model Primitive Datatype = Boolean. If True the endorsement is revoked.",
            "type" : "boolean"
        },
        "verification" : {
            "description" : "Instructions for third parties to verify this assertion of endorsement.",
            "$ref" : "#/definitions/VerificationDType"
        }
    },
    "required" : [ "claim","issuedOn","issuer","verification" ],
}', data));
