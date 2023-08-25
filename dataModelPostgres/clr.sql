CREATE TABLE clr (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'CLR', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE clr ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "title" : "Comprehensive Learner Record (CLR) Version 1.0 IMS Candidate Final JSON Schema Binding (getClr-200-410-responsepayload-schema)",
    "description" : "Author-Jeff Bohrer (IMS Global), Andy Miller (IMS Global);  Version-2.0;  Release Date-February 7, 2020. ",
    "type" : "object",
    "properties" : {
        "id" : {
            "description" : "Model Primitive Datatype = NormalizedString. Unique IRI for the CLR.",
            "type" : "string"
        },
        "type" : {
            "description" : "Model Primitive Datatype = NormalizedString. The JSON-LD type of this object. Normally CLR.",
            "type" : "string"
        },
        "achievements" : {
            "description" : "Array of achievements that are related directly or indirectly through associations with the asserted achievements in the CLR. Primarily used to represent hierarchical pathways. Asserted achievements may appear in both this array and in the achievement assertion. If asserted achievements do appear in both places, they MUST match exactly.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "$ref" : "#/definitions/AchievementDType"
            }
        },
        "assertions" : {
            "description" : "The learners asserted achievements.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "$ref" : "#/definitions/AssertionDType"
            }
        },
        "issuedOn" : {
            "description" : "Model Primitive Datatype = DateTime. Timestamp of when the CLR was published.",
            "type" : "string",
            "format" : "date-time"
        },
        "learner" : {
            "description" : "The profile describing the recipient of the achievement assertions.",
            "$ref" : "#/definitions/ProfileDType"
        },
        "name" : {
            "description" : "Model Primitive Datatype = String. Optional name of the CLR.",
            "type" : "string"
        },
        "partial" : {
            "description" : "Model Primitive Datatype = Boolean. True if CLR does not contain all the assertions known by the publisher for the learner at the time the CLR is issued. Useful if you are sending a small set of achievements in real time when they are achieved. If False or omitted, the CLR SHOULD be interpreted as containing all the assertions for the learner known by the publisher at the time of issue.",
            "type" : "boolean"
        },
        "publisher" : {
            "description" : "A profile describing the publisher of the CLR.",
            "$ref" : "#/definitions/ProfileDType"
        },
        "revocationReason" : {
            "description" : "Model Primitive Datatype = String. If revoked, optional reason for revocation.",
            "type" : "string"
        },
        "revoked" : {
            "description" : "Model Primitive Datatype = Boolean. If True the CLR is revoked.",
            "type" : "boolean"
        },
        "signedAssertions" : {
            "description" : "Model Primitive Datatype = String. Signed assertions in JWS Compact Serialization format.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "type" : "string"
            }
        },
        "verification" : {
            "description" : "Instructions for third parties to verify this CLR.",
            "$ref" : "#/definitions/VerificationDType"
        }
    },
    "required" : [ "issuedOn","learner","publisher" ]
'}, data));
