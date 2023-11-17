//
//  IMManager.swift
//  ArtServices
//
//  Created by Reginaldo Lopes on 09/11/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

import UIKit
import SystemConfiguration

@objcMembers class IMManager: NSObject
{
    static let sharedManager = IMManager()
    fileprivate var _hasConnection : Bool = false
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate override init()
    {
        super.init()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    var hasConnection : Bool
    {
        return self._hasConnection
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func startIMManager()
    {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange{(status: AFNetworkReachabilityStatus?) in
            
            switch status!.hashValue
            {
                case AFNetworkReachabilityStatus.notReachable.hashValue:
                self._hasConnection = false
                break
                
                case AFNetworkReachabilityStatus.reachableViaWiFi.hashValue , AFNetworkReachabilityStatus.reachableViaWWAN.hashValue:
                    
                if self.connectedToNetwork()
                {
                    self._hasConnection = true
                }
                else
                {
                    self._hasConnection = false
                }
                break
                
                default:
                self._hasConnection = false
                break
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func stopIMManager()
    {
        AFNetworkReachabilityManager.shared().stopMonitoring()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func connectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO ///////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
