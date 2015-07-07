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

    override init(){
        super.init()
        self.context = JSContext()
        self.addFunctionsToJSContext()
        
        self.context.exceptionHandler = {context, exception in self.exceptionHandler?.handleException(exception) }
    }
    
    func execute(code: String ) -> JSValue?{
        var result = self.context.evaluateScript(code)
        return result
    }
    
    func addFunctionsToJSContext()
    {
        // export JS class
        self.context.setObject(PeakDetection.self, forKeyedSubscript: "PeakDetection")
        self.context.setObject(StandardDeviation.self, forKeyedSubscript: "StandardDeviation")
        self.context.setObject(LowPassFilter.self, forKeyedSubscript: "LowPassFilter")
        self.context.setObject(RCFilter.self, forKeyedSubscript: "RCFilter")
        self.context.setObject(Evaluator.self, forKeyedSubscript: "Evaluator")
        self.context.setObject(TestCase.self, forKeyedSubscript: "TestCase")
        self.context.setObject(Parser.self, forKeyedSubscript: "Parser")
    }
}
