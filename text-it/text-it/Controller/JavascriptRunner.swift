//
//  JavascriptRunner.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/7/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

protocol Debugger{
    
    func addDebugInfo(code: String );
}

protocol ExceptionHandler{
    
    func handleException(exception: JSValue) -> Void;
}

class JavascriptRunner: NSObject {
    
    var context: JSContext!
    static let sharedInstance = JavascriptRunner()
    var debugDelegate : Debugger?
    var exceptionHandler : ExceptionHandler?
    var executionCode: String = ""{
        didSet{
            self.codeChanged = true
        }
    }
    var codeChanged: Bool = false
    
    /** Serial dispatch queue */
    private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)
    
    override init(){
        super.init()
        self.context = JSContext()
        self.addFunctionsToJSContext()
        
        self.context.exceptionHandler = {context, exception in self.exceptionHandler?.handleException(exception) }
    }
    
    func execute(code: String, completionHandler: (JSValue) -> Void  ){
        //var result: JSValue!
        dispatch_async(queue) {
            let result = self.context.evaluateScript(code)
            dispatch_async(dispatch_get_main_queue(), {completionHandler( result)})
        }
    }
    
    func executeLoop(completionHandler: (JSValue) -> Void )
    {
        
        let seconds = 2.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            if(self.codeChanged)
            {
                dispatch_async(self.queue) {
                    self.codeChanged = false
                    let result = self.context.evaluateScript(self.executionCode)
                    dispatch_async(dispatch_get_main_queue(), {completionHandler(result); self.executeLoop(){result in  completionHandler(result)}})
                }
            }
            else
            {
                self.executeLoop(){result in  completionHandler(result)}
            }
        })
    }
    
    func executeMain(code: String) -> JSValue?{
        var result = self.context.evaluateScript(code)
        return result
    }
    
    func addFunctionsToJSContext()
    {
        // export JS class
        self.context.setObject(FastFourierTransform.self, forKeyedSubscript: "FastFourierTransform")
        self.context.setObject(Median.self, forKeyedSubscript: "Median")
        self.context.setObject(Mean.self, forKeyedSubscript: "Mean")
        self.context.setObject(PeakDetection.self, forKeyedSubscript: "PeakDetection")
        self.context.setObject(StandardDeviation.self, forKeyedSubscript: "StandardDeviation")
        self.context.setObject(HighPassFilter.self, forKeyedSubscript: "HighPassFilter")
        self.context.setObject(LowPassFilter.self, forKeyedSubscript: "LowPassFilter")
        self.context.setObject(RCFilter.self, forKeyedSubscript: "RCFilter")
        self.context.setObject(Evaluator.self, forKeyedSubscript: "Evaluator")
        self.context.setObject(TestCase.self, forKeyedSubscript: "TestCase")
        self.context.setObject(Parser.self, forKeyedSubscript: "Parser")
    }
}
