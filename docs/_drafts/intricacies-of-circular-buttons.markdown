---
layout: post
# date: 2026-05-28 14:30:00 -0700
title: "The Intricacies of Perfectly Circular Buttons"
categories: [SwiftUI]
tags: [swiftui, buttons, overlay, alignments]
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


Aligning by Baseline
--------------------

Back the the circular buttons: an interesting issue here is how to align a symbol to a baseline if there is not text to provide said alignment. Buttons with the default styles do not deal with this because the button just takes the size of the symbol, which is the reason the default styles do not work well for circular buttons:

```swift
HStack(alignment: .firstTextBaseline) {
    Button("Horizontal", systemImage: "guidepoint.horizontal", action: {})
    .labelStyle(.iconOnly)
    .buttonStyle(.glass)

    Button("Vertical", systemImage: "guidepoint.vertical", action: {})
    .labelStyle(.iconOnly)
    .buttonStyle(.glass)

    Button("Rainbow", systemImage: "rainbow", action: {})
    .labelStyle(.iconOnly)
    .buttonStyle(.glass)

    Button("Bolt", systemImage: "bolt", action: {})
    .labelStyle(.iconOnly)
    .buttonStyle(.glass)
}
.font(.title)
```

{% include color-scheme-img.md
  alt="Four symbols: a horizontal bar, a vertical bar, a rainbow, and a bolt, each as a glass button of different size."
  name="default-button-sizing"
%}

-----


What is needed is a view that can be considered to have already a balanced size and provides a baseline alignment. Since symbols do provide a baseline alignment and the focus is circular buttons, one symbol might fit perfectly: `circle`! This placeholder symbol can be first centered in the circular button, and then the actual symbol aligned to it.

Enter the wonderful `overlay` modifier, with which the circle provides the layout frame and alignment guide for the overlaid button symbol:

```swift
HStack(alignment: .firstTextBaseline, spacing: 20) {
    Image(systemName: "circle")
        .foregroundStyle(.blue)
    .overlay(alignment: .centerFirstTextBaseline) {
        Image(systemName: "hourglass.badge.plus")
        .border(.green.secondary)
    }
    .border(.blue.secondary, width: 2)

    Image(systemName: "circle")
    .border(.blue.secondary, width: 2) // Blue size frame is the same for all symbols!
    .drawAlignmentGuide(.firstTextBaseline, length: 200)

    Image(systemName: "circle")
    .foregroundStyle(.blue)
    .overlay(alignment: .centerFirstTextBaseline) {
        Image(systemName: "car.badge.gearshape")
        .border(.green.secondary)
    }
    .border(.blue.secondary, width: 2)
}
.font(.title)
```

Even if each symbol has different size (in green), the size used for layout is that of the `circle` symbol (in blue):

{% include color-scheme-img.md
  alt="A hourglass and a car symbol overlaid a circle symbol, the size of the circle symbols outlined in blue, and the size of the other symbols outlined in green."
  name="aligning-onto-circle"
%}

-----


Baseline Button Style
---------------------





---


Colophon
----------

The code examples in this article use Swift X and are rendered using the iPhone 17 Pro simulator.


-----


## Colophon
{: .colophon}

<div class="colophon" markdown="block">

The code examples in this article where compiled using `Swift 6.2`.

Renderings using `iPhone 17 Pro Simulator` with `iOS 26.5`.

</div>

{% include end-caption.md
  icon="fas fa-shapes"
  text="In support of buttons of all shapes and sizes."
%}
