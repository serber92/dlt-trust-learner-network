CREATE TABLE achievement (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'Achievement', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE achievement ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
"description" : "An accomplishment such as completing a degree, mastering a competency, or course completion that may be asserted about one or more learners.",
"type" : "object",
"properties" : {
    "achievementType" : {
        "description" : "A CLR Achievement can represent many different types of achievement from an assessment result to membership. Use Achievement to indicate an achievement not in the list of allowed values.",
        "type" : "string",
        "enum" : [ "Achievement","Assessment Result","Award","Badge","Certificate","Certification","Course","Community Service","Competency","Co-Curricular","Degree","Diploma","Fieldwork","License","Membership","Major", "TransferCredit","MissingCredit", "TransferDegree"]
    },
    "alignments" : {
        "description" : "Alignment objects describe an alignment between this achievement and a node in an educational framework.",
        "type" : "array",
        "minItems" : 0,
        "items" : {
            "$ref" : "#/definitions/AlignmentDType"
        }
    },
    "associations" : {
        "description" : "Associations between this achievement and other achievements.",
        "type" : "array",
        "minItems" : 0,
        "items" : {
            "$ref" : "#/definitions/AssociationDType"
        }
    },
    "creditsAvailable" : {
        "description" : "Model Primitive Datatype = Float. Credit hours associated with this entity, or credit hours possible. For example 3.0.",
        "type" : "number",
        "format" : "float"
    },
    "description" : {
        "description" : "Model Primitive Datatype = String. A short description of the achievement. May be the same as name if no description is available.",
        "type" : "string"
    },
    "endorsements" : {
        "description" : "Allows endorsers to make specific claims about the Achievement.",
        "type" : "array",
        "minItems" : 0,
        "items" : {
            "$ref" : "#/definitions/EndorsementDType"
        }
    },
    "humanCode" : {
        "description" : "Model Primitive Datatype = String. The code, generally human readable, associated with an achievement.",
        "type" : "string"
    },
    "name" : {
        "description" : "Model Primitive Datatype = String. The name of the achievement.",
        "type" : "string"
    },
    "fieldOfStudy" : {
        "description" : "Model Primitive Datatype = String. Category, subject, area of study,  discipline, or general branch of knowledge. Examples include Business, Education, Psychology, and Technology. ",
        "type" : "string"
    },
    "image" : {
        "description" : "Model Primitive Datatype = NormalizedString. IRI of an image representing the achievement. May be a Data URI or the URL where the image may be found.",
        "type" : "string"
    },
    "issuer" : {
        "description" : "A profile describing the individual or organization that issues assertions of this achievement.",
        "$ref" : "#/definitions/ProfileDType"
    },
    "level" : {
        "description" : "Model Primitive Datatype = String. Text that describes the level of achievement apart from how the achievement was performed or demonstrated. Examples would include Level 1, Level 2, Level 3, or Bachelors, Masters, Doctoral.",
        "type" : "string"
    },
    "requirement" : {
        "description" : "Criteria object describing how to earn the achievement.",
        "$ref" : "#/definitions/CriteriaDType"
    },
    "resultDescriptions" : {
        "description" : "The types of result that may be asserted with this achievement.",
        "type" : "array",
        "minItems" : 0,
        "items" : {
            "$ref" : "#/definitions/ResultDescriptionDType"
        }
    },
    "signedEndorsements" : {
        "description" : "Model Primitive Datatype = String. Signed endorsements in JWS Compact Serialization format.",
        "type" : "array",
        "minItems" : 0,
        "items" : {
            "type" : "string"
        }
    },
    "sourceKey" : {
        "description" : "Model Primitive Datatype = String. TLN Specific field for source key to aid in integration with SIS sources",
        "type" : "string"
    },
    "specialization" : {
        "description" : "Model Primitive Datatype = String. Name given to the focus, concentration, or specific area of study defined in the achievement. Examples include Entrepreneurship, Technical Communication, and Finance.",
        "type" : "string"
    },
    "tags" : {
        "description" : "Model Primitive Datatype = String. Tags that describe the type of achievement.",
        "type" : "array",
        "minItems" : 0,
        "items" : {
            "type" : "string"
        }
    }
},
"required" : [ "issuer" ],
"patternProperties" : {
    "^[^:][^:]*:[^:][^:]*$" : {
        "oneOf": [{ "type": "string" }, { "type": "array" }, { "type": "boolean" }, { "type": "number" }, { "type": "integer" }]
    }
}', data));
