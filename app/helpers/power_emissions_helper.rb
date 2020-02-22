module PowerEmissionsHelper

  def line_data(query_data, label_title, data_title)

    { labels: query_data.reduce([]) {|labels, data_pt| labels << data_pt[label_title].to_s},
      datasets: [
        { label: "User Emissions",
          fill: false,
          borderColor: "rgba(43,101,247,1)",
          borderJoinStyle: "round",
          pointStyle: "line",
          data: query_data.reduce([]) {|data, data_pt| data << data_pt[data_title].to_s}
        }] }
  end

  def line_options
    {
      height: 300,
      legend: {display: false},
      scales:
        { yAxes: [{ scaleLabel: { display: true,
                    labelString: 'Emisssions kgCO2' }
                  }],
          xAxes: [{ scaleLabel: { display: true,
                    labelString: 'Time hours: minutes' },
                    gridLines: {display: false }
                  }]
        }
    }
  end

  def doughnut_data(query_data, label_title, data_title)

    { labels: query_data.reduce([]) {|labels, data_pt| labels << data_pt[label_title].to_s},
    datasets: [
      { label: "My First dataset",
        backgroundColor: ['red', 'green', 'blue', 'pink', 'purple', 'yellow'],
        data: query_data.reduce([]) {|data, data_pt| data << data_pt[data_title].to_s}
      }] }
  end

  def doughnut_options
    {}
  end

end
