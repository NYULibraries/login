# OmniAuth::AuthHash factory
# https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
FactoryBot.define do
  factory :omniauth_hash, class: OmniAuth::AuthHash do
    skip_create

    trait :new_school_ldap do
      provider { "new_school_ldap" }
      uid { "snowj" }
      info do
        {
          name: "Jon Snow",
          first_name: "Jon",
          last_name: "Snow",
          email: "snowj@1newschool.edu",
          nickname: "12345",
          uid: "snowj"
        }
      end
      extra do
        {
          raw_info: {
            dn: ["uid=12345,ou=people,o=newschool.edu,o=cp"],
            displayname: ["Jon Snow"],
            givenname: ["Jon"],
            mail: ["snowj@1newschool.edu"],
            sn: ["Snow"],
            uid: ["snowj"],
            cn: [(ENV["TEST_ALEPH_USER"] || 'BOR_ID')]
          }
        }
      end
    end
    trait :nyu_shibboleth do
      provider { "nyu_shibboleth" }
      uid { "js123" }
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
      provider { "aleph" }
      uid (ENV["TEST_ALEPH_USER"] || 'BOR_ID')
      info do
        {
          name: "SNOW, JON",
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
                z303_id: (ENV["TEST_ALEPH_USER"] || 'BOR_ID'),
                z303_birthplace: "Kings Landing",
                z303_name: "SNOW, JON"
              },
              z305: {
                z305_bor_type: "Bastard",
                z305_bor_status: "05",
                z305_photo_permission: "Y"
              }
            }
          }
        }
      end
    end
    trait :large_aleph_record do
      extra do
        {
        raw_info: {
          bor_auth: {
            z303: {
               z303_id: "CATALOG",
               z303_proxy_for_id: "",
               z303_primary_id: "",
               z303_name_key: "catalog record                        CATALOG",
               z303_user_type: "",
               z303_user_library: "",
               z303_open_date: "06/25/2009",
               z303_update_date: "06/01/2011",
               z303_con_lng: "ENG",
               z303_alpha: "L",
               z303_name: "Catalog, Record",
               z303_title: "",
               z303_delinq_1: "00",
               z303_delinq_n_1: "",
               z303_delinq_1_update_date: "00000000",
               z303_delinq_1_cat_name: "",
               z303_delinq_2: "00",
               z303_delinq_n_2: "",
               z303_delinq_2_update_date: "00000000",
               z303_delinq_2_cat_name: "",
               z303_delinq_3: "00",
               z303_delinq_n_3: "",
               z303_delinq_3_update_date: "00000000",
               z303_delinq_3_cat_name: "",
               z303_budget: "",
               z303_profile_id: "",
               z303_ill_library: "",
               z303_home_library: "NYU Bobst",
               z303_field_1: "THIS RECORD IS TO BE USED BY THE NYU CATALOGUING DEPT.",
               z303_field_2: "",
               z303_field_3: "CR#049807343 REFERENCE rm 6/1/11",
               z303_note_1: "",
               z303_note_2: "",
               z303_salutation: "",
               z303_ill_total_limit: "9999",
               z303_ill_active_limit: "9999",
               z303_dispatch_library: "",
               z303_birth_date: "",
               z303_export_consent: "Y",
               z303_proxy_id_type: "00",
               z303_send_all_letters: "Y",
               z303_plain_html: "P",
               z303_want_sms: "N",
               z303_plif_modification: "",
               z303_title_req_limit: "0000",
               z303_gender: "",
               z303_birthplace: "",
               z303_upd_time_stamp: "200001011200000",
               z303_last_name: "",
               z303_first_name: ""
             },
             z304: {
               z304_id: "CATALOG",
               z304_sequence: "01",
               z304_address_0: "Record Catalog",
               z304_address_1: "20 Cooper Square",
               z304_address_2: "c/o ",
               z304_address_3: "New York, NY",
               z304_zip: "10003",
               z304_email_address: "",
               z304_telephone: "",
               z304_date_from: "20090625",
               z304_date_to: "20990724",
               z304_address_type: "01",
               z304_telephone_2: "",
               z304_telephone_3: "",
               z304_telephone_4: "",
               z304_sms_number: "",
               z304_update_date: "20140429",
               z304_cat_name: "RODRIGUEZF",
               z304_upd_time_stamp: "200001011200000"
             },
             z305: {
               z305_id: "CATALOG",
               z305_sub_library: "NYU50",
               z305_open_date: "06/25/2009",
               z305_update_date: "06/25/2009",
               z305_bor_type: "",
               z305_bor_status: "60",
               z305_registration_date: "00000000",
               z305_expiry_date: "08/31/2029",
               z305_note: "",
               z305_loan_permission: "N",
               z305_photo_permission: "Y",
               z305_over_permission: "Y",
               z305_multi_hold: "N",
               z305_loan_check: "N",
               z305_hold_permission: "N",
               z305_renew_permission: "N",
               z305_rr_permission: "N",
               z305_ignore_late_return: "N",
               z305_last_activity_date: "",
               z305_photo_charge: "C",
               z305_no_loan: "0000",
               z305_no_hold: "0000",
               z305_no_photo: "0000",
               z305_no_cash: "0000",
               z305_cash_limit: "0.00",
               z305_credit_debit: "",
               z305_sum: "0.00",
               z305_delinq_1: "00",
               z305_delinq_n_1: "",
               z305_delinq_1_update_date: "00000000",
               z305_delinq_1_cat_name: "",
               z305_delinq_2: "00",
               z305_delinq_n_2: "",
               z305_delinq_2_update_date: "00000000",
               z305_delinq_2_cat_name: "",
               z305_delinq_3: "00",
               z305_delinq_n_3: "",
               z305_delinq_3_update_date: "00000000",
               z305_delinq_3_cat_name: "",
               z305_field_1: "",
               z305_field_2: "",
               z305_field_3: "",
               z305_hold_on_shelf: "N",
               z305_end_block_date: "",
               z305_booking_permission: "N",
               z305_booking_ignore_hours: "N",
               z305_rush_cat_request: "N",
               z305_upd_time_stamp: "200001011200000"
             },
             session_id: "8QTA1TXTLBAE2YJAEL3NAD6MI9LA64Y1F69GC79YSC3DUKL2BI"
            }
          }
        }
      end
    end
    trait :twitter do
      provider { "twitter" }
      uid { "snowj" }
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
      provider { "facebook" }
      uid { "snowj@ 1nyu.edu"}
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
    factory :large_aleph_authhash, traits: [:large_aleph_record]

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
