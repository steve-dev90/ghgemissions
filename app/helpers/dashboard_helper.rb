module DashboardHelper
  def bar_data(query_data, label_title, data_title)
    { labels: query_data.reduce([]) {|labels, data_pt| labels << data_pt[label_title].to_s},
      datasets: [
        { label: "User Emissions",
          barPercentage: 0.5,
          barThickness: 6,
          maxBarThickness: 8,
          minBarLength: 2,
          data: query_data.reduce([]) {|data, data_pt| data << data_pt[data_title].to_s}
        }] }
  end

  def bar_options
    {
      height: 200,
      legend: {display: false},
      scales: {
        xAxes: [{ scaleLabel: { display: true,
                                labelString: 'Emisssions Source' },
                  gridLines: { offsetGridLines: true }
                }],
        yAxes: [{ scaleLabel: { display: true,
                                labelString: 'Emisssions kgCO2' }
                }],
      }
    }
  end
end
