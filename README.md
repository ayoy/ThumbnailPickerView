ThumbnailPickerView
===================


ThumbnailPickerView is a control displaying a set (or technically an array) of thumbnails aligned horizontally. It mimics thumbnails view from iPad's Photos.app toolbar, but as a subclass of UIControl it can be freely used as a regular view outside the toolbar.


Features
--------

* selecting thumbnails by touch or programmatically - big thumbnail view overlays selected thumbnail
* touch-tracking of user selection (support for both tapping and panning through thumbnails)
* autoadjusting amount of visible thumbnails to nicely fit within view bounds
* loading data from the data source, interacting with outside world through the delegate
* asynchronous image loading
* reusable image views
* ARC-enabled code


Usage
-----

See the demo application for usage example.


Requirements
------------

* QuartzCore framework (solely for drawing borders around thumbnails)
* XCode 4.2 (for ARC)