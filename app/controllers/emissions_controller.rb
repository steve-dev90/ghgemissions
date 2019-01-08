class EmissionsController < ApplicationController
  def index
    @user_energy = emissions_params[:user_energy]
    emissions = Power::UserEmissions.new(emissions_params[:user_energy].to_f)
    pp emissions.calculate_user_emissions
    # @total_emissions = user_emissions.call.sum{ |e| e[:user_emission]}

    # Playing with fusion charts
    @chart = Fusioncharts::Chart.new({
      width: "600",
      height: "400",
      type: "mscolumn2d",
      renderAt: "chartContainer",
      dataSource: {
          chart: {
          caption: "Comparison of Quarterly Revenue",
          subCaption: "Harry's SuperMart",
          xAxisname: "Quarter",
          yAxisName: "Amount ($)",
          numberPrefix: "$",
          theme: "fint",
          exportEnabled: "1",
          },
          categories: [{
                  category: [
                      { label: "Q1" },
                      { label: "Q2" },
                      { label: "Q3" },
                      { label: "Q4" }
                  ]
              }],
              dataset: [
                  {
                      seriesname: "Previous Year",
                      data: [
                          { value: "10000" },
                          { value: "11500" },
                          { value: "12500" },
                          { value: "15000" }
                      ]
                  },
                  {
                      seriesname: "Current Year",
                      data: [
                          { value: "25400" },
                          { value: "29800" },
                          { value: "21800" },
                          { value: "26800" }
                      ]
                  }
            ]
      }
    })

  end

  private

  def emissions_params
    params.permit(:user_energy)
  end
end
