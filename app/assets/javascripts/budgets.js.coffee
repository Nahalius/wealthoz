# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  if $('#new-budget-form')
    row = $('tr.new_budget_row').clone().removeClass('hidden new_budget_row');
    $('tr.actions').before(row);

  $(document).on 'change keyup', '#new-budget-form .form-group .required-field:input:visible', ->
    if $(@).val() == ''
      $(@).parent('.form-group').addClass('has-error')
      $(@).parent('.form-group').removeClass('has-success')
    else
      $(@).parent('.form-group').addClass('has-success')
      $(@).parent('.form-group').removeClass('has-error')



  $('#_form').click (e)->
    e.preventDefault()
    row = $('tr.new_budget_row').clone().removeClass('hidden new_budget_row');

    $('tr.actions').before(row);



  $(document).on 'click', '.delete-link', (e)->
    e.preventDefault()
    $(@).closest('tr').remove()
    $.ajax(
      url: '/accounts/check'
      dataType: 'json'
    ).done calculateWealth

  $('#new-budget-form-submit').attr('disabled', 'disabled')


  calculateWealth =  (data)->
    $.each data.grouped_accounts, (fs_id, account_ids)->
      fs_name = data.fss[fs_id]
      total = 0
      $('select.budget-account-select:visible option:selected').each ->
        if $(@).closest('tr').find('.budget-ammount-input').val()
          if $.inArray(parseFloat($(@).val()), account_ids) > -1
            total += parseFloat($(@).closest('tr').find('.budget-ammount-input').val()) || parseFloat(0)
      $(".#{fs_name.toLowerCase().split(' ').join('_')}").find('.badge').html(total.toFixed(2))

      assets   = parseFloat($('.assets .badge').html())   || parseFloat(0)
      debt     = parseFloat($('.debt .badge').html())     || parseFloat(0)
      income   = parseFloat($('.income .badge').html())   || parseFloat(0)
      expenses = parseFloat($('.expenses .badge').html()) || parseFloat(0)
      accumulated_wealth = parseInt($('.accumulated_wealth .badge').html()) || parseFloat(0)

      unbalanced = assets + debt - income - expenses - accumulated_wealth
      $('.unbalanced-amount').html(unbalanced.toFixed(2))


      wealth = assets + debt
      $('.wealth').html(wealth)

      disabled = false
      $('#new-budget-form .form-group .required-field:input:visible').each ->
        if $(@).val() == ''
          disabled = true

      if parseInt(unbalanced) == 0 && not disabled
        $('#new-budget-form-submit').attr('disabled', false)
      else
        $('#new-budget-form-submit').attr('disabled', true)

  ajaxCalculateWealth = ->
    $.ajax(
      url: '/accounts/check'
      dataType: 'json'
    ).done calculateWealth

  $(document).on 'change', '.budget-account-select', ->
    if $(@).closest('tr').find('.budget-ammount-input').val()
      ajaxCalculateWealth()


  $(document).on 'keyup', '.budget-ammount-input', ->
    $this = $(@)
    account_id = $(@).closest('tr').find('.budget-account-select option:selected').val()

    if account_id
      ajaxCalculateWealth()

  $(document).on 'change keyup', '.budget-wunit-select, .budget-date-input ', ->
    account = $(@).closest('tr').find('.budget-account-select option:selected').val()
    ammount = $(@).closest('tr').find('.budget-ammount-input').val()
    if ammount && account
      ajaxCalculateWealth()






$(document).ready(ready)



jQuery ->
  $('#budgets').dataTable()
