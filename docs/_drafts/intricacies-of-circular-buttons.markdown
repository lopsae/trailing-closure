---
layout: post
# date: 2026-05-28 14:30:00 -0700
title: "The Intricacies of Perfectly Circular Buttons"
categories: [SwiftUI]
tags: [swiftui, buttons]
permalink: /:year/:month/:day/:slug
toc: true
media_subpath: /assets/img/intricacies-of-circular-buttons/
description: >
  Since the release of the Glass appearance in Apple platforms, circular
  buttons have become commonplace toolbars. However, creating a
  circular button anywhere else is not entirely straighforward.
image:
  path: header@3x.png
---

Toolbar Buttons
---------------

Since iOS 26, buttons placed in the toolbars get automatically a circular glass and icon-only appearance. Outside of the toolbars, the platform APIs seem to provide all the pieces necessary to make similar circular buttons: a [`glass` button style](https://developer.apple.com/documentation/swiftui/primitivebuttonstyle/glass), the [`iconOnly` label style](https://developer.apple.com/documentation/swiftui/labelstyle/icononly), the [`circle` button border shape](https://developer.apple.com/documentation/swiftui/buttonbordershape/circle), and alternatively the [`glassEffect` modifier with a shape](https://developer.apple.com/documentation/swiftui/view/glasseffect(_:in:)). Upon using what seems the obvious combinations, the results are end up fairly different from a usable circular button:

```swift
HStack {
    let mountainsButton = Button("Mountains", systemImage: "mountain.2", action: {})

    mountainsButton
    .labelStyle(.iconOnly)
    .buttonBorderShape(.circle)
    .buttonStyle(.glass)

    mountainsButton
    .labelStyle(.iconOnly)
    .glassEffect(.regular.interactive(), in: .circle)
}
.font(.title)
```

{% include color-scheme-img.md
  alt="Example of button using label style, button border shape, and button style; and another button using glass effect."
  name="existing-modifiers"
%}

-----

Using some borders around the `Image` shows that the size of the shape used for both buttons depends on the size of the image itself, with the shape fitting inside the space occupied by the button. This works well for the `capsule` shape, the default for bordered buttons, but ends up too small for the `circle` shape:

```swift
HStack {
    let mountainsButton = Button(action: {}) {
        Label { Text("Mountains") }
        icon: {
            Image(systemName: "mountain.2")
            .border(.mint.secondary, width: 4) // Frame the symbol image.
        }
    }

    mountainsButton
    .labelStyle(.iconOnly)
    .buttonBorderShape(.capsule)
    .buttonStyle(.glass)
    .border(.pink) // Highlight frame.

    mountainsButton
    .labelStyle(.iconOnly)
    .buttonBorderShape(.circle)
    .buttonStyle(.glass)
    .border(.pink) // Highlight frame.

    mountainsButton
    .labelStyle(.iconOnly)
    .glassEffect(.regular.interactive(), in: .circle)
    .border(.pink) // Highlight frame.
}
.font(.title)
```

{% include color-scheme-img.md
  alt="Example of button using label style, button border shape, and button style; and another button using glass effect, both with a border around the symbol view."
  name="existing-modifiers-with-borders"
%}

-----

To properly use the `Circle` shape, the button needs to occupy the space of a square which gets filled by the shape. This modification could be done by framing the `Image` view through the `Button(_: label:)` constructor that receives a view for its label, however, for a more reusable approach this is a good case for making a specialized `ButtonStyle`:

> SNIPPETS: FramedButtonStyle

Note that to make this style work, the glass effect is applied direcly to the button. The `.buttonBorderShape` modifier stops working because the style is not making use of `ButtonBorderShape`, an issue that will be revisited later:

> SNIPPET: framed-button-style

This is starting to look better. The glass effect can also be applied within the button style so that all affected buttons use the same effect. This approach seems like it could be enough until the style is applied to symbols with more odd shapes:

> SNIPPET:

It might be hard to notice at first, but all the symbols with badges look slightly off. Aligning all buttons to `firstBaseline` and adding some overlays to draw the alignment guides can show that glass circle is being draw in sliglty different positions:

> SNIPPET:

This is one detail about buttons that I find particularly well done: All system symbols contain a text baseline alignment guide appropriate for the symbol, and buttons (and `Text` when presenting inline symbols) use it to align the symbol with the text.

> SNIPPET:

Part of the issue is that `FramedButtonStyle` is centering the button icon, but different symbols will have different sizes. Symbols with badges or odd shapes will end up with a size that when centered leave the main visual element of the symbol off center:

> SNIPPET:




---


SwiftUI API's provide a straightforward way of creating glass buttons with an image and a text. However, trying to create icon-only buttons showcases the way in which the Button view handles its size and shape: The button will take the size of its contents and apply it it a slight padding and a `Capsule` shape.  When creating an icon-only buttons, differen images results in differently sized buttons, which next to each other looks unbalanced, and definitely looks very different from the standard toolbard buttons.

While `Button` is definitely correct in handling the size of its content, it makes a more involved process to create buttons that resemble and play along the default style of Glass buttons in toolbars. This toolbar style is applied automatically when using SwiftUI toolbars, and is not accesible to apply to other buttons in any easy way, for example as a publicly available style.

The gist of the toolbar buttons is: an icon-only label, centered in a `Circle` shape (or `Capsule`, when joined to more that one button) with an interactive Glass effect. Sadly, applying directly a `glassEffect` modifier directly to a button tends to yield uneven results: the effect is applied to the button size, which by default may be only the size of the image, which means we have to modify the image provided to the buttons itself, a job well suited for a `ButtonStyle`.

One approach is to use a custom `ButtonStyle` to hide the label, properly size the button image, and apply the glass effect. The image is first `frame`d in a square that represents the desired minimal size for the icon (so that small icons dont result in smaller buttons, and larger icons overflow properly), and a second `frame` that provides the size of the button for the glass effect.

> How do this works when joining buttons into a shares shape effect?

One issue with this initial implementation is that we are hard-coding the size of both the expected image, and the size of the final button. The final size of the button is one that will have to remain as a magic number, as there is no way to retrieve the size of toolbars other that to measure them. Keep this in mind when implementing buttons that actually sit next to default toolbars, as the sizing may vary due to features like dynamic type size.

The size of the image itself is one we can handle! Measuring a _default_ system image could be an approach, but the setup would be complicated and involve a state heavily tied to view updates, which is frowned upon. Another approach is to use one of the interesting features of `overlay`: the overlaid content is aligned to the size of another view, virtually providing the equivalent of a `frame` based on the size of the owner view:

Treating the system image `circle` as a stand-in for the size of a default system image, we can use that size as the size for our button icon. This also has the added benefit that `font` modifiers that change the size of the font will seamlesly impact both the displayed button icon and the provided size through the hidden `circle` image.

One hidden complexity that results from this custom button style is the alignment of symbols that have decorations like badges around a main symbiol, two key examples are `envelope.shield` and `TODO`, which have bages that protude from the main symbol. When using these in a normal button we can see that system images use a `textBaseline` alignment to make sure that main symbol remains aligned to its text, despite the protuding badges.

If we use our custom button style with symbols using badges, we can see that the centering takes into account the whole size of the image, resulting in icons appearing slightly offset from each other.

Changing the alignement used by out custom style we can make the symbol size start aligned to the text baseline, and then centered to the button size, which results in a more balanced buttons (the button will be centered now on the main symbol component) and properly aligned symbols when displaying buttons next to each other.


An implementation of this functionality, along support for the toolbar sizes in iOS, is available in `PreviewUtilities 0.4.0`, as a combination of a custom Button initialized and a button style. Keep in mind that this implementation is likely to move to its own package in the future.


Colophon
----------

The code examples in this article use Swift X and are rendered using the iPhone 17 Pro simulator.


-----


## Colophon
{: .colophon}

<div class="colophon" markdown="block">

The code examples in this article where compiled using `Swift 6.2` through the `Apple Swift version 6.3.3` compiler.

Renderings using `iPhone 17 Pro Simulator` with `iOS 26.5`, through `Simulator 16.0`.

Some examples use [`PreviewUtilities 0.4.0`](https://github.com/lopsae/preview-utilities/releases/tag/v0.4.0).

</div>


{% include end-caption.md
  icon="fas fa-ruler-combined"
  text="TODO."
%}
