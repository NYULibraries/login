module LoginFeatures
  module EzBorrow

    def set_bor_status_for_ezborrow_tests(status)
      VCR.configure do |c|
        c.filter_sensitive_data('<z305-bor-status>status</z305-bor-status>') { '<z305-bor-status>60</z305-bor-status>' }
      end
    end

  end
end
