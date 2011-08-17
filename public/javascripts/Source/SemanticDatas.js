/*
---
description: Basic script
 
license: Public domain (http://unlicense.org).

authors: 

requires:
  - Core/Element.Dimensions
provides:
  - SemanticDatas

...
*/


var log = function () {
  if (Browser.opera) { return; }
  try {
    console.log.apply(console, arguments);
  } catch (e) { };
};

var SemanticDatas = {};

function detectBaseline () {
  var a = new Element('div', {'text': "aaaa", styles: {
    position: 'absolute',
    top: 0
  }}).inject(document.body, 'bottom');
  
  baseline = a.getSize().y;
  a.destroy();
  return baseline;
}

function grid (forcedBaseline) {
  if ($$('body > .grid')[0]) {
    $$('body > .grid').destroy();
    return;
  }
  
  var baseline = forcedBaseline || detectBaseline();
  
  var windowHeight = window.getScrollSize().y;
  
  var gridBox = new Element('div', {'class': 'grid',
    styles: {
      position: 'absolute',
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  }).inject(document.body);
  
  for(var i = 0; i < windowHeight / baseline; i++) {
    new Element('div', {
      styles: {
        height: baseline - 1,
        'border-bottom': '1px solid #999',
        width: '100%'
      }
    }).inject(gridBox);
  }
}