//
//  ViewControllerOutlineView.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/26/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

extension ViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    //static let sharedInstance = ViewControllerOutlineView()
    
    //MARK: - NSOutlineView component
    
    func textView(textView: NSTextView, doubleClickedOnCell cell: NSTextAttachmentCellProtocol!, inRect cellFrame: NSRect) {
        <#code#>
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        if let fileSystemItem = item as? FileSystemItem {
            var file = File()
            if(file.fileExists(fileSystemItem.fullPath()))
            {
                self.currentFile = fileSystemItem.fullPath()
            }
        }
        return true
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let it: AnyObject = item {
            switch it {
            case let c as FileSystemItem:
                return c.childAtIndex(index)
            default:
                assert(false, "outlineView:index:item: gave a dud item")
                return self
            }
        } else {
            return FileSystemItem.rootItem(Constants.Path.FolderName)
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        switch item {
        case let c as FileSystemItem:
            var file = File()
            return file.folderExists(c.fullPath())
        default:
            return false
        }
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let it: AnyObject = item {
            switch it {
            case let c as FileSystemItem:
                return c.numberOfChildren()
            default:
                return 1
            }
        } else {
            return 1 // 5 categories
        }
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        if let it: AnyObject = item {
            switch it {
            case let c as FileSystemItem:
                return c.relativePath()
            default:
                return "/"
            }
        }
        return "/"
    }
    
    // MARK: - NSOutlineViewDelegate
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        var fileSystemItem = item as! FileSystemItem
        if(fileSystemItem.fileName().componentsSeparatedByString(".").count == 0 && fileSystemItem.fileName() != "Text-It")
        {
            let view = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = fileSystemItem.fileName()
            }
            return view
        }
        else
        {
            let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = fileSystemItem.fileName()
            }
            return view
        }
        /*
        switch item {
        case let c as FileSystemItem:
        let view = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView
        if let textField = view.textField {
        textField.stringValue = c.fileName()
        }
        return view
        
        //case let s as SubComponentModel:
        //    let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
        //    if let textField = view.textField {
        //        textField.stringValue = s.name
        //    }
        //    return view
        default:
        return nil
        }
        */
    }
    
    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        if ((outlineView.parentForItem(item)) != nil) {
            // If not nil; then the item has a parent.
            return false
        }
        return true
    }
}
