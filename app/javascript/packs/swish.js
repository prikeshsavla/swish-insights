/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'


document.addEventListener('DOMContentLoaded', () => {
    var app = new Vue({

        el: '#app',

        data: {

            url: "http://prikeshsavla.com",
            relatedLinks: [],
            loadingResults: false,
            categories: ["performance"],
            result: ""

        },

        methods: {
            titleize(sentence) {
                if (!sentence.split) return sentence;
                var _titleizeWord = function (string) {
                        return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
                    },
                    result = [];
                sentence.split(" ").forEach(function (w) {
                    result.push(_titleizeWord(w));
                });
                return result.join(" ");
            },
            run() {
                this.loadingResults = true;
                const url = this.setUpQuery();
                console.log("Run: " + url);

                const that = this;
                fetch(url)
                    .then(response => response.json())
                    .then(json => {
                        // See https://developers.google.com/speed/docs/insights/v5/reference/pagespeedapi/runpagespeed#response
                        // to learn more about each of the properties in the response object.
                        that.showInitialContent(json.id);
                        const lighthouse = json.lighthouseResult;
                        that.result = JSON.stringify(lighthouse);
                        const lighthouseMetrics = {
                            "First Contentful Paint":
                            lighthouse.audits["first-contentful-paint"].displayValue,
                            "Speed Index": lighthouse.audits["speed-index"].displayValue,
                            "Time To Interactive": lighthouse.audits.interactive.displayValue,
                            "First Meaningful Paint":
                            lighthouse.audits["first-meaningful-paint"].displayValue,
                            "First CPU Idle": lighthouse.audits["first-cpu-idle"].displayValue,
                            "Estimated Input Latency":
                            lighthouse.audits["estimated-input-latency"].displayValue
                        };
                        that.showLighthouseContent(lighthouseMetrics);
                        $.ajaxSetup({
                            beforeSend: function (xhr) {
                                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                            },
                        });
                        $.ajax({
                            url: "/users/swish",
                            type: 'POST',

                            data: {
                                "swish": {
                                    url: that.url,
                                    data: lighthouseMetrics,
                                    categories: that.categories
                                }
                            },
                            success: console.log
                        });


                        that.loadingResults = false;
                    });
            },

            setUpQuery() {
                const api = "https://www.googleapis.com/pagespeedonline/v5/runPagespeed";
                const parameters = {
                    url: encodeURIComponent(this.url),
                    category: this.categories
                };
                let query = `${api}?key=AIzaSyDAnEMnj6igIF_WRqL5mgzumTKWgN_zojs`;
                for (const key in parameters) {
                    if (!!parameters[key]) {
                        if (Array.isArray(parameters[key])) {
                            parameters[key].forEach(element => {
                                query += `&${key}=${element}`;
                            });
                        } else {
                            query += `&${key}=${parameters[key]}`;
                        }
                    }
                }
                return query;
            },

            showInitialContent(id) {
                document.getElementById("result").innerHTML = "";
                const title = document.createElement("h1");
                title.textContent = "PageSpeed Insights API Demo";
                document.getElementById("result").appendChild(title);
                const page = document.createElement("p");
                page.textContent = `Page tested: ${id}`;
                document.getElementById("result").appendChild(page);
            },


            showLighthouseContent(lighthouseMetrics) {
                const lighthouseHeader = document.createElement("h2");
                lighthouseHeader.textContent = "Lighthouse Results";
                document.getElementById("result").appendChild(lighthouseHeader);
                for (const key in lighthouseMetrics) {
                    const p = document.createElement("p");
                    p.textContent = `${key}: ${lighthouseMetrics[key]}`;
                    document.getElementById("result").appendChild(p);
                }
            }
        }

    });

});
