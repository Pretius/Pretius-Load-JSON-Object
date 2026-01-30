var pretiusLoadJSONObject = (function () {

    function render(pThis) {
        var da = pThis;
        var lJsLiteralWithWindow = da.action.attribute06;
        var lRemoveObject = da.action.attribute07;
        var lpageItemsToSubmit = da.action.attribute08;
        var lJavaScriptCode = da.action.attribute09;
        var lshowSpinner = da.action.attribute10;

        var lpageItemsToSubmitArray = apex.util.toArray(lpageItemsToSubmit, ",");

        lpageItemsToSubmit = lpageItemsToSubmitArray
            .map(item => "#" + item.trim().toUpperCase())
            .join(",");

        var spinner;

        if (lshowSpinner == 'Y') spinner = apex.util.showSpinner(da.triggeringElement); 

        apex.server.plugin(
            da.action.ajaxIdentifier,
            {
                pageItems: lpageItemsToSubmit
            },
            {
                dataType: "json", // Expecting JSON
                success: function (pData) {

                    // https://stackoverflow.com/a/18082175
                    function evil(fn, context) {
                        var func = new Function('return ' + fn)();
                        return func.call(context);
                    }

                    var createNestedObject = function (e, t) { for (var r = (t = t.split(".")).length - 1, a = 0; a < r; ++a) { var n = t[a]; n in e || (e[n] = {}), e = e[n] } };

                    createNestedObject(window, lJsLiteralWithWindow);

                    // 1. Parse the string to get the parent object and the final property name
                    var parts = lJsLiteralWithWindow.split('.');
                    var propName = parts.pop(); // Extracts final tag
                    // traverse from top level down to the parent of the final property
                    var parent = parts.reduce(function (acc, part) {
                        return acc[part];
                    }, window);

                    // 2. Replace or merge based on lRemoveObject
                    try {
                        if (lRemoveObject === 'Y') {
                            parent[propName] = pData;
                        } else {
                            // Dynamic equivalent of: window.appdata = window.appdata || {};
                            parent[propName] = parent[propName] || {};
                            // Dynamic equivalent of: Object.assign(window.appdata, {"a": 2});
                            Object.assign(parent[propName], pData);
                        }
                    } catch (e) {
                        if (spinner) spinner.remove();
                        console.error("Unknown Error for " + lJsLiteralWithWindow, e);
                        if (da.action.waitForResult) {
                            // pass true to Stop Execution on Error
                            apex.da.resume(da.resumeCallback, true);
                        }
                        return;
                    }

                    // Remove Spinner
                    if (spinner) spinner.remove();

                    // 5. Execute JS Code
                    if (lJavaScriptCode) {
                        try {
                            evil('(function () {\n' + lJavaScriptCode + '\n})', da);
                        } catch (e) {
                            console.error("Evil execution error:", e);
                        }
                    }

                    // Resume Dynamic Actions
                    if (da.action.waitForResult) {
                        apex.da.resume(da.resumeCallback, false);
                    }

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    if (spinner) spinner.remove();
                    console.error("JSON Load Error for variable: " + lJsLiteralWithWindow, textStatus, errorThrown);
                    if (da.action.waitForResult) {
                        // pass true to Stop Execution on Error
                        apex.da.resume(da.resumeCallback, true);
                    }
                }
            }
        );
    }

    // Public API
    return {
        render: render
    };

})();