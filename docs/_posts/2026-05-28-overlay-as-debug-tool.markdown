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

If you have been working anytime using SwiftUI, you have probably reached a situation where a view is laying out in an unexpected manner, some padding looks off, or the alignments are misbehaving. One of the most fundamental tools for adding a **visual indicator** to an specific view is the handy [`border`](https://developer.apple.com/documentation/swiftui/view/border(_:width:)) modifier, which will draw a border around any view, handy for outlining its actual frame:

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

The debug tool orthogonality is also present in another modifier that turns out is extremely versatile: [`overlay`](https://developer.apple.com/documentation/swiftui/view/overlay(alignment:content:)). Most of this was found in the process of developing [PreviewUtilities](https://github.com/lopsae/preview-utilities), where I was constantly surprised with usefulness of the `overlay` modifier. One of the main tools in this package ([`DebugOverlayModifier`](https://lopsae.com/preview-utilities/documentation/previewutilities/)) wraps a visualization of the geometry information of a view inside a handy `overlay`.

Using an overlay we can add all sorts of visual information, without impacting the original layout of the views we are debugging. Here are some interesting features of `overlay` and how it can be used as a debug tool for SwiftUI views.

Layout is never modified
------------------------

Is worth repeating the most impotant feature of this modifer: adding an `overlay` will never change the layout space the owner occupies. This means it can always be added as a **non-destructive** layout operation. At its most basic it can be used to label and keep track of a view:

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
    .overlay(alignment: .bottom) { // Print geometry of this view.
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


Any `overlay` content that is larger that the owner view will overflow while staying aligned to the overlay alignment. Even in this cases, original layout is still unchanged, notice the `border` still highlights the just the `Capsule` frame:


Alignment guides
----------------

Content in an overlay is aligned using the alignment guides of the owner view. This makes it possible to add a visual indicator of any alignment the view supports.

This includes modified and custom alignment guides, or guides that apply to only certain views like `firstBaseLine`.


Floating content
----------------

Since the content is both aligned and framed to the size of the content view, it becomes particularly easy to add visual content that is floating and attached to a view.