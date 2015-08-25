//
//  ETextileCommunicationSelectionController.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/20/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

protocol ETextileCommunicationSelectionControllerHandler
{
    func communicationTypesSelected(communicationTypes: [CommunicationType])
}

class ETextileCommunicationSelectionController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource  {
    
    @IBOutlet weak var sourceTableView: NSTableView!
    @IBOutlet weak var targetTableView: NSTableView!
    @IBOutlet weak var communicationLabel: NSTextField!
    @IBOutlet weak var address: NSTextField!
    @IBOutlet weak var register: NSTextField!
    @IBOutlet weak var size: NSTextField!
    @IBOutlet weak var pin: NSTextField!
    @IBOutlet weak var addressTextField: NSTextField!
    @IBOutlet weak var registerTextField: NSTextField!
    @IBOutlet weak var sizeTextField: NSTextField!
    @IBOutlet weak var pinTextField: NSTextField!
    @IBOutlet weak var continueButton: NSButton!
    
    
    var sourceDataArray : [String] = ["I2CReply", "AnalogMessage", "DigitalMessage"]
    var targetDataArray : [String] = []
    var inputDataArray : [CommunicationType] = []
    var currentRow: Int = -1
    var handler: ETextileCommunicationSelectionControllerHandler!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        var registeredTypes:[String] = [NSStringPboardType]
        self.sourceTableView.registerForDraggedTypes(registeredTypes)
        self.targetTableView.registerForDraggedTypes(registeredTypes)
        
        self.communicationLabel.hidden = true
        self.address.hidden = true
        self.register.hidden = true
        self.size.hidden = true
        self.pin.hidden = true
        self.addressTextField.hidden = true
        self.registerTextField.hidden = true
        self.sizeTextField.hidden = true
        self.pinTextField.hidden = true
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        if(sender as! NSObject == self.continueButton)
        {
            self.close()
            self.handler.communicationTypesSelected(self.inputDataArray)
        }
    }
    
    @IBAction func textFieldEntered(sender: AnyObject) {
        var comm = self.inputDataArray[currentRow]
        if(sender as! NSObject == self.pinTextField)
        {
            if let commType = comm as? DigitalMessage {
                commType.pin = self.pinTextField.stringValue.toInt()!
            }
            else {
                var commType = comm as? AnalogMessage
                commType!.pin = self.pinTextField.stringValue.toInt()!
            }
        }
        else if(sender as! NSObject == self.addressTextField){
            var commType = comm as? I2CReply
            commType!.address = self.addressTextField.stringValue.toInt()!
        }
        else if(sender as! NSObject == self.registerTextField){
            var commType = comm as? I2CReply
            commType!.register = self.registerTextField.stringValue.toInt()!
        }
        else if(sender as! NSObject == self.sizeTextField){
            var commType = comm as? I2CReply
            commType!.size = self.sizeTextField.stringValue.toInt()!
        }

    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        self.currentRow = row
        if (tableView == targetTableView)
        {
            switch inputDataArray[row].className
            {
            case I2CReply.className():
                self.I2CReplyselected()
            case AnalogMessage.className():
                self.DigitalAnalogMessageSelected("AnalogMessage")
            case DigitalMessage.className():
                self.DigitalAnalogMessageSelected("DigitalMessage")
            default:
                break
            }
        }
        return true
    }
    
    func DigitalAnalogMessageSelected (name:String)
    {
        var comm = self.inputDataArray[currentRow]
        if let commType = comm as? DigitalMessage {
            self.pinTextField.stringValue = commType.pin.description
        }
        else {
            var commType = comm as? AnalogMessage
            self.pinTextField.stringValue = commType!.pin.description
        }
        self.communicationLabel.hidden = false
        self.communicationLabel.stringValue = name
        self.address.hidden = true
        self.register.hidden = true
        self.size.hidden = true
        self.pin.hidden = false
        self.addressTextField.hidden = true
        self.registerTextField.hidden = true
        self.sizeTextField.hidden = true
        self.pinTextField.hidden = false
    }

    func I2CReplyselected()
    {
        var comm = self.inputDataArray[currentRow]
        if let commType = comm as? I2CReply {
            self.communicationLabel.hidden = false
            self.communicationLabel.stringValue = "I2CReply"
            self.address.hidden = false
            self.addressTextField.stringValue = commType.address.description
            self.register.hidden = false
            self.registerTextField.stringValue = commType.register.description
            self.size.hidden = false
            self.sizeTextField.stringValue = commType.size.description
            self.pin.hidden = true
            self.addressTextField.hidden = false
            self.registerTextField.hidden = false
            self.sizeTextField.hidden = false
            self.pinTextField.hidden = true
        }
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
    
    // MARK: - Drag & Drop
    
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
            var commValue: CommunicationType =  inputDataArray[rowIndexes.firstIndex]
            targetDataArray.removeAtIndex(rowIndexes.firstIndex)
            inputDataArray.removeAtIndex(rowIndexes.firstIndex)
            if (row > targetDataArray.count)
            {
                targetDataArray.insert(value, atIndex: row-1)
                inputDataArray.insert(commValue, atIndex: row-1)
            }
            else
            {
                targetDataArray.insert(value, atIndex: row)
                inputDataArray.insert(commValue, atIndex: row)
            }
            targetTableView.reloadData()
            return true
        }
        else if ((info.draggingSource() as! NSTableView == sourceTableView) && (tableView == targetTableView))
        {
            var value:String = sourceDataArray[rowIndexes.firstIndex]
            //sourceDataArray.removeAtIndex(rowIndexes.firstIndex)
            targetDataArray.append(value)
            var comm :CommunicationType
            switch(value)
            {
            case "I2CReply":
                comm = I2CReply()
            case "AnalogMessage":
                comm  = AnalogMessage()
            case "DigitalMessage":
                comm = DigitalMessage()
            default:
                comm = CommunicationType()
            }
            inputDataArray.append(comm )
            
            sourceTableView.reloadData()
            targetTableView.reloadData()
            return true
        }
        else if ((info.draggingSource() as! NSTableView == targetTableView) && (tableView == sourceTableView))
        {
            var value:String = targetDataArray[rowIndexes.firstIndex]
            targetDataArray.removeAtIndex(rowIndexes.firstIndex)
            inputDataArray.removeAtIndex(rowIndexes.firstIndex)
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
