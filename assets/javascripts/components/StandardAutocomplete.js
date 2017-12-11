"use strict";

import Textcomplete from "textcomplete/lib/textcomplete";
import Textarea from "textcomplete/lib/textarea";

export default function StandardAutocomplete() {
  console.log("-- StandardAutocomplete initialized");

  let $standard = $("#lessons_standards_standard_id");

  setAutocompleteSentences();
  $standard.on("change", setAutocompleteSentences);
}

function setAutocompleteSentences() {
  let $selctedStandard = $("#lessons_standards_standard_id option:selected");
  let autocompletes = $selctedStandard.data("autocomplete");

  if (autocompletes)
    window.autocompleteSentences = $selctedStandard.data("autocomplete");
  else window.autocompleteSentences = null;
}

export function register(textarea) {
  var editor = new Textarea(textarea);
  var textcomplete = new Textcomplete(editor);

  let sentenceStrategy = {
    id: "sentence",
    match: /(^|\s)([\sA-Za-z,;'"\\s]*)/,
    search: function(term, callback) {
      callback(
        autocompleteSentences.filter(function(sentence) {
          return sentence.toLowerCase().startsWith(term.toLowerCase());
        })
      );
    },
    template: function(sentence) {
      return sentence;
    },
    replace: function(sentence) {
      return sentence;
    }
  };

  textcomplete.register([sentenceStrategy]);
}
