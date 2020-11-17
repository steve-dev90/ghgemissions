
(function() {
  $( document ).ready(function() {

    var tabStatus = { power: false, gas: false, car: false, plane: false }

    $('.datepicker').pickadate({
      today: false,
      clear: 'Clear date',
      formatSubmit: 'dd/mm/yyyy'
    })

    // *** YES NO BUTTONS
    $('.button__yes--gas').click(function() { yesButtonActions('.form__gas--check','.form__gas--proper') })
    $('#car_form_answer_yes').click(function() { yesButtonActions('.form__car--check','.form__car--proper') })

    function yesButtonActions(formCheck, formProper) {
      $(formCheck).slideUp()
      $(formProper).removeClass("is-hidden")
    }


    $('.button__no--gas').click(function() {
      progressToNextForm ('gas', 'car')
    })

    // *** CAR FORM TOGGLES
    $('.toggle__no-car').children("input").click(function() {
      // if ($(this).prop('checked')) {
      //   $('.form__car--reg-petrol').removeClass("is-hidden")
      // } else {
      //   $('.form__car--reg-petrol').addClass("is-hidden")
      // }
    })

    $('.toggle__reg-petrol').children("input").click(function() {
      // toggle is-hidden
      if ($(this).prop('checked')) {
        $('.form__car--reg-petrol').removeClass("is-hidden")
      } else {
        $('.form__car--reg-petrol').addClass("is-hidden")
      }
    })

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
  })

  // *** FORM STATUS ***
  function addTickToFormStatusIcon(icon) {
    $(icon).addClass('fa-check-circle')
    $(icon).removeClass('fa-circle')
  }

  // *** POWER FORM VALIDATION ***
  // Dealing with missing inputs
  function missingInputs(inputs, tab) {
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
        return true
    }
  }

  function testPowerGasInputs(startDate, endDate, userEnergy, tab) {
    console.log(userEnergy)
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
    return {
      reg_petrol_period: $('#reg-petrol-period').val(),
      reg_petrol_amount: $('#reg-petrol-amount').val(),
      reg_petrol_unit: $('#reg-petrol-unit').val()
    }
  }

  function clearInputErrors(inputs, tab) {
    start_css_id = '#' + tab + '_'
    $.each( inputs, function( key, value ) {
      $(start_css_id + key).parent().next().empty()
      $(start_css_id  + key).removeClass("is-danger")
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

  function userEnergyToHigh(userEnergy, tab) {
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
    }
    appendErrMessage(errmessage, field_id)
    return false
  }

  function appendErrMessage(errmessage, field_id) {
    $(field_id).addClass('is-danger')
    $(field_id).parent().next().append("<p>" + errmessage + "<p>")
  }

  // *** FORM TABS ***
  function changeActiveTab(currentTab, nextTab) {
    $(".tabs__" + currentTab).removeClass("is-active")
    $(".tabs__" + nextTab).addClass("is-active")
    $(".form__" + currentTab).slideUp()
    $(".form__" + nextTab).slideDown()
  }

})()
