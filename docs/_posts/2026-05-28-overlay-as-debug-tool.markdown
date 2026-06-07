---
layout: post
date: 2026-05-28 14:30:00 -0700
title: "Overlay as a Visual Debugging Tool"
categories: [SwiftUI]
tags: [swiftui, debugging, overlay]
permalink: /:year/:month/:day/:slug
toc: true
media_subpath: /assets/img/overlay-as-debug-tool/
description: >
  The overlay modifier can add all sorts of visual information to a view, without impacting its layout. Here are some examples of its versatility as a debugging tool.
image:
  path: header@3x.png
---

Debugging tools
---------------

If you have spent any time working with SwiftUI, you have probably reached a situation where a view is laying out in an unexpected manner, some padding looks off, or the alignments are misbehaving. One of the most fundamental tools for adding a visual indicator to a specific view is the handy [`border`](https://developer.apple.com/documentation/swiftui/view/border(_:width:)) modifier, which will draw a border around any view, handy for outlining its actual frame:

```swift
HStack(spacing: .zero) {
    Circle().fill(.gray.tertiary)
    Circle().fill(.green)

    Circle().fill(.mint)
    .frame(width: 120, height: 100)
    .border(.red.secondary, width: 4) // Highlight the frame of this view.

    Circle().fill(.teal)
    Circle().fill(.gray.tertiary)
}
.padding(.horizontal)
```

{% include color-scheme-img.md
  alt="Border modifier outlining the frame of a Circle view."
  name="border-modifier"
%}

-----


The `border` modifier works well as visual debugging for two reasons: it adds a visual indicator, and it does not modify the layout of the owner view. The original layout is kept intact both internally (the sub-views contained by the owner view), and externally (the space the owner view occupies in its parent layout). This orthogonality is important in a debugging tool: it modifies one aspect (adds a visual adornment) while not modifying another aspect (the layout of the views).

The debug tool orthogonality is also present in another modifier that turns out to be extremely versatile: [`overlay`](https://developer.apple.com/documentation/swiftui/view/overlay(alignment:content:)). Using it we can add all sorts of visual information without impacting the original layout of the views we are debugging. Here are some interesting features of `overlay` and how it can be used as a debug tool for SwiftUI views.

-----


Layout is never modified
------------------------

It is worth repeating the most important feature of this modifier: adding an `overlay` will never change the layout space the owner view occupies. This means it can always be added as a non-destructive layout operation. At its most basic it can be used to label and keep track of a view:

```swift
HStack(spacing: .zero) {
    Circle().fill(.gray.tertiary)

    Capsule()
    .fill(.teal.secondary)
    .frame(width: 200, height: 100)
    .overlay(alignment: .trailing) { // Label this view.
        Text("A `Capsule` Shape")
        .font(.caption)
    }

    Circle().fill(.gray.tertiary)
}
.padding(.horizontal)
```

{% include color-scheme-img.md
  alt="Overlay modifier labeling a Capsule view."
  name="overlay-as-label"
%}

-----


Overlay content size
--------------------

The content in an `overlay` is always framed to the size of the owner view, an expanding view will grow to this exact size. For example, adding a `Rectangle` in an overlay reproduces the same behavior as the `border` modifier:

```swift
HStack(spacing: .zero) {
    Circle().fill(.gray.tertiary)

    Capsule()
    .fill(.teal.secondary)
    .frame(width: 200, height: 100)
    .overlay(alignment: .trailing) { // Border this view.
        Rectangle()
        .strokeBorder(.red.secondary, lineWidth: 4)
    }

    Circle().fill(.gray.tertiary)
}
.padding(.horizontal)
```

{% include color-scheme-img.md
  alt="Overlay modifier drawing the border of a Capsule view."
  name="overlay-as-border"
%}

-----


Mix this with a `GeometryReader` and it can print geometry information about any view! Note that since the content in `overlay` is framed to the size of the owner view (the `Capsule`), text will adapt to the available size by wrapping around:

```swift
HStack(spacing: .zero) {
    Circle().fill(.gray.tertiary)

    Capsule()
    .fill(.teal.secondary)
    .frame(width: 200, height: 100)
    .overlay { // Print geometry of this view.
        GeometryReader { geometry in
            Text("""
                size: \(geometry.size.debugDescription)
                safeAreaInsets: \(String(describing:geometry.safeAreaInsets))
                """)
            .font(.caption.monospacedDigit())
        }
    }

    Circle().fill(.gray.tertiary)
}
.padding(.horizontal)
```

{% include color-scheme-img.md
  alt="Overlay modifier printing geometry information of a Capsule view."
  name="overlay-as-geometry"
%}

-----


Any `overlay` content that is larger than the owner view will overflow while staying aligned to the overlay alignment. Even in these cases the original layout is still unchanged, notice the `border` still highlights only the `Capsule` frame:

```swift
HStack(spacing: .zero) {
    Circle().fill(.gray.tertiary)

    Capsule()
    .fill(.teal.secondary)
    .frame(width: 200, height: 100)
    .overlay(alignment: .bottomLeading) {
        Text("A large `Capsule`")
        .font(.largeTitle)
        .fixedSize() // Force the label to overflow.
    }
    .border(.red.secondary, width: 4) // Note the frame is still just the capsule.

    Circle().fill(.gray.tertiary)
}
.padding(.horizontal)
```

{% include color-scheme-img.md
  alt="An overlay label overflowing over its owner view."
  name="overlay-overflow"
%}

-----


Alignment guides
----------------

Alignment in an `overlay` is one of its most interesting aspects. The overlaid content is aligned to the guides of the owner view. This makes it possible to use `overlay` to add a visualization of any alignment guide, especially for views that offer additional alignments like [`firstTextBaseline`](https://developer.apple.com/documentation/SwiftUI/VerticalAlignment/firstTextBaseline):

```swift
Text("""
    The fence we walked between the years
    Did balance us serene
    """
)
.overlay(alignment: .centerFirstTextBaseline) {
    Rectangle()
    .fill(.red.secondary)
    .frame(width: 350, height: 4)
}
```

{% include color-scheme-img.md
  alt="A multiline text with a red indicator for its first baseline alignment guide."
  name="first-text-baseline"
%}

-----


When views modify their alignment guides `overlay` uses that adjusted guide, so custom alignments can be easily tracked visually. Again note that the last `border` drawn shows that the resulting frame from the `overlay` modifier is still the size of just the original `Text`:

```swift
Text("""
    We ached and almost touched that stuff
    Our reach was never quite enough
    If only we had taller been
    """
)
.alignmentGuide(.leading) { dimensions in
    dimensions[.leading] + 22
}
.overlay(alignment: .centerLastTextBaseline) {
    Rectangle() // Last Baseline indicator.
    .fill(.red.secondary)
    .frame(width: 350, height: 4)
}
.overlay(alignment: .leading) {
    Rectangle() // Leading indicator.
    .fill(.red.secondary)
    .frame(width: 4, height: 100)
}
.border(.teal.tertiary, width: 2) // Note the frame is still just the text.
```

{% include color-scheme-img.md
  alt="A multiline text with red indicators for its leading and last baseline alignment guides."
  name="multiple-alignments"
%}

-----


Floating content
----------------

And this brings us to my favorite surprise out of `overlay`, a product of how it handles its content and alignments: By modifying the alignment of the overlaid content it is possible to create floating content around the owner view. Debug visuals can then _float_ outside of the debugged view, without blocking it at all:

```swift
RoundedRectangle(cornerRadius: 8)
.fill(.teal.gradient)
.stroke(.indigo.gradient, lineWidth: 4)
.frame(width: 100, height: 100)
.overlay(alignment: .trailingLastTextBaseline) {
    Text("A `RoundedRectangle`\nwith fill and stroke")
    .fixedSize()
    .font(.caption)
    .padding(.horizontal, 8)
    .alignmentGuide(.trailing) { $0[.leading] } // Floating alignment!
}
```

{% include color-scheme-img.md
  alt="A rounded rectangle with an outer trailing floating label."
  name="floating-content"
%}

-----


Floating content is particularly useful for creating illustrations for examples or documentation, where the example and the visual adornments can both live in the code.

```swift
Text("""
    In the green
    of leaf
    and promising
    of peach
    """
)
.font(.subheadline)
.padding(.horizontal, 4)
.frame(width: 160, height: 100, alignment: .trailing)
.background {
    RoundedRectangle(cornerRadius: 8).fill(.teal.secondary)
}
// Illustration adornments.
.overlay(alignment: .trailing) {
    HStack(spacing: 4) {
        Rectangle()
            .fill(.red.secondary)
            .frame(width: 2)
        Text("Notice `Text` multiline alignment defaults to `leading`")
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(width: 100, alignment: .leading)
    }
    .padding(.leading, 8)
    .alignmentGuide(.trailing) { $0[.leading] }
}
```

{% include color-scheme-img.md
  alt="An example illustration of a multiline text, with a note about multiline default alignment."
  name="illustration-example"
%}
_Example illustration along its own adornments._

-----


Debug Overlay
-------------

All these `overlay` features ended up as the basis for implementing [`DebugOverlayModifier`](https://lopsae.com/preview-utilities/documentation/previewutilities/), one of the main tools in the [PreviewUtilities](https://github.com/lopsae/preview-utilities) package:

```swift
// import PreviewUtilities
HStack(spacing: .zero) {
    Text("view")
    Text(".debugOverlay()")
        .debugOverlay(.size, .alignment(.outerBottomTrailing))
}
.monospaced()
```

![The text view.debugOverlay() where the modifier is higlighted with a debug overlay.](debug-overlay-example@3x.png){: .light width="400" }
![The text view.debugOverlay() where the modifier is higlighted with a debug overlay.](debug-overlay-example~dark@3x.png){: .dark width="400" }

Use it to quickly add on your previews or runtime a visual to asses the geometry information of any view, without messing with the layout. I have found it a fantastic tool, and it gave me a deep appreciation of the power of a humble `overlay`.

-----

<p style="display: block; margin-block-start: 2em; text-align: center; padding: 0; color: #6d6c6c;">
<i class="fas fa-ruler-combined"></i>
<br/>
<em style="font-style: normal; font-size: 70%">Visually debugging since 2003, when Macromedia Flash MX was released</em>
</p>
