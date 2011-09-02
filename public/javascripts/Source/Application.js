/*
---
description: The file the requires dependencies. To be required, of course.

license: MIT-style

authors: 

requires:
  - LSD/LSD.Widget
  - LSD/LSD.Action.Submit
  - LSD/LSD.Mixin.Request
  - LSD/LSD.Document
  - Widgets/LSD.Widget.Body
  - Native/LSD.Native.Input
  - LSD/LSD.Mixin.Placeholder

provides: [Application]
...
*/

$$('[data-load-script]').each(function(element) {
  new Element('script', {src: element.get('data-load-script')}).inject(document.body);
});

LSD.Mixin.Placeholder;

LSD.Element.pool.push(LSD.Widget);

SemanticDatas.Application = new LSD.Document({
  mutations: {
    'section.item_loader': 'loader',
    'form.rss_form': 'RssForm'
  }
});