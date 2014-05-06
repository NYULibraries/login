module LoginFeatures
  module WaitForAjax
    def wait_for_ajax(wait_time = Capybara.default_wait_time)
      Timeout.timeout(wait_time) do
        loop until finished_all_ajax_requests?
      end
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery.active').zero?
    end
  end
end
