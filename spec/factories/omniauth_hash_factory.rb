# OmniAuth::AuthHash factory
# https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
FactoryGirl.define do
  factory :omniauth_hash, class: OmniAuth::AuthHash do
    skip_create

    trait :new_school_ldap do
      provider "new_school_ldap"
      uid "uid=12345,ou=people,o=newschool.edu,o=cp"
      info do
        {
          name: "Jon Snow",
          first_name: "Jon",
          last_name: "Snow",
          email: "snowj@1newschool.edu",
          nickname: "12345",
          uid: "uid=12345,ou=people,o=newschool.edu,o=cp"
        }
      end
      extra do
        {
          raw_info: {
            dn: ["uid=12345,ou=people,o=newschool.edu,o=cp"],
            displayname: ["Jon Snow"],
            givenname: ["Jon"],
            objectclass: ["top"],
            pdsacademicmajor: ["cn=Non-degree,ou=Major,o=newschool.edu,o=cp"],
            pdsexternalsystemid:
              ["12345::gtmb",
              "snowj@1newschool.edu::mir3",
              "#{(ENV["TEST_ALEPH_USER"] || 'BOR_ID')}::sct"],
            mail: ["snowj@1newschool.edu"],
            sn: ["Snow"],
            pdsemaildefaultaddress: ["snowj@1newschool.edu"],
            uid: ["12345"],
            pdsloginid: ["snowj"],
            pdsloginalias: ["snowj"],
            pdsrole: ["ns_staff"]
          }
        }
      end
    end
    trait :nyu_shibboleth do
      provider "nyu_shibboleth"
      uid "js123"
      info do
        {
          name: "Jon Snow",
          first_name: "Jon",
          last_name: "Snow",
          email: "snowj@1nyu.edu",
          nickname: "snowj",
          uid: "js123",
          location: "The Wall",
          phone: "123-456-7890"
        }
      end
      extra do
        {
          raw_info: {
            nyuidn: (ENV["TEST_ALEPH_USER"] || 'BOR_ID'),
            entitlement: "nothing"
          }
        }
      end
    end
    trait :aleph do
      provider "aleph"
      uid (ENV["TEST_ALEPH_USER"] || 'BOR_ID')
      info do
        {
          name: "SNOW, JON",
          first_name: "Jon",
          last_name: "Snow",
          email: "snowj@1nyu.edu",
          nickname: "SNOW",
          uid: (ENV["TEST_ALEPH_USER"] || 'BOR_ID'),
          location: "The Wall",
          phone: "123-456-7890"
        }
      end
      extra do
        {
          raw_info: {
            bor_auth: {
              z303: {
                z303_birthplace: "Kings Landing"
              },
              z305: {
                z305_bor_type: "Bastard",
                z305_bor_status: "Night's Watch",
                z305_photo_permission: "Y"
              }
            }
          }
        }
      end
    end
    trait :twitter do
      provider "twitter"
      uid "snowj"
      info do
        {
          name: "Jon Snow",
          first_name: "Jon",
          last_name: "Snow",
          email: "snowj@1nyu.edu",
          nickname: "@knowsnothing",
          location: "The Wall"
        }
      end
    end
    trait :facebook do
      provider "facebook"
      uid "snowj@1nyu.edu"
      info do
        {
          name: "Jon Snow",
          first_name: "Jon",
          last_name: "Snow",
          email: "snowj@1nyu.edu",
          nickname: "jonsnow",
          location: "The Wall"
        }
      end
    end

    factory :new_school_ldap_authhash, traits: [:new_school_ldap]
    factory :nyu_shibboleth_authhash, traits: [:nyu_shibboleth]
    factory :twitter_authhash, traits: [:twitter]
    factory :facebook_authhash, traits: [:facebook]
    factory :aleph_authhash, traits: [:aleph]

    factory :invalid_provider_authhash do
      uid "invalid"
      info do
        {
          name: "Invalid Provider"
        }
      end
    end
  end
end
