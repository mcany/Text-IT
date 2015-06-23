//
//  THServerController2.h
//  TangoHapps
//
//  Created by Juan Haladjian on 18/09/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MultipeerConnectivity;

@class THServerController;

@protocol THServerControllerDelegate <NSObject>
- (void)server:(THServerController*)controller peerConnected:(NSString*)peerName;
- (void)server:(THServerController*)controller peerDisconnected:(NSString*)peerName;
- (void)server:(THServerController*)controller isReadyForSceneTransfer:(BOOL)ready;
- (void)server:(THServerController*)controller isRunning:(BOOL)running;
- (void)server:(THServerController*)controller isTransferring:(BOOL)transferring;
@end

@interface THServerController : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
{
}

@property (readonly, nonatomic) MCPeerID * localPeerId;
@property (readonly, nonatomic) MCSession * session;
@property (weak, nonatomic) id<THServerControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * invitationHandlers;

-(void) startServer;
-(void) stopServer;
- (void)sendMessage:(NSString *)message ;
@end


