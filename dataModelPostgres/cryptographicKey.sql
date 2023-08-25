CREATE TABLE cryptographicKey (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), type TEXT DEFAULT 'CryptographicKey', lastUpdated TIMESTAMPTZ NOT NULL DEFAULT now(), data JSONB);
ALTER TABLE cryptographicKey ADD CONSTRAINT data_is_valid CHECK (validate_json_schema('{
    "description" : "Based on the Key class from the W3C Web Payments Community Group Security Vocabulary. A CryptographicKey document identifies and describes a public key used to verify signed Assertions.",
    "type" : "object",
    "properties" : {
        "owner" : {
            "description" : "Model Primitive Datatype = NormalizedString. The identifier for the Profile that owns this PUBLIC KEY and the PRIVATE KEY used to sign the assertion or endorsement.",
            "type" : "string"
        },
        "publicKeyPem" : {
            "description" : "Model Primitive Datatype = String. The PUBLIC KEY in PEM format corresponding to the PRIVATE KEY used by the owner to sign the assertion or endorsement. The PEM key encoding is a widely-used method to express public keys, compatible with almost every Secure Sockets Layer library implementation.",
            "type" : "string"
        }
    },
    "required" : [ "owner","publicKeyPem" ],
}', data));
