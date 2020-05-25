module DashboardHelper
  def bar_data(query_data, label_title, data_title)
    { labels: query_data.reduce([]) {|labels, data_pt| labels << data_pt[label_title].to_s},
      datasets: [
        { label: "User Emissions",
          barPercentage: 0.5,
          barThickness: 6,
          maxBarThickness: 8,
          minBarLength: 2,
          data: query_data.reduce([]) {|data, data_pt| data << data_pt[data_title].to_s},
          backgroundColor: [ 'hsl(37, 90%, 51%)', 'hsl(204, 70%, 81%)']
        }] }
  end

  def bar_options
    {
      height: 200,
      legend: {display: false},
      scales: {
        yAxes: [{ scaleLabel: { display: true,
                                labelString: 'Emisssions Source' },
                  gridLines: { offsetGridLines: true }
                }],
        xAxes: [{ scaleLabel: { display: true,
                                labelString: 'Emisssions kgCO2' }
                }],
      }
    }
  end
end
