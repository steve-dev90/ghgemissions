module EmissionsHelper

  def get_user_emissions_chart(chartDataObj)
    # Chart appearance configuration
    chartAppearancesConfigObj = Hash.new
    chartAppearancesConfigObj = {
                               "caption" => "User Emissions By Trading Period",
                               "xAxisName" => "Trading Period",
                               "yAxisName" => "Emissions (kgCO2)",
                               "theme" => "fusion"
    }

    # Chart data template to store data in "Label" & "Value" format
    labelValueTemplate = "{ \"label\": \"%s\", \"value\": \"%s\" },"

    # Chart data as JSON string
    labelValueJSONStr = ""

    chartDataObj.each {|item|
        data = labelValueTemplate % [item[:trading_period].to_s, item[:user_emission].to_s]
        labelValueJSONStr.concat(data)
    }

    # Removing trailing comma character
    labelValueJSONStr = labelValueJSONStr.chop

    # Chart JSON data template
    chartJSONDataTemplate = "{ \"chart\": %s, \"data\": [%s] }"

    # Final Chart JSON data from template
    chartJSONDataStr = chartJSONDataTemplate % [chartAppearancesConfigObj.to_json, labelValueJSONStr]

    # Chart rendering
    @chart = Fusioncharts::Chart.new({
                  width: "600",
                  height: "400",
                  type: "column2d",
                  renderAt: "chartContainer",
                  dataSource: chartJSONDataStr
    })

  end

end
