---
layout: post
date: 2026-05-28 14:30:00 -0700
title: "Overlay as a Visual Debugging Tool"
categories: [SwiftUI]
tags: [swiftui, debugging, overlay]
permalink: /:year/:month/:day/:slug
toc: true
description: >
  The overlay modifier can add all sorts of visual information to a view, without impacting its layout. Here are some examples of its versatility as a debugging tool.
---

Debugging tools
---------------

If you have been working anytime using SwiftUI, you have probably reached a situation where a view is laying out in an unexpected manner, some padding looks off, or the alignments are misbehaving. One of the most fundamental tools for adding a **visual indicator** to an specific view is the handy `border` modifier, which will draw a border around any view, handy for outlining its actual frame.

```swift
HStack(spacing: .zero) {
    Circle().fill(.gray.tertiary)
    Circle().fill(.green)

    Circle().fill(.mint)
    .frame(width: 120, height: 100)
    .border(.red.secondary, width: 2) // Highlight the frame of this view.

    Circle().fill(.teal)
    Circle().fill(.gray.tertiary)
}
.padding(.horizontal)
```

![Border modifier outlining the frame of a Circle view.](/assets/img/overlay-as-debug-tool/border-modifier@3x.png){: .light width="400" }
![Border modifier outlining the frame of a Circle view.](/assets/img/overlay-as-debug-tool/border-modifier~dark@3x.png){: .dark width="400" }

The `border` modifier works well for visual debugging for two reasons: it adds a visual indicator, and it **does not** modify the layout of the owner view. The original layout is kept intact both internally (the sub-views contained by the owner view), and externally (the space the owner view occupies in its parent layout). This **orthogonality** is important in a debugging tool: it modifies one aspect (adds a visual adornment) while **not** modifying another aspect (the layout of the views). This orthogonality is also present in another modifier that turns out is extremely versatile: `overlay`.

In the process of developing PreviewUtilities, I was constantly surprised with usefulness of the `overlay` modifier. One of the main tools in this package (`DebugOverlay`) is basically a visualization of the geometry information of a view, all wrapped inside a handy `overlay`. Using an overlay we can add all sorts of visual information, without impacting the original layout of the views we are debugging.

Here are some interesting features of `overlay` and how it can be used as a debug tool for SwiftUI views.

Layout is never modified
------------------------

Worth repeating the most impotant feature of this modifer: adding an `overlay` modifier will never change the layout space the owner occupies. This means it can always be added as a **non-destructive** layout operation to add visual cues to help figure intricate layout problems.

At its most basic it can be used to label a view we want to keep track of.


Overlay content size
--------------------

The content in an `overlay` is always framed to the size of the owner view, an expanding view will grow to this exact size. For example: to reproduce the same behaviour of the `border` modifier we can add a simple `Rectangle` in an overlay:

Mix this with a geometry reader and you can print geometry information about any view.

Any content that is larger overflows while aligned to the overlay alignment. Even if the overlay content is bigger, the size of the owner view remains unchanged.


Alignment guides
----------------

Content in an overlay is aligned using the alignment guides of the owner view. This makes it possible to add a visual indicator of any alignment the view supports.

This includes modified and custom alignment guides, or guides that apply to only certain views like `firstBaseLine`.


Floating content
----------------

Since the content is both aligned and framed to the size of the content view, it becomes particularly easy to add visual content that is floating and attached to a view.