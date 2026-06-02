---
layout: post
date: 2026-05-28 14:30:00 -0700
title: "Overlay as a Visual Debugging Tool"
categories: [SwiftUI]
tags: [swiftui, debugging, overlay, layout]
permalink: /:year/:month/:day/:slug
excerpt: >
  One of the most fundamental tools for adding a visual indicator for a specific view is the handy `border` modifier, which will draw a border around any view.
  An `overlay` can also be used to add all sorts of visual information, without impacting the original layout of the views we are debugging.
---

Overlay as a Visual Debugging Tool
==================================

If you have been working anytime using SwiftUI, you have probably come to a situation where a view is laying out in an unexpected manner, some padding looks off, or the alignments are misbehaving.

One of the most fundamental tools for adding a visual indicator for an specific view is the handy ``border`` modifier, which will draw a border around any view.

The ``border`` modifier works well for visual debugging for two reasons: it adds a visual indicator, and it does it without modify the layout of the owner view. This orthogonality is important for a debugging tool: it modifies one aspect (adding a visual adornment) while NOT modifying another aspect (the layout of the views). This two functionalities are also present in another operator that turns out is extremely versatile: `overlay`.

In the process of developing PreviewUtilities, I was constantly surprised with usefulness of the `overlay` modifier. The main tool in the aforentioned package (``DebugOverlay``) is basically the visualization of some geometry information of a view, all wrapped inside a handy `overlay`. This means using an overlay we can add all sorts of visual information, without impacting the original layout of the views we are debugging.

These are some interesting features of `overlay` and how it can be used as a debug tool for SwiftUI views.

### An `overlay` never modifies the layout of the owner view.

Worth repeating the most impotant feature of this modifer: adding a `overlay` modifier over a view will never change the layout space that view occupies. This means it can always be added as a non-destructive layout operation to add visual cues helping figure intricate layout problems.

At its most basic it can be used to, say, label a view we want to keep track of.


### An `overlay`  frames its content to the size of the owner view.

An expanding view in an overlay will be restricted to exactly the size of the owner view. For example, to reproduce the same behaviour of the `stroke`` modifier, we can add a simple Rectangle in an overlay.


Mix this with a geometry reader and you can print geometry information about any view.


### An `overlay` aligns its contents using the alignment guides of the owner view

Since the overlay also supports alignments, and all content is framed in the size of the owner view, it becomes particularly easy to add visual content that is floating and attached to a view.

On top of that, the alignment guides of the owner view are used, so alignment guides can become visible with just another rectangle in an overlay.