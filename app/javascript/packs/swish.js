/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'

// document.addEventListener('DOMContentLoaded', () => {
//     startVueForm()
//
// });
document.addEventListener('turbolinks:load', () => {
    startVueForm()

});

function startVueForm() {
    if (document.getElementById('app')) {
        new Vue({
            el: '#app',
            data: {

                url: "http://prikeshsavla.com",
                relatedLinks: [],
                loadingResults: false,
                categories: ["accessibility",
                    "best-practices",
                    "performance",
                    "pwa",
                    "seo"],
                result: null,
                lighthouseMetrics: []
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

                            that.result = that.syntaxHighlight(JSON.stringify(lighthouse, undefined, 2));

                            const lighthouseMetrics = {
                                "Performance": lighthouse.categories["performance"] ? lighthouse.categories["performance"].score : null
                                ,
                                "Accessibility": lighthouse.categories["accessibility"] ? lighthouse.categories["accessibility"].score : null
                                ,
                                "Best-Practices": lighthouse.categories["best-practices"] ? lighthouse.categories["best-practices"].score : null
                                ,
                                "PWA": lighthouse.categories["pwa"] ? lighthouse.categories["pwa"].score : null
                                ,
                                "SEO": lighthouse.categories["seo"] ? lighthouse.categories["seo"].score : null
                                ,
                                "First Contentful Paint": lighthouse.audits["first-contentful-paint"].displayValue
                                ,
                                "Speed Index": lighthouse.audits["speed-index"].displayValue
                                ,
                                "Time To Interactive": lighthouse.audits.interactive.displayValue
                                ,
                                "First Meaningful Paint": lighthouse.audits["first-meaningful-paint"].displayValue
                                ,
                                "First CPU Idle": lighthouse.audits["first-cpu-idle"].displayValue
                                ,
                                "Estimated Input Latency": lighthouse.audits["estimated-input-latency"].displayValue
                            };
                            that.lighthouseMetrics = lighthouseMetrics;

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
                                        report: JSON.stringify(lighthouse),
                                        categories: that.categories
                                    }
                                },
                                success: (data) => {
                                    console.log(data);
                                    that.loadingResults = false;
                                },
                                error: (data) => {
                                    console.log(data);
                                    that.loadingResults = false;
                                }
                            });
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
                    const page = document.createElement("p");
                    page.textContent = `Page tested: ${id}`;
                    document.getElementById("result").appendChild(page);
                },
                syntaxHighlight(json) {
                    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
                        var cls = 'number';
                        if (/^"/.test(match)) {
                            if (/:$/.test(match)) {
                                cls = 'key';
                            } else {
                                cls = 'string';
                            }
                        } else if (/true|false/.test(match)) {
                            cls = 'boolean';
                        } else if (/null/.test(match)) {
                            cls = 'null';
                        }
                        return '<span class="' + cls + '">' + match + '</span>';
                    });
                }
            }

        });
    }
}