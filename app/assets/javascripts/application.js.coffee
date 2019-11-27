#= require modernizr
#= require jquery
#= require bootstrap/tooltip
#= require bootstrap/popover
#= require bootstrap/transition
#= require bootstrap/collapse
#= require bootstrap/alert
#= require bootstrap/dropdown
$ ->
	$('[rel="popover"]').each (index, element) ->
		$.get $(element).attr('href'), (data) ->
			$(element).attr('data-content', $(data).find("#nyulibrary_info").html())
			$(element).attr('data-html', "true")

	# Hide popover when clicking off of it
	$('[class!="popover"]').click (e) -> $(".popover").hide()
	# Continue to show popover when we enter it's area
	$(document).on 'mouseenter', ".popover", (e) ->
		console.log("In "+ e)
		$(@).show()
	# Hide popover when we leave it's area
	$(document).on 'mouseleave', ".popover", (e) ->
		console.log("Out "+ e)
		$(@).hide()

	$('[rel="popover"]').popover({ html: true, delay: { show: 500, hide: 100 } }).hover((e) -> e.preventDefault())
		.mouseenter((e) -> $(@).popover('show'))
		.mouseleave (e) ->
			unless $(e.relatedTarget).parent().hasClass("popover")
				$(@).popover('hide')