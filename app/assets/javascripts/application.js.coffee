#= require modernizr
#= require jquery
#= require bootstrap/tooltip
#= require bootstrap/popover
#= require bootstrap/transition
#= require bootstrap/collapse
#= require bootstrap/alert
#= require bootstrap/dropdown
#= require nyulibraries/popover
$ ->
  # Help Popover
  new window.nyulibraries.HoverPopover("a.nyulibraries-help").init()
  new window.nyulibraries.PartialHoverPopover("a.nyulibraries-help-snippet").init()
