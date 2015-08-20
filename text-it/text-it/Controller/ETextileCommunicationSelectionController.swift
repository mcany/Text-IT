//
//  ETextileCommunicationSelectionController.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/20/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class ETextileCommunicationSelectionController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource  {
    
    @IBOutlet weak var sourceTableView: NSTableView!
    @IBOutlet weak var targetTableView: NSTableView!
    
    var sourceDataArray : [String] = ["I2CReply", "AnalogMessage", "DigitalMessage"]
    var targetDataArray : [String] = []
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        var registeredTypes:[String] = [NSStringPboardType]
        self.sourceTableView.registerForDraggedTypes(registeredTypes)
        self.targetTableView.registerForDraggedTypes(registeredTypes)
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int
    {
        var numberOfRows:Int = 0;
        if (aTableView == sourceTableView)
        {
            numberOfRows = sourceDataArray.count
        }
        else if (aTableView == targetTableView)
        {
            numberOfRows = targetDataArray.count
        }
        return numberOfRows
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
    {
        var newString:String = ""
        if (tableView == sourceTableView)
        {
            newString = sourceDataArray[row]
        }
        else if (tableView == targetTableView)
        {
            newString = targetDataArray[row]
        }
        return newString;
    }
    
    func tableView(aTableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool
    {
        if ((aTableView == sourceTableView) || (aTableView == targetTableView))
        {
            var data:NSData = NSKeyedArchiver.archivedDataWithRootObject(rowIndexes)
            var registeredTypes:[String] = [NSStringPboardType]
            pboard.declareTypes(registeredTypes, owner: self)
            pboard.setData(data, forType: NSStringPboardType)
            return true
        }
        else
        {
            return false
        }
    }
    
    func tableView(aTableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation operation: NSTableViewDropOperation) -> NSDragOperation
    {
        if operation == .Above {
            return .Move
        }
        return .Every
    }
    
    func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool
    {
        var data:NSData = info.draggingPasteboard().dataForType(NSStringPboardType)!
        var rowIndexes:NSIndexSet = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSIndexSet
        
        if ((info.draggingSource() as! NSTableView == targetTableView) && (tableView == targetTableView))
        {
            var value:String = targetDataArray[rowIndexes.firstIndex]
            targetDataArray.removeAtIndex(rowIndexes.firstIndex)
            if (row > targetDataArray.count)
            {
                targetDataArray.insert(value, atIndex: row-1)
            }
            else
            {
                targetDataArray.insert(value, atIndex: row)
            }
            targetTableView.reloadData()
            return true
        }
        else if ((info.draggingSource() as! NSTableView == sourceTableView) && (tableView == targetTableView))
        {
            var value:String = sourceDataArray[rowIndexes.firstIndex]
            //sourceDataArray.removeAtIndex(rowIndexes.firstIndex)
            targetDataArray.append(value)
            sourceTableView.reloadData()
            targetTableView.reloadData()
            return true
        }
        else if ((info.draggingSource() as! NSTableView == targetTableView) && (tableView == sourceTableView))
        {
            var value:String = targetDataArray[rowIndexes.firstIndex]
            targetDataArray.removeAtIndex(rowIndexes.firstIndex)
            //sourceDataArray.append(value)
            sourceTableView.reloadData()
            targetTableView.reloadData()
            return true
        }
        else
        {
            return false
        }
    }
    
}
