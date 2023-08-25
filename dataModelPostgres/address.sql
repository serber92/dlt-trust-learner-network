CREATE TABLE address (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'address', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE address ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Based on schema.org Address object.",
    "type" : "object",
    "properties" : {
        "addressCountry" : {
            "description" : "Model Primitive Datatype = String. The country. For example, USA. You can also provide the two-letter ISO 3166-1 alpha-2 country code.",
            "type" : "string"
        },
        "addressLocality" : {
            "description" : "Model Primitive Datatype = String. The locality. For example, Mountain View.",
            "type" : "string"
        },
        "addressRegion" : {
            "description" : "Model Primitive Datatype = String. The region. For example, CA.",
            "type" : "string"
        },
        "postalCode" : {
            "description" : "Model Primitive Datatype = String. The postal code. For example, 94043.",
            "type" : "string"
        },
        "postOfficeBoxNumber" : {
            "description" : "Model Primitive Datatype = String. The post office box number for PO box addresses.",
            "type" : "string"
        },
        "streetAddress" : {
            "description" : "Model Primitive Datatype = String. The street address. For example, 1600 Amphitheatre Pkwy.",
            "type" : "string"
        }
    }
}', data));
