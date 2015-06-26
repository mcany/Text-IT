//
//  ViewControllerServer.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/26/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

extension ViewController: THServerControllerDelegate {

    // MARK: - Server delegates

    func server(controller: THServerController!, peerConnected peerName: String!) {
        println(peerName)
    }
    
    func server(controller: THServerController!, peerDisconnected peerName: String!) {
        println(peerName)
    }
    
    func server(controller: THServerController!, isTransferring transferring: Bool) {
        println("transferring: "  + String(stringInterpolationSegment:transferring) )
    }
    
    func server(controller: THServerController!, isRunning running: Bool) {
        println("isRunning: " + String(stringInterpolationSegment:running)   )
    }
    
    func server(controller: THServerController!, isReadyForSceneTransfer ready: Bool) {
        println("isReadyForSceneTransfer: " + String(stringInterpolationSegment:ready)   )
    }
}
