CREATE TABLE assertion (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Assertion', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE assertion ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Assertions are representations of an Achievement awarded to a Learner.  It is used to share information about the Achievement Assertion, such as a result and verification method. Assertions are packaged for transmission as JSON objects with a set of mandatory and optional properties.",
    "type" : "object",
    "properties" : {
        "achievement" : {
            "description" : "The Achievement being asserted.",
            "$ref" : "#/definitions/AchievementDType"
        },
        "creditsEarned" : {
            "description" : "Model Primitive Datatype = Float. The number of credits earned, generally in semester or quarter credit hours.  This field correlates with the Achievement creditsAvailable field.",
            "type" : "number",
            "format" : "float"
        },
        "endDate" : {
            "description" : "Model Primitive Datatype = DateTime. If present, the assertion is not valid after this date.",
            "type" : "string",
            "format" : "date-time"
        },
        "endorsements" : {
            "description" : "Allows endorsers to make specific claims about the assertion.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "$ref" : "#/definitions/EndorsementDType"
            }
        },
        "evidence" : {
            "description" : "Evidence describing the work that the recipient did to earn the achievement. This can be a webpage that links out to other pages if linking directly to the work is infeasible.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "$ref" : "#/definitions/EvidenceDType"
            }
        },
        "image" : {
            "description" : "Model Primitive Datatype = NormalizedString. IRI of an image representing the assertion. May be a Data URI or the URL where the image may be found.",
            "type" : "string"
        },
        "issuedOn" : {
            "description" : "Model Primitive Datatype = DateTime. Timestamp of when the achievement was awarded. Required unless the assertion is revoked.",
            "type" : "string",
            "format" : "date-time"
        },
        "licenseNumber" : {
            "description" : "Model Primitive Datatype = String. The license number that was issued with this assertion.",
            "type" : "string"
        },
        "narrative" : {
            "description" : "Model Primitive Datatype = String. A narrative that describes the connection between multiple pieces of evidence. Likely only present if evidence is a multi-value array. Markdown allowed.",
            "type" : "string"
        },
        "recipient" : {
            "description" : "The recipient of the achievement. Required unless the assertion is revoked.",
            "$ref" : "#/definitions/IdentityDType"
        },
        "results" : {
            "description" : "The results being asserted.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "$ref" : "#/definitions/ResultDType"
            }
        },
        "revocationReason" : {
            "description" : "Model Primitive Datatype = String. Optional published reason for revocation, if revoked.",
            "type" : "string"
        },
        "revoked" : {
            "description" : "Model Primitive Datatype = Boolean. Defaults to false if this assertion is not referenced in a RevocationList. If revoked is true, only revoked and id are required properties, and many issuers strip a hosted assertion down to only those properties when revoked.",
            "type" : "boolean"
        },
        "role" : {
            "description" : "Model Primitive Datatype = String. Role, position, or title of the learner when demonstrating or performing the achievement or evidence of learning being asserted. Examples include Student President, Intern, Captain, etc.",
            "type" : "string"
        },
        "signedEndorsements" : {
            "description" : "Model Primitive Datatype = String. Signed endorsements in JWS Compact Serialization format.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "type" : "string"
            }
        },
        "source" : {
            "description" : "The person, organization, or system that assessed the achievement. The Achievement issuer is responsible for supporting verification.",
            "$ref" : "#/definitions/AssertionDType"
        },
        "startDate" : {
            "description" : "Model Primitive Datatype = DateTime. If present, the assertion is not valid before this date.",
            "type" : "string",
            "format" : "date-time"
        },
        "term" : {
            "description" : "Model Primitive Datatype = String. The academic term in which this assertion was achieved.",
            "type" : "string"
        },
        "verification" : {
            "description" : "Instructions for third parties to verify this assertion.",
            "$ref" : "#/definitions/VerificationDType"
        }
    }
}', data));
