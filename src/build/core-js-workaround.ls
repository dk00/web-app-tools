import \core-js/modules/_shared : shared

lazy-load-fix-re-wks =
  delimiters: ['' '']
  "require('./_fix-re-wks')": "((require('./_wks') && require('./_redefine'))? (function(fixReWks) {
    (fixReWks.queue || []).forEach(a => fixReWks(a.KEY, a.length, a.exec));
    return fixReWks
  })(require('./_fix-re-wks')):
  function(KEY, length, exec) {
    require('./_fix-re-wks').queue = (require('./_fix-re-wks').queue || []).concat({KEY, length, exec})
  })"

hoist-functions =
  'var _fixReWks = function': 'function _fixReWks',
  'var _iterDetect = function': 'function _iterDetect'

export {lazy-load-fix-re-wks, hoist-functions}
