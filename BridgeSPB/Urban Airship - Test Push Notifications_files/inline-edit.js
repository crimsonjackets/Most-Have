define(function(require) {
  // inline edit switches display between parent of trigger, and a sibling of parent with a .hidden class

  $('body').on('click', 'a.inline_edit', function (ev) {
    ev.preventDefault()

    var self = $(this)
      , parent = $(this).parent()
      , siblings = parent.siblings('.hidden')

    siblings.find('.cancel').click(click_cancel)
    siblings.removeClass('hidden')
    parent.addClass('hidden')

    function click_cancel(ev) {
      ev.preventDefault()

      siblings.addClass('hidden')
      parent.removeClass('hidden')
      siblings.unbind('click', click_cancel)
    }
  });
})

