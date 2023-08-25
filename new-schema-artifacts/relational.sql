CREATE EXTENSION IF NOT EXISTS pgcrypto; -- for gen_random_uuid

drop table IF EXISTS identity CASCADE;
CREATE TABLE identity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'Identity',
    identity TEXT,
    hashed BOOLEAN,
    salt TEXT
);

drop TABLE IF EXISTS address CASCADE;
CREATE TABLE address (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'Address',
    address_country TEXT,
    address_locality TEXT,
    address_region TEXT,
    postal_code TEXT,
    post_office_box_number TEXT,
    street_address TEXT
);

drop TABLE IF EXISTS endorsement_claim CASCADE;
CREATE TABLE endorsement_claim (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'EndorsementClaim', 
    endorsement_comment TEXT
);

drop TYPE IF EXISTS verificationType CASCADE;
CREATE TYPE verificationType AS ENUM (
    'Hosted', 'Signed', 'Verification'
);

drop TABLE IF EXISTS verification CASCADE;
CREATE TABLE verification (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    type verificationType NOT NULL,
    allowed_origins TEXT[],
    creator TEXT,
    starts_with TEXT[],
    verification_property TEXT
);

drop TABLE IF EXISTS cryptographic_key CASCADE;
CREATE TABLE cryptographic_key (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    type TEXT DEFAULT 'CryptographicKey', 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(),
    owner UUID NOT NULL,
    public_key_pem TEXT NOT NULL,
    CONSTRAINT fk_cryptographic_key_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS endorsement_profile CASCADE;
CREATE TABLE endorsement_profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'EndorsementProfile',
    address UUID,
    birthdate TEXT,
    description TEXT,
    email TEXT,
    image TEXT,
    name TEXT,
    public_key UUID,
    revocation_list TEXT,
    --not sure how we'll manage signed_endorsements, need a primer on Compact JWS and how that might apply to arrays, and how it get's searched and populated
    source_id TEXT,
    student_id TEXT,
    telephone TEXT,
    url TEXT,
    verification UUID,
    CONSTRAINT fk_endorser_address
      FOREIGN KEY(address) 
	      REFERENCES address(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_endorser_verification
      FOREIGN KEY(verification) 
	      REFERENCES verification(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_endorser_public_key
      FOREIGN KEY(public_key) 
	      REFERENCES cryptographic_key(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS endorsement CASCADE;
CREATE TABLE endorsement (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Endorsement', 
    claim UUID,
    issued_on TIMESTAMPTZ,
    issuer UUID,
    revocation_reason TEXT,
    revoked BOOLEAN,
    verification UUID,
    CONSTRAINT fk_claim
      FOREIGN KEY(claim) 
	      REFERENCES endorsement_claim(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_endorsement_issuer
      FOREIGN KEY(issuer) 
	      REFERENCES endorsement_profile(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_endorsement_verification
      FOREIGN KEY(verification) 
	      REFERENCES verification(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS profile CASCADE;
CREATE TABLE profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Profile',
    address UUID,
    birthdate TEXT,
    description TEXT,
    email TEXT,
    endorsements UUID[],
    image TEXT,
    name TEXT,
    public_key UUID,
    revocation_list TEXT,
    --not sure how we'll manage signed_endorsements, need a primer on Compact JWS and how that might apply to arrays, and how it get's searched and populated
    signed_endorsements TEXT[],
    source_id TEXT,
    student_id TEXT,
    telephone TEXT,
    url TEXT,
    verification UUID,
    CONSTRAINT fk_address
      FOREIGN KEY(address) 
	      REFERENCES address(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_profile_verification
      FOREIGN KEY(verification) 
	      REFERENCES verification(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_profile_public_key
      FOREIGN KEY(public_key) 
	      REFERENCES cryptographic_key(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS alignment CASCADE;
CREATE TABLE alignment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Alignment', 
    framework_name TEXT,
    target_code TEXT,
    target_description TEXT,
    target_name TEXT NOT NULL,
    target_url TEXT NOT NULL
);

drop TABLE IF EXISTS association CASCADE;
CREATE TABLE association (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'Association', 
    association_type TEXT NOT NULL,
    sequence_number INT,
    target_id UUID NOT NULL
);

drop TYPE IF EXISTS resultType CASCADE;
CREATE TYPE resultType AS ENUM (
    'CreditHours', 'GradePointAverage', 'LetterGrade', 'Percent', 
    'PerformanceLevel', 'PredictedScore', 'Result', 'RawScore', 
    'RubricCriterion', 'RubricCriterionLevel', 'RubricScore', 'ScaledScore'
);

drop TABLE IF EXISTS result CASCADE;
CREATE TABLE result (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'Result', 
    result_type resultType NOT NULL,
    alignment TEXT,
    value TEXT NOT NULL
);

drop TABLE IF EXISTS result_description CASCADE;
CREATE TABLE result_description (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Association', 
    alignment TEXT,
    name TEXT,
    result_min TEXT,
    result_max TEXT
);

drop TABLE IF EXISTS criteria CASCADE;
CREATE TABLE criteria (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    type TEXT DEFAULT 'Criteria', 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(),
    narrative TEXT
);

drop TYPE IF EXISTS achievementType CASCADE;
CREATE TYPE achievementType AS ENUM (
    'Achievement', 'Assessment Result', 'Award','Badge', 'Certification', 
    'Course', 'Community Service', 'Competency', 'Co-Curricular', 'Degree',
    'Diploma', 'ExamCredit', 'Fieldwork', 'License', 'Membership', 'TransferCredit', 
    'MissingCredit', 'TransferDegree', 'Honors', 'Major', 'Minor', 'ROTC', 
    'Certificate', 'Pre-Professional', 'Concentration'
);

drop TABLE IF EXISTS achievement CASCADE;
CREATE TABLE achievement (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Achievement',
    achievement_type achievementType NOT NULL,
    alignments UUID[],
    associations UUID[],
    credits_available TEXT,
    description TEXT,
    endorsements UUID[],
    human_code TEXT,
    name TEXT,
    field_of_study TEXT,
    image TEXT,
    issuer UUID NOT NULL,
    level TEXT,
    requirement UUID,
    result_descriptions text[],
    --not sure how we'll manage signed_endorsements, need a primer on Compact JWS and how that might apply to arrays, and how it get's searched and populated
    signed_endorsements TEXT[],
    source_key TEXT,
    specialization TEXT,
    tags TEXT, 
    properties TEXT,
    CONSTRAINT fk_achievement_issuer
      FOREIGN KEY(issuer) 
	      REFERENCES profile(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_achievement_requirement
      FOREIGN KEY(requirement) 
	      REFERENCES criteria(id)
	        ON DELETE SET NULL
);

drop TABLE IF EXISTS artifact CASCADE;
CREATE TABLE artifact (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Artifact', 
    description TEXT,
    name TEXT,
    url TEXT
);

drop TABLE IF EXISTS evidence CASCADE;
CREATE TABLE evidence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Evidence', 
    artifacts UUID[],
    audience TEXT, 
    description TEXT,
    genre TEXT,
    name TEXT,
    narrative TEXT
);

drop TABLE IF EXISTS assertion CASCADE;
CREATE TABLE assertion (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Assertion', 
    achievement UUID,
    credits_earned TEXT,
    end_date TIMESTAMPTZ,
    endorsements UUID[],
    evidence UUID[],
    image TEXT, 
    issued_on TIMESTAMPTZ,
    license_number TEXT,
    narrative TEXT,
    recipient TEXT,
    results UUID[],
    revocation_reason TEXT,
    revoked BOOLEAN,
    role TEXT,
    signed_endorsements TEXT[],
    source UUID,
    start_date TIMESTAMPTZ,
    term TEXT,
    verification UUID,
    CONSTRAINT fk_assertion_achievement
      FOREIGN KEY(achievement) 
	      REFERENCES achievement(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_assertion_source
      FOREIGN KEY(source) 
	      REFERENCES profile(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_assertion_verification
      FOREIGN KEY(verification) 
	      REFERENCES verification(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS clr CASCADE;
CREATE TABLE clr (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'CLR', 
    achievements UUID[],
    assertions UUID[],
    issued_on TIMESTAMPTZ,
    learner UUID,
    name TEXT,
    partial BOOLEAN,
    publisher UUID,
    revocation_reason TEXT,
    revoked BOOLEAN,
    signed_assertions TEXT[],
    verification UUID,
    CONSTRAINT fk_clr_learner
      FOREIGN KEY(learner) 
	      REFERENCES profile(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_clr_publisher
      FOREIGN KEY(publisher) 
	      REFERENCES profile(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_clr_verification
      FOREIGN KEY(verification) 
	      REFERENCES verification(id)
	      ON DELETE SET NULL
);

-- ACL

drop TABLE IF EXISTS participant CASCADE;
CREATE TABLE participant (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Participant', 
    active BOOLEAN,
    email TEXT,
    ip_address INET[],
    name TEXT,
    owner UUID,
    participant_type TEXT,
    public_key TEXT,
    CONSTRAINT fk_participant_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS identification CASCADE;
CREATE TABLE identification (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'Identification', 
    identity_type TEXT,
    owner UUID,
    identity UUID,
    profile UUID,
    CONSTRAINT fk_identification_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_identification_identity
      FOREIGN KEY(identity) 
	      REFERENCES identity(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_identification_profile
      FOREIGN KEY(profile) 
	      REFERENCES profile(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS related_participant CASCADE;
CREATE TABLE related_participant (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'RelatedParticipant', 
    active BOOLEAN,
    owner UUID,
    source_participant UUID,
    related_participant UUID,
    CONSTRAINT fk_related_participant_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_source_participant
      FOREIGN KEY(source_participant) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_related_participant
      FOREIGN KEY(related_participant) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS entity_permission CASCADE;
CREATE TABLE entity_permission (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'EntityPermission', 
    entity TEXT,
    allow_create BOOLEAN,
    allow_edit BOOLEAN,
    allow_read BOOLEAN,
    active BOOLEAN,
    owner UUID,
    permission_name TEXT,
    CONSTRAINT fk_entity_permission_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS permission_set CASCADE;
CREATE TABLE permission_set (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'PermissionSet', 
    active BOOLEAN,
    owner UUID,
    permission_name TEXT,
    CONSTRAINT fk_permission_set_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS field_permission CASCADE;
CREATE TABLE field_permission (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'FieldPermission', 
    editable BOOLEAN,
    field_name TEXT,
    entity_permission UUID,
    owner UUID,
    readable BOOLEAN,
    CONSTRAINT fk_entity_permission
      FOREIGN KEY(entity_permission) 
	      REFERENCES entity_permission(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS entity_permission_set CASCADE;
CREATE TABLE entity_permission_set (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'EntityPermissionSet', 
    entity_permission UUID,
    owner UUID,
    permission_set UUID,
    CONSTRAINT fk_entity_permission
      FOREIGN KEY(entity_permission) 
	      REFERENCES entity_permission(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_entity_permission_set_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_permission_set
      FOREIGN KEY(permission_set) 
	      REFERENCES permission_set(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS record_access CASCADE;
CREATE TABLE record_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'RecordAccess', 
    access_level VARCHAR(2),
    owner TEXT,
    participant UUID,
    participant_role VARCHAR(10),
    record UUID,
    status TEXT,
    CONSTRAINT fk_participant
      FOREIGN KEY(participant) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS record_access_approval CASCADE;
CREATE TABLE record_access_approval (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'RecordAccessApproval', 
    is_access_approved BOOLEAN,
    owner UUID,
    participant UUID,
    record_access UUID,
    CONSTRAINT fk_record_access_approval_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_record_access_participant
      FOREIGN KEY(participant) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_record_access_record
      FOREIGN KEY(record_access) 
	      REFERENCES record_access(id)
	      ON DELETE SET NULL
);

drop TABLE IF EXISTS participant_access CASCADE;
CREATE TABLE participant_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    last_updated TIMESTAMPTZ NOT NULL DEFAULT now(), 
    created_by TEXT NOT NULL,
    type TEXT DEFAULT 'ParticipantAccess', 
    entity_permission UUID,
    owner UUID,
    participant UUID,
    permission_set UUID,
    CONSTRAINT fk_participant_entity_permission
      FOREIGN KEY(entity_permission) 
	      REFERENCES entity_permission(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_participant_access_owner
      FOREIGN KEY(owner) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_participant_access
      FOREIGN KEY(participant) 
	      REFERENCES participant(id)
	      ON DELETE SET NULL,
    CONSTRAINT fk_participant_permission_set
      FOREIGN KEY(permission_set) 
	      REFERENCES permission_set(id)
	      ON DELETE SET NULL
);

-- TRIGGERS
drop FUNCTION IF EXISTS last_updated_Change CASCADE;
CREATE FUNCTION last_updated_Change() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN NEW;
END;
$$;

CREATE TRIGGER achievement_last_updated
  BEFORE UPDATE ON achievement
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER address_last_updated
  BEFORE UPDATE ON address
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER alignment_last_updated
  BEFORE UPDATE ON alignment
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER artifact_last_updated
  BEFORE UPDATE ON artifact
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER assertion_last_updated
  BEFORE UPDATE ON assertion
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER association_last_updated
  BEFORE UPDATE ON association
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER clr_last_updated
  BEFORE UPDATE ON clr
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER criteria_last_updated
  BEFORE UPDATE ON criteria
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER cryptographickey_last_updated
  BEFORE UPDATE ON cryptographickey
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER endorsement_last_updated
  BEFORE UPDATE ON endorsement
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER endorsementclaim_last_updated
  BEFORE UPDATE ON endorsementclaim
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER identity_last_updated
  BEFORE UPDATE ON identity
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER profile_last_updated
  BEFORE UPDATE ON profile
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER result_last_updated
  BEFORE UPDATE ON result
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER resultdescription_last_updated
  BEFORE UPDATE ON resultdescription
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();

CREATE TRIGGER verification_last_updated
  BEFORE UPDATE ON verification
  FOR EACH ROW
  EXECUTE PROCEDURE last_updated_Change();



--  SAMPLE DATA
insert into participant (created_by, active, email, ip_address, name, participant_type) values (
	'Init', true, 'rdavies3@asu.edu', '{24.9.29.185}', 'Roger Davies', 'admin'
);

update participant set owner = (select id from participant);

insert into profile(created_by, description, email, name, source_Id, telephone, url) 
	select id,
	'ASU is a comprehensive public research university, measured not by whom we exclude, but rather by whom we include and how they succeed, advancing research and discovery of public value, and assuming fundamental responsibility for the economic, social, cultural and overall health of the communities it serves.',
    'registrar@asu.edu',
    'Arizona State University',
    '1',
    '480.965.3124​',
    'https://www.asu.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'Welcome to Chandler-Gilbert Community College, where connecting to the communities we serve is reflected in our vision, mission, and values as an educational entity.',
    'admissionsandrecords@cgc.edu',
    'Chandler-Gilbert Community College',
    '1100104034',
    '480.732.7320​',
    'https://www.cgc.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'Estrella Mountain Community College (EMCC) is one of ten Maricopa Community Colleges (MCCCD) and is the newest in the District. MCCCD is one of the largest and oldest community college districts in the United States.',
    NULL,
    'Estrella Mountain Community College',
    '1100104058',
    '623.935.8000',
    'https://www.estrellamountain.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'GateWay Community College has built a legacy of innovation, pioneering vision and responsiveness to the needs of our community: the first technical college in Arizona, first to use community advisory committees, first to tailor courses to the needs of business and industry, first to offer classes at off-campus locations, even the first to install a computer. From a humble beginning in the former Korricks Department Store downtown, Maricopa Technical College has flourished for 50 years into todays GateWay.',
    NULL,
    'GateWay Community College',
    '1100102962',
    '602.286.8000',
    'https://www.gatewaycc.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'Education has the power to inspire growth and change lives. Since 1965 Glendale Community College has welcomed over 500,000 students as they worked towards graduating with two-year degrees, transferring to a university, completing new career training, or finishing an occupational certificate.',
    NULL,
    'Glendale Community College',
    '1100100067',
    '623.845.3000',
    'https://www2.gccaz.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'Pursuing an education can change a student’s life in ways they could never imagine.  In addition to obtaining a certificate or degree, our MCC students gain the knowledge and skills needed to enter the workforce or transfer to a college or university. Our faculty instruct students in a way that allows them to learn how to learn, engage in critical thinking, and teach content students need to succeed. By coming to MCC students are investing in their future, and we are dedicated to helping them on their journey.',
    NULL,
    'Mesa Community College',
    '1100100068',
    '480.461.7000',
    'https://www.mesacc.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'When you choose Paradise Valley Community College, you are choosing excellence in higher education.',
    NULL,
    'Paradise Valley Community College',
    '1100104033',
    '602.787.7862',
    'https://www.paradisevalley.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'With over 150 degree and certificate programs, Phoenix College serves approximately 17,000 students like you each year. We work hard to prepare you for whatever your next step is — university transfer, career training and advancement, or lifelong learning.',
    NULL,
    'Phoenix College',
    '1100100069',
    '602.285.7777',
    'https://www.phoenixcollege.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'Established in 1978, Rio Salado College is dedicated to providing innovative educational opportunities to meet the needs of today’s students. Rio Salado offers affordable access to higher education through college bridge pathways, community-based learning, corporate and government partnerships, early college initiatives, online learning and university transfer.',
    NULL,
    'Rio Salado College',
    '1100103913',
    '480.517.8000',
    'http://www.riosalado.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'Scottsdale Community College is student centered, with a focus on active, engaged and intellectually rigorous learning. The college is known for high quality, accessible educational opportunities and innovative teaching, learning and support services. SCC serves approximately 10,000 students a year, offering more than 100 degrees and 60 certificates of completion in diverse occupational areas. SCC is a leader in Developmental Education, Open Education Resources, Undergraduate Research, and Service Learning, all designed to improve and facilitate student success.',
    NULL,
    'Scottsdale Community College',
    '1100102963',
    '480.423.6000',
    'https://www.scottsdalecc.edu' from participant
;

insert into profile(created_by, description, email, name, source_Id, telephone, url)
    select id,
    'South Mountain Community College (SMCC) reflects the diversity of the surrounding community, a rich mix of rural, urban, and suburban neighborhoods. Many of our students arrive from Phoenix, Laveen, Tempe, Guadalupe and the surrounding area to attend classes at the main campus or our offsite facility in Guadalupe, we also offer evening courses in Laveen at Betty Fairfax High School.',
    NULL,
    'South Mountain Community College',
    '1100103912',
    '602.243.8000',
    'https://www.southmountaincc.edu' from participant
;