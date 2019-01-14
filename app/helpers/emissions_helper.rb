module EmissionsHelper
  # Refactoring required

  def get_user_emissions_chart(chartDataObj)
    # Chart appearance configuration
    chartAppearancesConfigObj = Hash.new
    chartAppearancesConfigObj = {
                               "caption" => "User Emissions By Trading Period",
                               "xAxisName" => "Trading Period",
                               "yAxisName" => "Emissions (kgCO2)",
                               "paletteColors": "#81BB76",
                               "theme" => "fusion",
                               "showValues" => "0"
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

  def get_trader_emissions_chart(chartDataObj)
    # Chart appearance configuration
    chartAppearancesConfigObj = Hash.new
    chartAppearancesConfigObj = {
                  "caption": "Emissions by Trader",
                  "theme": "hulk-light",
                  "showLabels": "0",
                  "showValues": "0",
                  "showLegend": "1",
                  "legendPosition": "RIGHT",
                  "legendBorderAlpha": "60",
                  "legendBorderThickness": "0.7",
                  "legendShadow": "0",
                  "legendBorderColor": "#262626",
                  "legendBorderAlpha": "20",
                  "defaultCenterLabel": "Android Distribution",
                  "centerLabelFontSize": "10",
                  "showToolTip": "1",
                  "alignCaptionWithCanvas": "0",
                  "captionPadding": "0",
                  "plottooltext": "<div id='nameDiv'> <b>$label</b><br/><b>Runs on : </b>$percentValue Of devices<br/></div>",
                  "centerLabel": "$label: $value",
    }

    # Chart data template to store data in "Label" & "Value" format
    labelValueTemplate = "{ \"label\": \"%s\", \"value\": \"%s\" },"

    # Chart data as JSON string
    labelValueJSONStr = ""

    chartDataObj.each {|item|
        data = labelValueTemplate % [item[:trader].to_s, item[:emissions_factor].to_s]
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
                  type: "doughnut2d",
                  renderAt: "piechartContainer",
                  dataSource: chartJSONDataStr
    })

  end

end
