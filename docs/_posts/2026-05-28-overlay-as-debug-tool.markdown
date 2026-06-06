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
---

Debugging tools
---------------

If you have spent any time working with SwiftUI, you have probably reached a situation where a view is laying out in an unexpected manner, some padding looks off, or the alignments are misbehaving. One of the most fundamental tools for adding a **visual indicator** to a specific view is the handy [`border`](https://developer.apple.com/documentation/swiftui/view/border(_:width:)) modifier, which will draw a border around any view, handy for outlining its actual frame:

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

![Border modifier outlining the frame of a Circle view.](border-modifier@3x.png){: .light width="400" }
![Border modifier outlining the frame of a Circle view.](border-modifier~dark@3x.png){: .dark width="400" }

The `border` modifier works well for visual debugging for two reasons: it adds a visual indicator, and it **does not** modify the layout of the owner view. The original layout is kept intact both internally (the sub-views contained by the owner view), and externally (the space the owner view occupies in its parent layout). This **orthogonality** is important in a debugging tool: it modifies one aspect (adds a visual adornment) while **not** modifying another aspect (the layout of the views).

The debug tool orthogonality is also present in another modifier that turns out to be extremely versatile: [`overlay`](https://developer.apple.com/documentation/swiftui/view/overlay(alignment:content:)). Most of this was found in the process of developing [PreviewUtilities](https://github.com/lopsae/preview-utilities), where I was constantly surprised by the usefulness of the `overlay` modifier. One of the main tools in this package ([`DebugOverlayModifier`](https://lopsae.com/preview-utilities/documentation/previewutilities/)) wraps a visualization of the geometry information of a view inside a handy `overlay`.

Using an overlay we can add all sorts of visual information, without impacting the original layout of the views we are debugging. Here are some interesting features of `overlay` and how it can be used as a debug tool for SwiftUI views.

Layout is never modified
------------------------

It is worth repeating the most important feature of this modifier: adding an `overlay` will never change the layout space the owner occupies. This means it can always be added as a **non-destructive** layout operation. At its most basic it can be used to label and keep track of a view:

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

![Overlay modifier labeling a Capsule view.](overlay-as-label@3x.png){: .light width="400" }
![Overlay modifier labeling a Capsule view.](overlay-as-label~dark@3x.png){: .dark width="400" }


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

![Overlay modifier drawing the border of a Capsule view.](overlay-as-border@3x.png){: .light width="400" }
![Overlay modifier drawing the border of a Capsule view.](overlay-as-border~dark@3x.png){: .dark width="400" }


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

![Overlay modifier printing geometry information of a Capsule view.](overlay-as-geometry@3x.png){: .light width="400" }
![Overlay modifier printing geometry information of a Capsule view.](overlay-as-geometry~dark@3x.png){: .dark width="400" }


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

![An overlay label overflowing over its owner view.](overlay-overflow@3x.png){: .light width="400" }
![An overlay label overflowing over its owner view.](overlay-overflow~dark@3x.png){: .dark width="400" }


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

![A multiline text with a red indicator for its first baseline alignment guide.](first-text-baseline@3x.png){: .light width="400" }
![A multiline text with a red indicator for its first baseline alignment guide.](first-text-baseline~dark@3x.png){: .dark width="400" }


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

![A multiline text with red indicators for its leading and last baseline alignment guides.](multiple-alignments@3x.png){: .light width="400" }
![A multiline text with red indicators for its leading and last baseline alignment guides.](multiple-alignments~dark@3x.png){: .dark width="400" }


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

![A rounded rectangle with an outer trailing floating label.](floating-content@3x.png){: .light width="400" }
![A rounded rectangle with an outer trailing floating label.](floating-content~dark@3x.png){: .dark width="400" }


Floating content is also particularly useful for creating illustrations for examples or documentation, where the example and the visual adornments can both live in the code.

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

![An example illustration of a multiline text, with a note about multiline default alignment.](illustration-example@3x.png){: .light width="400" }
![An example illustration of a multiline text, with a note about multiline default alignment.](illustration-example~dark@3x.png){: .dark width="400" }
_Example illustration along its own adornments._