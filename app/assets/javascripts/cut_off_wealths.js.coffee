ready = ->
  $(document).on 'change keyup', '#new-cut-off-wealth-form .form-group :input:visible', ->
    if $(@).val() == ''
      $(@).parent('.form-group').addClass('has-error')
      $(@).parent('.form-group').removeClass('has-success')
    else
      $(@).parent('.form-group').addClass('has-success')
      $(@).parent('.form-group').removeClass('has-error')

    disabled = false
    $('.required-field:visible').each ->
      if $(@).val() == ''
        disabled = true

    submit = $('#new-cut-off-wealth-form-submit')

    if disabled
      submit.attr('disabled', true)
    else
      submit.attr('disabled', false)


$(document).ready(ready)
