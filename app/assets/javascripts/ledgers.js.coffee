# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/





ready = ->
  if $('#new-ledger-form')
    row = $('tr.new_ledger_row').clone().removeClass('hidden new_ledger_row');
    $('tr.actions').before(row);

  $(document).on 'change keyup', '#new-ledger-form .form-group .required-field:input:visible', ->
    if $(@).val() == ''
      $(@).parent('.form-group').addClass('has-error')
      $(@).parent('.form-group').removeClass('has-success')
    else
      $(@).parent('.form-group').addClass('has-success')
      $(@).parent('.form-group').removeClass('has-error')



  $('#_form').click (e)->
    e.preventDefault()
    row = $('tr.new_ledger_row').clone().removeClass('hidden new_ledger_row');

    $('tr.actions').before(row);



  $(document).on 'click', '.delete-link', (e)->
    e.preventDefault()
    $(@).closest('tr').remove()
    $.ajax(
      url: '/accounts/check'
      dataType: 'json'
    ).done calculateWealth

  $('#new-ledger-form-submit').attr('disabled', 'disabled')


  calculateWealth =  (data)->
    $.each data.grouped_accounts, (fs_id, account_ids)->
      fs_name = data.fss[fs_id]
      total = 0
      $('select.ledger-account-select:visible option:selected').each ->
        console.log $(@).closest('tr').find('.ledger-ammount-input').val()
        if $(@).closest('tr').find('.ledger-ammount-input').val()
          if $.inArray(parseFloat($(@).val()), account_ids) > -1
            total += parseFloat($(@).closest('tr').find('.ledger-ammount-input').val()) || parseFloat(0)
        else
          console.log 'nqma'
      $(".#{fs_name.toLowerCase().split(' ').join('_')}").find('.badge').html(total.toFixed(2))
      # console.log $(".#{fs_name.toLowerCase()}").find('.badge')
      assets   = parseFloat($('.assets .badge').html())   || parseFloat(0)
      debt     = parseFloat($('.debt .badge').html())     || parseFloat(0)
      income   = parseFloat($('.income .badge').html())   || parseFloat(0)
      expenses = parseFloat($('.expenses .badge').html()) || parseFloat(0)
      accumulated_wealth = parseFloat($('.accumulated_wealth .badge').html()) || parseFloat(0)

      unbalanced = assets + debt - income - expenses - accumulated_wealth
      $('.unbalanced-amount').html(unbalanced.toFixed(2))


      wealth = assets + debt
      $('.wealth').html(wealth)

      disabled = false

      $('#new-ledger-form .form-group .required-field:input:visible').each ->
        console.log($(@).val() == '', $(@).val())
        if $(@).val() == ''
          disabled = true
      console.log(parseInt(unbalanced), disabled)

      if parseInt(unbalanced) == 0 && not disabled
        $('#new-ledger-form-submit').attr('disabled', false)
      else
        $('#new-ledger-form-submit').attr('disabled', true)

  ajaxCalculateWealth = ->
    $.ajax(
      url: '/accounts/check'
      dataType: 'json'
    ).done calculateWealth

  $(document).on 'change', '.ledger-account-select', ->
    if $(@).closest('tr').find('.ledger-ammount-input').val()
      ajaxCalculateWealth()


  $(document).on 'keyup', '.ledger-ammount-input', ->
    $this = $(@)
    account_id = $(@).closest('tr').find('.ledger-account-select option:selected').val()

    if account_id
      ajaxCalculateWealth()

  $(document).on 'change keyup', '.ledger-wunit-select, .ledger-date-input ', ->
    account = $(@).closest('tr').find('.ledger-account-select option:selected').val()
    ammount = $(@).closest('tr').find('.ledger-ammount-input').val()
    if ammount && account
      ajaxCalculateWealth()






$(document).ready(ready)




jQuery ->
  $('#transactions').dataTable()

jQuery ->
  $('#bs_table').dataTable(searching: false,paging: false,)

jQuery ->
  $('#pl_m_table').dataTable(searching: false,paging: false,)

jQuery ->
  $('#pl_w_table').dataTable(searching: false,paging: false,)
