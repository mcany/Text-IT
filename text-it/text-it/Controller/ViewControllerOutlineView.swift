//
//  ViewControllerOutlineView.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/26/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class ViewControllerOutlineView: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    static let sharedInstance = ViewControllerOutlineView()

    //test
    let featurExtractionComponent: ComponentModel = ComponentModel(name: "Feature Extraction")
    let filterComponent: ComponentModel = ComponentModel(name: "Filter")
    let testCaseComponent: ComponentModel = ComponentModel(name: "Test Case")
    let parserComponent: ComponentModel = ComponentModel(name: "Parser")
    
    var outlineView: NSOutlineView!
    //MARK: - NSOutlineView component
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        //println("child:ofItem")
        if let it: AnyObject = item {
            switch it {
            case let c as ComponentModel: // This works even though NSMutableArray is more accurate
                return c.methodNames[index]
            default:
                assert(false, "outlineView:index:item: gave a dud item")
                return self
            }
        } else {
            switch index {
            case 0:
                return self.featurExtractionComponent
            case 1:
                return self.filterComponent
            case 2:
                return self.testCaseComponent
            default:
                return self.parserComponent
            }
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        //println("isItemExpandable")
        switch item {
        case let c as ComponentModel:
            return (c.methodNames.count > 0) ? true : false
        default:
            return false
        }
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        //println("numberOfChildrenOfItem")
        if let it: AnyObject = item {
            //println("\(it)")
            switch it {
            case let c as ComponentModel:
                return c.methodNames.count
            default:
                return 0
            }
        } else {
            return 4 // 4 categories
        }
    }
    
    // MARK: - NSOutlineViewDelegate
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        switch item {
        case let c as ComponentModel:
            let view = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = c.name
            }
            return view
        case let s as SubComponentModel:
            let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = s.name
            }
            return view
        default:
            return nil
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        switch item {
        case let c as ComponentModel:
            return true
        default:
            return false
        }
    }
}
