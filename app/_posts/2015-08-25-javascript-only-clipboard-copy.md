---
layout: post
title:  "Javascript Only Clipboard Copy"
subtitle: "Jesus Christ finally."
categories: javascript clipboard
---

## A tiny bit of history
HTML and Javascript have never had a way to put data into the user's clipboard. In 2011 the W3C created a [Working Draft][2011] spec to enable it. Fast forward to 2015 and some basic functionality is finally making it's way into browsers though the [Clipboard API and events][current] spec is still a working draft.

Until now the only half decent way of getting at a user's clipboard on a webpage has been to use a little [flash plugin][clippy]. (Almost) Gone are the days of having to rely on a bulky plugin to handle such a simple task. Let's move on.

## A tiny little script
The current implementation uses [document.execCommand][execCommand] which is a carry over from [Design Mode][designMode]. Some browsers have had this functionality for a while but the entire document had to be in design mode for it to work. The W3C has included this functionality in the spec and it is currently the only widely supported method if interacting with the clipboard.

**Caveats:**

 - All clipboard manipulations must be preformed inside a user generated event like a mouse click.
 - All clipboard manipulations must be preformed on actual selections, either user or programmatically set.

**Copy Text from an Existing Input or Textarea**:
{% highlight javascript %}
// Copy all text from an existing input
function copyTextFromInput(element){
  element.select(); // Makes a user selection over the entire input
  document.execCommand('copy')
}

// Copy just the user selection
function copyUserSelectionFromInput(element){
  element.focus(); // We simply need to re-focus the element
  document.execCommand('copy');
}
{% endhighlight %}

**Copy Arbitrary Text**
{% highlight javascript %}
// Copy arbitrary text by placing it in a textarea, and copying it;
function copyText(text){
  // Create a textarea for the text to reside
  var ta = document.createElement('textarea');
  // Hide it from display
  ta.style.position = "fixed";
  ta.style.top = ta.style.left = 0;
  ta.style.opacity = 0;
  // Set the text
  ta.value = text;
  // Add it to the document
  document.body.appendChild(ta);
  // Make a user selection on it's contents
  ta.select();
  // Preform the copy
  document.execCommand('copy');
  // Remove the element
  ta.remove();
}
{% endhighlight %}

### Bonus: Cut
These should all also work for "cut" though cutting arbitrary text doesn't make much sense.

### Bonus 2: Paste
In order to get paste to work it should be as simple as:
{% highlight javascript %}
function pasteClipboardToElement(element){
  element.focus();
  document.execCommand('paste');
}
{% endhighlight %}

Though support is non-existent.

### Working Demo
http://output.jsbin.com/muhiqu/?output

## Testing for functionality
According to the spec and, luckily, how it's implemented in browsers is that if `document.execCommand("command")` returns `true` then the functionality for `"command"` must be implemented. Unfortunately, in Firefox this throws an error if called at certain times. So to check if a browser supports the `"copy"` command, or any other command for that matter, you just need to run:
{% highlight javascript %}
// This checks if javascript clipboard copy is supported
function supportsCommand(command){
  try{
    return document.execCommand(command) === true;
  } catch (er){
    return false;
  }
}
{% endhighlight %}

## Browser Support
For a current and detailed breakdown check [Can I Use][ciu].
Modern Chrome, Opera, and IE are all supported. We get Firefox support with version 41 coming out next month. As of mid September 2015, every major browser will support Javascript only clipboard copy except desktop and mobile safari. Thus further commiting Safari as [becoming the new IE][newie].

<!-- Refs -->
[2011]: http://www.w3.org/TR/2011/WD-clipboard-apis-20110412/
[current]: http://www.w3.org/TR/clipboard-apis/
[clippy]: https://github.com/mojombo/clippy
[ciu]: http://caniuse.com/#feat=clipboard
[designMode]: https://developer.mozilla.org/en-US/docs/Web/API/Document/designMode
[execCommand]: https://developer.mozilla.org/en-US/docs/Web/API/document/execCommand
[newie]: http://nolanlawson.com/2015/06/30/safari-is-the-new-ie/
