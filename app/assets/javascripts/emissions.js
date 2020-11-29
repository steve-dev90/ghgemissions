
(function() {

  const tabStatus = { power: false, gas: false, car: false, plane: false }

  $( document ).ready(function() {

    // *** DATE PICKER
    $('.datepicker').pickadate({
      today: false,
      clear: 'Clear date',
      formatSubmit: 'dd/mm/yyyy'
    })

    // *** YES NO BUTTONS
    const gasRadioButtons = yesNoRadioButtons('.form__gas--check','.form__gas--proper', 'gas', 'car')
    $('#gas_form_answer_yes').click(gasRadioButtons.yes)
    $('#gas_form_answer_no').click(gasRadioButtons.no)
    const carRadioButtons = yesNoRadioButtons('.form__car--check','.form__car--proper','car', 'plane')
    $('#car_form_answer_yes').click(carRadioButtons.yes)
    $('#car_form_answer_no').click(carRadioButtons.no)

    // *** CAR FORM TOGGLES
    $('.toggle__reg-petrol').children("input").click(function() {toggleCarFuel($(this))})
    $('.toggle__prem-petrol').children("input").click(function() {toggleCarFuel($(this))})
    $('.toggle__diesel').children("input").click(function() {toggleCarFuel($(this))})

    function toggleCarFuel(toggleInput) {
      // toggle is-hidden
      if (toggleInput.prop('checked')) {
        toggleInput.parent().next().removeClass("is-hidden")
      } else {
        toggleInput.parent().next().addClass("is-hidden")
      }
    }

    // *** NEXT BUTTON
    // Check for missing inputs and if none enable next button
    $('.form__power, .form__gas, .form__car').change(function() {
      form_name = $(this).attr('class').split(" ")[0].substr(6)
      inputs = getPowerGasFormInputs(form_name)
      if (form_name == 'car') { inputs = getCarFormInputs() }
      missingInputs(inputs,form_name)
    })

    // Useful article on passing arguments in jquery
    // https://stackoverflow.com/questions/979337/how-can-i-pass-arguments-to-event-handlers-in-jquery
    $('.button__next--power').click(function() { nextButtonActions('power','gas') })
    $('.button__next--gas').click(function() { nextButtonActions('gas','car') })
    $('.button__next--car').click(function() { nextButtonActions('car','plane') })

    function nextButtonActions(currentTab, nextTab) {
      if (checkFormInputs(currentTab)) {
        progressToNextForm (currentTab, nextTab)
      }
    }

    $('form').submit(function(e) {
      // Don't submit unless form inputs are OK
      if (!checkPowerFormInputs()) {
        e.preventDefault();
      }
    })

    // Tabs listener for switching between tabs
    $('.tabs__power').click(function() { tabActions($(this)) })
    $('.tabs__gas').click(function() { tabActions($(this)) })
    $('.tabs__car').click(function() { tabActions($(this)) })
    $('.tabs__plane').click(function() { tabActions($(this)) })

  })

  // *** YES NO RADIO BUTTONS ***
  // See this Medium article:
  // https://medium.com/javascript-in-plain-english/why-factories-are-better-than-classes-in-javascript-1248b600b6d4
  const yesNoRadioButtons = (formCheck, formProper, currentTab, nextTab) => {
    return {
      yes: () => {
        $(formCheck).slideUp()
        $(formProper).removeClass("is-hidden")
      },
      no: () => {
        progressToNextForm(currentTab, nextTab)
      }
    }
  }

  // *** NEXT BUTTON ***
  function progressToNextForm (currentTab, nextTab)  {
    $('.form__' + nextTab).removeClass("is-hidden")
    changeActiveTab(currentTab, nextTab)
    tabStatus[currentTab] = true
    if (nextTab == 'plane') {
      $('.button__submit')
        .prop('disabled', false)
        .removeClass("is-hidden")
    }
    $('.button__next--' + currentTab).hide()
    addTickToFormStatusIcon('.form-status__' + currentTab + '--icon')
    $(window).scrollTop(0);
  }

  // *** FORM STATUS ICONS ***
  function addTickToFormStatusIcon(icon) {
    $(icon).addClass('fa-check-circle')
    $(icon).removeClass('fa-circle')
  }

  // *** FORM TABS ***
  function tabActions(nextTabElement) {
    nextTab = nextTabElement.attr('class').split(" ")[0].substr(6)
    $('.tabs > ul > li').each(function () {
      if ($(this).attr('class').includes('is-active')) {
        currentTab = $(this).attr('class').split(" ")[0].substr(6)
      }
    })

    if (tabStatus[nextTab]) {
      // Next line : So you can return to uncompleted form
      tabStatus[currentTab] = true
      changeActiveTab(currentTab, nextTab)
    }
  }

  function changeActiveTab(currentTab, nextTab) {
    $(".tabs__" + currentTab).removeClass("is-active")
    $(".tabs__" + nextTab).addClass("is-active")
    $(".form__" + currentTab).slideUp()
    $(".form__" + nextTab).slideDown()
  }

  // *** POWER FORM VALIDATION ***
  // Dealing with missing inputs
  function missingInputs(inputs, tab) {
    // Check to amke sure inputs Object isn't empty
    if (jQuery.isEmptyObject(inputs)) { return }
    var missing = false
    $.each( inputs, function( key, value ) {
      if (!value) { missing = true}
    })
    if (!missing) { $('.button__next--' + tab).prop('disabled', false) }
  }

  // Dealing with input errors
  function checkFormInputs(tab) {
    switch (tab) {
      // Gas and power share the same code
      case 'gas':
      case 'power':
        inputs = getPowerGasFormInputs(tab)
        clearInputErrors(inputs, tab)
        return testPowerGasInputs(
          inputs.start_date, inputs.end_date,
          inputs.user_energy, tab)
      case 'car':
        inputs = getCarFormInputs()
        clearCarInputErrors()
        return userEnergyToHigh(inputs.reg_petrol_user_energy, 'reg_petrol') &
          userEnergyToHigh(inputs.prem_petrol_user_energy, 'prem_petrol') &
          userEnergyToHigh(inputs.diesel_user_energy, 'diesel')
    }
  }

  function testPowerGasInputs(startDate, endDate, userEnergy, tab) {
    if (incorrectEndDate(startDate, endDate, tab) & userEnergyToHigh(userEnergy, tab)) {
      return true
    } else {
      return false
    }
  }

  function getPowerGasFormInputs(tab) {
    start_css_id = '#' + tab + '_'
    return {
      start_date: $(start_css_id + 'start_date').val(),
      end_date: $(start_css_id + 'end_date').val(),
      user_energy: $(start_css_id + 'user_energy').val(),
    }
  }

  function getCarFormInputs() {
    var carFuels = ['reg_petrol', 'prem_petrol', 'diesel']
    var carFormInputs = {}
    $.each( carFuels, function(index, carFuel){
       if ($('#' + carFuel).prop('checked')) {
        carFormInputs[carFuel + '_period'] = $('#' + carFuel + '_period').val(),
        carFormInputs[carFuel + '_user_energy'] = $('#' + carFuel + '_user_energy').val(),
        carFormInputs[carFuel + '_unit'] = $('#' + carFuel + '_unit').val()
      }
    })
    return carFormInputs
  }

  function clearInputErrors(inputs, tab) {
    start_css_id = '#' + tab + '_'
    $.each( inputs, function( key, value ) {
      $(start_css_id + key).parent().next().empty()
      $(start_css_id  + key).removeClass("is-danger")
    })
  }

  function clearCarInputErrors() {
    $('.car__form--error').remove()
    var carFuels = ['reg_petrol', 'prem_petrol', 'diesel']
    $.each( carFuels, function(index, carFuel) {
      $('#' + carFuel + '_' + 'user_energy').removeClass("is-danger")
    })
  }

  function incorrectEndDate(inputStartDate, inputEndDate, tab) {
    startDate = new Date(inputStartDate)
    endDate = new Date(inputEndDate)
    start_css_id = '#' + tab + '_'
    if (endDate.getTime() < startDate.getTime()) {
      appendErrMessage("Check your bill end date", start_css_id + 'end_date')
      appendErrMessage("Check your bill start date", start_css_id + 'start_date')
      return false
    }
    return true
  }

  function userEnergyToHigh(userEnergy = 0, tab) {
    var errmessage
    console.log(userEnergy)
    // if (userEnergy) {return true}
    if (userEnergy >= 0 & userEnergy <= 10000) { return true }

    field_id = '#' + tab + '_' + 'user_energy'
    if (userEnergy < 0) { errmessage = "Must be a positive number" }
    if (userEnergy > 10000) {
      if (tab == 'power') {
        errmessage = "This seems a bit high, most households use about 250 - 750 kWh per month"
      }
      if (tab == 'gas') {
        errmessage = "This seems a bit high, most households use about 200 - 600 kWh per month"
      }
      errmessage = "This seems a bit high"
    }
    // console.log(errmessage, userEnergy,tab)
    appendErrMessage(errmessage, field_id)
    return false
  }

  function appendErrMessage(errmessage, field_id) {
    $(field_id).addClass('is-danger')
    if (field_id.includes('petrol') || field_id.includes('diesel')) {
      $(field_id).parent().append("<li class='car__form--error'>" + errmessage + "</li>")
      return
    }
    $(field_id).parent().next().append("<p>" + errmessage + "</p>")
  }

})()
