---
layout: post
date: 2026-05-28 14:30:00 -0700
title: "Overlay as a Visual Debugging Tool"
categories: [SwiftUI]
tags: [swiftui, debugging, overlay]
permalink: /:year/:month/:day/:slug
description: >
  The overlay modifier can add all sorts of visual information to a view, without impacting its layout. Here are some examples of its versatility as a debugging tool.
---

If you have been working anytime using SwiftUI, you have probably come to a situation where a view is laying out in an unexpected manner, some padding looks off, or the alignments are misbehaving. One of the most fundamental tools for adding a visual indicator to an specific view is the handy `border` modifier, which will draw a border around any view, handy for outlining its actual frame.

The `border` modifier works well for visual debugging its owner view for two reasons: it adds a visual indicator, and it **does not** modify the layout of the owner view. The original layout is kept intact both internally (the sub-views contained by the owner view), or externally (the space the owner view occupies in its parent layout). This orthogonality is important in a debugging tool: it modifies one aspect (adds a visual adornment) while **not** modifying another aspect (the layout of the views). This orthogonality is also present in another modifier that turns out is extremely versatile: `overlay`.

In the process of developing PreviewUtilities, I was constantly surprised with usefulness of the `overlay` modifier. One of the main tools in this package (`DebugOverlay`) is basically the visualization of the geometry information of a view, all wrapped inside a handy `overlay`. Using an overlay we can add all sorts of visual information, without impacting the original layout of the views we are debugging.

These are some interesting features of `overlay` and how it can be used as a debug tool for SwiftUI views.

### `overlay` never modifies the layout of the owner view

Worth repeating the most impotant feature of this modifer: adding a `overlay` modifier over a view will never change the layout space that view occupies. This means it can always be added as a non-destructive layout operation to add visual cues helping figure intricate layout problems.

At its most basic it can be used to, say, label a view we want to keep track of.


### `overlay` content is framed to the size of the owner view

An expanding view in an overlay will be restricted to exactly the size of the owner view. For example, to reproduce the same behaviour of the `border` modifier, we can add a simple `Rectangle` in an overlay.


Mix this with a geometry reader and you can print geometry information about any view.


### Overlay alignments

Content in an overlay is aligned using the alignment guides of the owner view. This makes it possible to add a visual indicator of any alignment a view uses, even after modifications.


### Floating content

Since the content is both aligned and framed to the size of the content view, it becomes particularly easy to add visual content that is floating and attached to a view.