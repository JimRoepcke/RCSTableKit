RCS TableKit
============

UITableView is a (the?) staple of iOS interfaces. You must implement dozens of delegate and data source methods in your view controllers to use a UITableView fully. Most of the code is pure boilerplate.

I **hate** boilerplate.

RCSTableKit provides a higher level interface for designing awesome UITableView-based interfaces. A simple .plist-based file declaratively constructs your table views, and makes it easy to bind your interface to your objects.

Why should I use this?
----------------------

You yearn for a more productive way to create and maintain UITableView-based interfaces.

Requirements
------------
- iOS 4.x

Building RCSTableKit
-------------------
- Clone RCSTableKit from GitHub: `git clone git://github.com/JimRoepcke/RCSTableKit.git`
- Open RCSTableKit/src/RCSTableKit.xcodeproj in Xcode
- Build

Using RCSTableKit in your iOS app project (using Xcode 3.2.x)
-------------------------------------------------------------
- Open RCSTableKit/src/RCSTableKit.xcodeproj in Xcode
- Drag-and-drop the RCSTableKit project icon at the top of RCSTableKit's Groups & Files pane into your app project
- In the General tab of the inspector of for app target, make your project dependent on the RCSTableKit target in RCSTableKit.xcodeproj
- Drag the libRCSTableKit.a static library (under RCSTableKit.xcodeproj in your app project) inside the "Link Binary with Libraries" section of your app target.
- Drag the "RCSTableKit Headers" group from the RCSTableKit project into your app project.
- Drag the "RCSTableKit Resources" group from the RCSTableKit project into your app project.
- import and use the RCSTableKit classes in your app

How it works
------------

- Create an instance of the **RCSTableDefinition** class. Use either `-initWithDictionary:` or `+tableDefinitionNamed:bundle:` to load a table definition from a plist file.
- Call `-viewControllerWithRootObject:` to instantiate a view controller using this definition and the provided object (or `nil` to designate the view controller as the root object).

The Most Basic Example
----------------------

    - (void) demonstration
    {
    }

View Controller Options
-----------------------
   
### Optional

- `nib` - the nib/xib to load for the view of the view controller
- `nibBundle` - the bundle the loaded nib is found in
- `controller` - the subclass of RCSTableViewController to use

- `allowsSelection` - corresponds to [UITableView allowsSelection]
- `allowsSelectionDuringEditing` - corresponds to -[UITableView allowsSelectionDuringEditing
- `isEditable` - when true, an Edit/Done button is put in the view controller's navigation item's right bar button item.

Table Options
-------------

### Required

- `displaySections` - 
- `sections` - 

### Optional

- `tableHeaderImagePath` -
- `tableHeaderImagePathSelector` -

RCSTableKit in practice
----------------------


Links
-----

- [Docs](https://github.com/JimRoepcke/RCSTableKit/wiki) (forthcoming)
- [Issue Tracker](https://github.com/JimRoepcke/RCSTableKit/issues) (please report bugs and feature requests!)

How to contribute
-----------------

- Fork [RCSTableKit on GitHub](https://github.com/JimRoepcke/RCSTableKit), send a pull request

Contributors
------------

- [JimRoepcke](https://github.com/JimRoepcke)

Alternatives
------------

Inspiration
-----------

- RCSTableKit is inspired by WebObjects, specifically WOComponent and the .wod file.

License
-------

Copyright 2009-2011 [Jim Roepcke](http://roepcke.com/) Licensed under the terms of the MIT license. See included [LICENSE](https://github.com/JimRoepcke/RCSTableKit/raw/master/LICENSE) file.
