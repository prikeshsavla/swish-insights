/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import Typed from "typed.js/src/typed";

// document.addEventListener('DOMContentLoaded', () => {
//     startVueForm()
//
// });
document.addEventListener('turbolinks:load', () => {
    startVueForm();


});

function startVueForm() {
    if (document.getElementById('app')) {
        new Vue({
            el: '#app',
            data: {

                url: "",
                relatedLinks: [],
                errorMessage: "",
                loadingResults: false,
                categories: ["accessibility",
                    "best-practices",
                    "performance",
                    "pwa",
                    "seo"],
                result: null,
                typed: null,
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
                isValidUrl(str) {
                    const regexp = /^(?:(?:https?|ftp):\/\/)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/\S*)?$/;
                    return regexp.test(str);
                },
                run() {
                    this.loadingResults = true;
                    this.result = null;
                    this.lighthouseMetrics = [];
                    this.showHints();
                    if (!this.isValidUrl(this.url)) {
                        this.loadingResults = false;
                        this.errorMessage = "Please enter a valid URL";
                        return false;
                    }
                    this.errorMessage = "";
                    const queryUrl = this.url.replace(/\/$/, "");
                    const url = this.setUpQuery(queryUrl);

                    const that = this;
                    fetch(url)
                        .then(response => response.json())
                        .then(json => {
                            // See https://developers.google.com/speed/docs/insights/v5/reference/pagespeedapi/runpagespeed#response
                            // to learn more about each of the properties in the response object.
                            that.showInitialContent(json.id);
                            const lighthouse = json.lighthouseResult;


                            const lighthouseMetrics = {
                                "Performance": lighthouse.categories["performance"] ? lighthouse.categories["performance"].score * 100 : null
                                ,
                                "Accessibility": lighthouse.categories["accessibility"] ? lighthouse.categories["accessibility"].score * 100 : null
                                ,
                                "Best-Practices": lighthouse.categories["best-practices"] ? lighthouse.categories["best-practices"].score * 100 : null
                                ,
                                "PWA": lighthouse.categories["pwa"] ? lighthouse.categories["pwa"].score * 100 : null
                                ,
                                "SEO": lighthouse.categories["seo"] ? lighthouse.categories["seo"].score * 100 : null
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
                                        url: queryUrl,
                                        data: lighthouseMetrics,
                                        report: JSON.stringify(lighthouse),
                                        categories: that.categories
                                    }
                                },
                                success: (data) => {
                                    console.log(data);
                                },
                                error: (data) => {
                                    console.log(data);
                                },
                                complete: () => {
                                    that.loadingResults = false;
                                    that.lighthouseMetrics = lighthouseMetrics;
                                    that.result = that.syntaxHighlight(JSON.stringify(lighthouse, undefined, 2));
                                }
                            });
                        });
                },

                setUpQuery(queryUrl) {
                    const api = "https://www.googleapis.com/pagespeedonline/v5/runPagespeed";

                    const parameters = {
                        url: encodeURIComponent(queryUrl),
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
                    page.innerHTML = `Page tested: <a href="${id}" target="_blank"><i class="fas fa-external-link-alt" aria-hidden="true"></i> ${id}</a>`;
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
                },

                showHints() {
                    if (this.typed !== null) {
                        this.typed.destroy();
                    }
                    this.typed = new Typed('.explain', {
                        strings: [
                            `<strong> Performance</strong>:
                    Lighthouse returns a Performance score between 0 and 100. 0 is the lowest possible score.
                    100 is the best possible score which represents the 98th percentile, a top-performing site.
                    A score of 50 represents the 75th percentile.`,
                            `<strong>PWA</strong>: The PWA audits are based on the <a href="https://web.dev/pwa-checklist/#baseline">Baseline PWA Checklist</a>,
which lists 14 requirements. Lighthouse has automated audits for 11 of the 14 requirements. `,
                            `<strong>Accessibility</strong>: The Accessibility score is a weighted average of all the accessibility audits. See <a href="https://docs.google.com/spreadsheets/d/1Cxzhy5ecqJCucdf1M0iOzM8mIxNc7mmx107o5nj38Eo/edit#gid=0" class="external">Scoring
Details</a> for a full list of how each audit is weighted. The heavier-weighted
audits have a bigger impact on your score.`
                        ],
                        typeSpeed: 40,
                        shuffle: true,
                        loop: true,
                    })
                    ;
                }

            }

        })
        ;
    }
}