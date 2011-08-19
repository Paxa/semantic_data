/*
---
description: Basic script
 
license: Public domain (http://unlicense.org).

authors: 

requires:
  - SemanticDatas.Widget
  - Core/Requrest.HTML
  - More/Element.Shortcuts
  - Ext/Element.from
  
provides:
  - SemanticDatas.Widget.Loader

...
*/


Elements.from = function(html) {
  return new Elements(innerShiv(html).childNodes);
};

LSD.States.loaded = {enabler: 'load', disabler: 'reset',    reflect: true};

SemanticDatas.Widget.Loader = new Class({
  options: {
    states: Array.object('loaded')
  },
  
  build: Macro.onion(function() {
    this.getContent();
  }),
  
  getContent: function() {
    var url = this.element.get('data-url');
    new Request.HTML({url: url, onSuccess: this.appendContent.bind(this)}).GET();
  },
  
  appendContent: function(children, tree, html) {
    this.element.adopt(Elements.from(html));
    this.load();
  },

  reset: function() {
    this.element.getChildren().destroy();
  }
});
