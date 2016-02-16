module LoginFeatures
  module WaitForAjax
    def wait_for_ajax(wait_time = Capybara.default_max_wait_time)
      Timeout.timeout(wait_time) do
        loop until finished_all_ajax_requests?
      end
    end

    private

    def finished_all_ajax_requests?
      jquery_loaded && ajax_completed
    end

    def jquery_loaded
      page.evaluate_script('typeof $ !== "undefined" && $ !== null')
    end

    def ajax_completed
      page.evaluate_script('$.active').zero?
    end
  end
end
