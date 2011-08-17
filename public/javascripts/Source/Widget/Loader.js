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

SemanticDatas.Widget.Loader = new Class({
  options: {
    states: {
      loaded: {enabler: 'setLoaded',     disabler: 'reset',    reflect: true},
    }
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
    this.setLoaded();
  },
  
  setLoaded: function () {
    this.element.getElement('.loading').hide();
  },
  
  reset: function () {
    this.element.getChildren().each(function(child) {
      if (child.className.indexOf('loading') == -1) {
        child.destroy();
      }
    })
    this.element.getElement('.loading').show();
  },
});
