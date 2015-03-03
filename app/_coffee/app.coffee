mini_nav_showing = false
$("#mini-nav-btn").on "click", ->
  if mini_nav_showing is false
    $("body").animate({"margin-top": "6rem"})
  else
    $("body").animate({"margin-top": "0rem"})
  mini_nav_showing = !mini_nav_showing

$(window).on "resize", ->
  if mini_nav_showing
    mini_nav_showing = false
    $("body").css "margin-top", 0

