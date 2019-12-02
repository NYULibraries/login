#= require modernizr
#= require jquery
#= require bootstrap/tooltip
#= require bootstrap/popover
#= require bootstrap/transition
#= require bootstrap/collapse
#= require bootstrap/alert
#= require bootstrap/dropdown
$ ->
	# Disabled nyulibraries_javascripts and so rebuilt the popover functionality here
	# since it was only being used by the one "Why am I on this page?" link for Login
	$('[rel="popover"]').each (index, element) ->
		$.get $(element).attr('href'), (data) ->
			$(element).attr('data-content', $(data).find("#nyulibrary_info").html())
			$(element).attr('data-html', "true")

	# Hide popover when clicking off of it
	$('[class!="popover"]').click (e) -> $(".popover").hide()
	# Continue to show popover when we enter it's area
	$(document).on 'mouseenter', ".popover", (e) ->
		$(@).show()
	# Hide popover when we leave it's area
	$(document).on 'mouseleave', ".popover", (e) ->
		$(@).hide()

	# Send custom options and trigger events into the popover init
	$('[rel="popover"]').popover({ trigger: 'manual', html: true, delay: { show: 500, hide: 100 } })
		.hover((e) -> e.preventDefault())
		.mouseenter((e) -> $(@).popover('show'))
		.mouseleave (e) ->
			unless $(e.relatedTarget).parent().hasClass("popover")
				$(@).popover('hide')