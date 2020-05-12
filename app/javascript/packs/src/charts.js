import {Chart} from "frappe-charts/dist/frappe-charts.min.esm"

const charts = {
    init() {
        charts.heatMap();
    },
    heatMap() {
        const heatMapSelector = '[data-chart=heatmap]';
        if ($(heatMapSelector).length) {


            $(heatMapSelector).each(function (index, element) {
                const id = $(element).attr('id');

                const datapoints = $(element).data('datapoints');
                const startDate = new Date($(element).data('startAt'));
                const endDate = new Date($(element).data('endAt'));
                const data = {
                    dataPoints: datapoints,
                    start: startDate, // a JS date object
                    end: endDate
                };
                console.log($(element).data('startAt'));
                let chart = new Chart('#' + id, {
                    type: 'heatmap',
                    data: data,
                    discreteDomains: 0,
                    colors: ['#FFE7F3', '#FF70B6', '#FF007D', '#B40058', '#8A0044'],
                });

            });


        }
    }
};

export default charts;