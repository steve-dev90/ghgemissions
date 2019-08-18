module PowerEmissionsHelper
  def chart_data(query_data, label, data_name, background_color)
    labels = []
    data = []
    query_data.each do |data_item|
      labels << data_item[label].to_s
      data << data_item[data_name]
    end

    { labels: labels,
      datasets: [
        { label: "My First dataset",
          backgroundColor: background_color,
          borderColor: "rgba(220,220,220,1)",
          data: data
        }] }
  end

  def user_emissions_options
    {
      scales:
        { yAxes: [{ scaleLabel: { display: true,
                    labelString: 'Emisssions kgCO2' }
                  }],
          xAxes: [{ scaleLabel: { display: true,
                    labelString: 'Time hours: minutes' }
                  }]
        }
    }
  end
end
