---
layout: post
# date: 2026-05-28 14:30:00 -0700
title: "The Intricacies of Perfectly Circular Buttons"
categories: [SwiftUI]
tags: [swiftui, buttons]
permalink: /:year/:slug
toc: true
media_subpath: /assets/img/intricacies-of-circular-buttons/
description: >
  Since the release of the Glass appearance in Apple platforms, circular
  buttons have become commonplace toolbars. However, creating a
  circular button anywhere else is not entirely straighforward.
image:
  path: header@3x.png
---

Framing Buttons
---------------

Since iOS 26, buttons placed in the toolbars get automatically a circular glass and icon-only appearance. Outside of the toolbars, the platform APIs seem to provide all the pieces necessary to make similar circular buttons: a [`glass` button style](https://developer.apple.com/documentation/swiftui/primitivebuttonstyle/glass), the [`iconOnly` label style](https://developer.apple.com/documentation/swiftui/labelstyle/icononly), the [`circle` button border shape](https://developer.apple.com/documentation/swiftui/buttonbordershape/circle), and alternatively the [`glassEffect` modifier with a shape](https://developer.apple.com/documentation/swiftui/view/glasseffect(_:in:)). Upon using what seems the obvious combinations, the results end up far from a usable circular button:

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
            .border(.mint.secondary, width: 4) // Outline symbol frame.
        }
    }

    mountainsButton
    .labelStyle(.iconOnly)
    .buttonBorderShape(.capsule)
    .buttonStyle(.glass)
    .border(.pink) // Outline button frame.

    mountainsButton
    .labelStyle(.iconOnly)
    .buttonBorderShape(.circle)
    .buttonStyle(.glass)
    .border(.pink) // Outline button frame.

    mountainsButton
    .labelStyle(.iconOnly)
    .glassEffect(.regular.interactive(), in: .circle)
    .border(.pink) // Outline button frame.
}
.font(.title)
```

{% include color-scheme-img.md
  alt="Example of button using label style, button border shape, and button style; and another button using glass effect, both with a border around the symbol view."
  name="existing-modifiers-with-borders"
%}

-----


To properly use the `circle` shape, the button size needs to be a square, which is then fully filled by the circle. One approach could be to frame the `Image` view through the [`Button(action:label:)` constructor](https://developer.apple.com/documentation/swiftui/button/init(action:label:)) as in the example above. However, for a more reusable approach this is a good case for making a [`ButtonStyle`](https://developer.apple.com/documentation/swiftui/buttonstyle) that sets up the button with the desired configuration in a single go:

```swift
struct FramedButtonStyle: ButtonStyle {
    let length: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .labelStyle(.iconOnly)
        .frame(width: length, height: length)
    }
}
```

Note that to make this style work, the glass effect is applied direcly to the button. The `buttonBorderShape` modifier stops working because the style is not making use of `ButtonBorderShape` (an issue that will be revisited later) but the button still takes up a square that is properly filled by the glass circle:

```swift
HStack {
    Button("Leaf", systemImage: "leaf", action: {})
    .buttonStyle(FramedButtonStyle(length: 60))
    .buttonBorderShape(.circle)  // Does not work with this style!
    .border(.pink) // But the button frame is still a square.

    Button("Leaf", systemImage: "leaf", action: {})
    .buttonStyle(FramedButtonStyle(length: 60))
    .glassEffect(.regular.interactive(), in: .circle)
}
.font(.title)
```

{% include color-scheme-img.md
  alt="Two buttons using a custom style, the first one with no border shape, the second with a glass circle shape around it."
  name="framed-button-style"
%}

-----


This is starting to look better! The glass effect can also be applied within the button style so that all affected buttons use the same effect. This approach seems like it could be enough until the style is applied to symbols with more odd shapes:

```swift
struct GlassFramedButtonStyle: ButtonStyle {
    let length: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .labelStyle(.iconOnly)
        .frame(width: length, height: length)
        .glassEffect(.regular.interactive(), in: .circle)
    }
}
```

```swift
HStack {
    Button("Envelope",  systemImage: "envelope.badge.shield.half.filled", action: {})
    Button("Hourglass", systemImage: "hourglass.badge.plus", action: {})
    Button("Fish",      systemImage: "fish", action: {})
    Button("Car",       systemImage: "car.badge.gearshape", action: {})
    Button("Lock",      systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
}
.buttonStyle(GlassFramedButtonStyle(length: 60))
.font(.title)
```

{% include color-scheme-img.md
  alt="Four buttons with a custom style that applies a glass circle shape around each button."
  name="glass-framed-button-style"
%}

-----


To help visualize the following examples, lets define a handy `View` extension function to draw an specific alignment guide:

```swift
private extension View {
    func drawAlignmentGuide(_ verticalAlignment: VerticalAlignment, length: CGFloat? = nil) -> some View {
        let alignment = Alignment(horizontal: .center, vertical: verticalAlignment)
        return self.overlay(alignment: alignment) {
            Rectangle()
            .fill(.red.secondary)
            .frame(width: length, height: 2)
        }
    }
}
```


Back to the circle buttons, upon close inspection note that all the symbols with badges look slightly off-center vertically. Aligning all buttons to `firstBaseline` (and drawing the alignment guides) can show that the glass circles are drawn in sliglty different positions:

```swift
HStack(alignment: .firstTextBaseline) {
    Button("Envelope",  systemImage: "envelope.badge.shield.half.filled", action: {})
    Button("Hourglass", systemImage: "hourglass.badge.plus", action: {})

    Button("Fish", systemImage: "fish", action: {})
    .drawAlignmentGuide(.top, length: 360)
    .drawAlignmentGuide(.firstTextBaseline, length: 360)
    .drawAlignmentGuide(.bottom, length: 360)

    Button("Car",  systemImage: "car.badge.gearshape", action: {})
    Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
}
.buttonStyle(GlassFramedButtonStyle(length: 60))
.font(.title)
```

{% include color-scheme-img.md
  alt="Four buttons with a custom style that applies a glass circle shape around each button, and overlaid with horizontal lines to show the top, baseline, and bottom alignment guides."
  name="glass-framed-button-style-aligned"
%}

-----


A Diversion: Inline Symbol Alignment
------------------------------------

A detail about symbols and buttons that I find particularly well done: All system and custom symbols are defined around guidelines for the baseline and cap height of each font weigth:

![Example of the shell symbol in a grid of different font sizes and weights.](fossil-shell-export-example@2x.png){: width="600" }
_Part of the export file for the `fossil.shell` symbol._

This information is used to determine the symbol size and position relative to surrounding text (and the font and image scale settings currently applied to the symbol view). When symbols are displayed along text, for example inline in `Text` or in buttons, their baseline alignment comes into play:

```swift
VStack {
    let envelope  = Image(systemName: "envelope.badge.shield.half.filled")
    let hourglass = Image(systemName: "hourglass.badge.plus")
    let shell     = Image(systemName: "fossil.shell")
    let car       = Image(systemName: "car.badge.gearshape")
    let lock      = Image(systemName: "lock.open.trianglebadge.exclamationmark.fill")
    Text("Regular \(envelope) \(hourglass) \(shell) \(car) \(lock) symbols")
    .drawAlignmentGuide(.firstTextBaseline)

    Text("Large \(envelope) \(hourglass) \(shell) \(car) \(lock) symbols")
    .imageScale(.large)
    .drawAlignmentGuide(.firstTextBaseline)

    HStack(alignment: .firstTextBaseline) {
        Button("Car", systemImage: "car.badge.gearshape", action: {})
        Button("Envelope", systemImage: "envelope.badge.shield.half.filled", action: {})
            .drawAlignmentGuide(.firstTextBaseline, length: 300)
        Button("Lock", systemImage: "lock.open.trianglebadge.exclamationmark.fill", action: {})
    }
}
.font(.title3)
```

{% include color-scheme-img.md
  alt="A text with five symbols displayned inline with regular scale, another text with five symbols displayed inline with large scale, and three buttons with their respective symbols: car, envelope, and lock."
  name="symbols-inline-alignment"
%}

-----


This means that symbols are expected to be aligned not by the raw size of their image (which sometimes may even leave part of the symbol outside in order to keep the symbol horizontally centered) but instead by their text baseline:

```swift
HStack(alignment: .firstTextBaseline) {
    Image(systemName: "envelope.badge.shield.half.filled")
        .border(.green.secondary, width: 2)
    Image(systemName: "hourglass.badge.plus")
        .border(.green.secondary, width: 2)
    Image(systemName: "fossil.shell")
        .drawAlignmentGuide(.firstTextBaseline, length: 300)
        .border(.green.secondary, width: 2)
    Image(systemName: "car.badge.gearshape")
        .border(.green.secondary, width: 2)
    Image(systemName: "lock.open.trianglebadge.exclamationmark.fill")
        .border(.green.secondary, width: 2)
}
.font(.title)
```

{% include color-scheme-img.md
  alt="Five symbols aligned by their text baseline and displaying their frame: an envelope, and hourglass, a shell, a car, and a lock."
  name="framed-symbols-with-baselines"
%}

-----


Centering by Baseline
---------------------

Back to the circular buttons: Given that these buttons are not displaying next to any text, from which the baseline alignment could be derived, how can the button figure out where is the appropiate baseline is?

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
