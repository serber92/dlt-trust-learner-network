CREATE TABLE profile (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Profile', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
--added birthdate as extension to profile.
ALTER TABLE profile ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "A Profile is a collection of information that describes the person or organization using Comprehensive Learner Record (CLR). Publishers, learners, and issuers must be represented as profiles. Recipients, endorsers, or other entities may also be represented using this vocabulary.",
    "type" : "object",
    "properties" : {
        "address" : {
            "description" : "An address for the individual or organization.",
            "$ref" : "#/definitions/AddressDType"
        },
        "birthdate" : {
            "description" : "Birthdate of individual",
			"type" : "string",
            "format" : "date-time"
		},
        "description" : {
            "description" : "Model Primitive Datatype = String. A short description of the individual or organization.",
            "type" : "string"
        },
        "email" : {
            "description" : "Model Primitive Datatype = String. A contact email address for the individual or organization.",
            "type" : "string"
        },
        "endorsements" : {
            "description" : "Allows endorsers to make specific claims about the individual or organization represented by this profile.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "$ref" : "#/definitions/EndorsementDType"
            }
        },
        "image" : {
            "description" : "Model Primitive Datatype = NormalizedString. IRI of an image representing the individual or organization. May be a DATA URI or the URL where the image may be found.",
            "type" : "string"
        },
        "name" : {
            "description" : "Model Primitive Datatype = String. The name of the individual or organization.",
            "type" : "string"
        },
        "publicKey" : {
            "description" : "The CrytographicKey object used to verify signed assertions and signed endorsements.",
            "$ref" : "#/definitions/CryptographicKeyDType"
        },
        "revocationList" : {
            "description" : "Model Primitive Datatype = AnyURI. The URL of the Revocation List document used for marking revocation of signed Assertions and Endorsements.",
            "type" : "string",
            "format" : "uri"
        },
        "signedEndorsements" : {
            "description" : "Model Primitive Datatype = String. Signed endorsements in JWS Compact Serialization format.",
            "type" : "array",
            "minItems" : 0,
            "items" : {
                "type" : "string"
            }
        },
        "sourcedId" : {
            "description" : "Model Primitive Datatype = String. The individuals unique sourcedId value, which is used for providing interoperability with IMS Learning Information Services (LIS).",
            "type" : "string"
        },
        "studentId" : {
            "description" : "Model Primitive Datatype = String. An institutions student identifier for the person. This is frequently issued through a Student Information System.",
            "type" : "string"
        },
        "telephone" : {
            "description" : "Model Primitive Datatype = String. Primary phone number for the individual or organization.",
            "type" : "string"
        },
        "url" : {
            "description" : "Model Primitive Datatype = AnyURI. Web resource that uniquely represents or belongs to the individual. This may be a resource about the individual, hosting provided by the instution to the individual, or an web resource independently controlled by the individual.",
            "type" : "string",
            "format" : "uri"
        },
        "verification" : {
            "description" : "Instructions for how to verify assertions and endorsements issued by the individual or organization represented by this profile.",
            "$ref" : "#/definitions/VerificationDType"
        }
    },
    "required" : [ "id","name" ],
    "patternProperties" : {
        "^[^:][^:]*:[^:][^:]*$" : {
            "oneOf": [{ "type": "string" }, { "type": "array" }, { "type": "boolean" }, { "type": "number" }, { "type": "integer" }]
        }
    }
}', data));
