//
//  WatchSessionManager.swift
//  mobitrainer
//
//  Created by Reginaldo Lopes on 05/11/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

import WatchConnectivity

@available(iOS 9.0, *)
@objcMembers class WatchSessionManager: NSObject, WCSessionDelegate
{
    static let sharedManager = WatchSessionManager()
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    fileprivate var arrayData = [ExerciseList]()
    fileprivate var arrayDataCircuit = [ExerciseList]()
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate override init()
    {
        super.init()
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func startSession()
    {
        session?.delegate = self
        session?.activate()
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate var validSession: WCSession?
    {
        if let s = session
        {
            return s
        }
        
        return nil
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    var getData : [ExerciseList]
    {
        return self.arrayData
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    var getDataCircuit : [ExerciseList]
    {
        return self.arrayDataCircuit
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func deleteExercise(_ e : ExerciseList)
    {
        arrayData = arrayData.arrayRemovingObject(e)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func isAvaliable() -> Bool
    {
        if(WCSession.isSupported())
        {
            return true
        }
        else
        {
            return false
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

extension Array where Element: Equatable
{
    func arrayRemovingObject(_ object: Element) -> [Element]
    {
        return filter { $0 != object }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

// MARK: - APPLICATION CONTEXT

@available(iOS 9.0, *)
extension WatchSessionManager
{
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func updateApplicationContext(_ applicationContext: [String : AnyObject]) throws
    {
        if let session = validSession
        {
            do
            {
                try session.updateApplicationContext(applicationContext)
            }
            catch let error
            {
                throw error
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        // handle receiving application context
        
        NSKeyedUnarchiver.setClass(ExerciseList.self, forClassName:"ExerciseList")
        
        self.arrayData.removeAll()
        self.arrayDataCircuit.removeAll()
        
        self.arrayData = NSKeyedUnarchiver.unarchiveObject(with: applicationContext["data"] as! Data) as! Array
        self.arrayDataCircuit = NSKeyedUnarchiver.unarchiveObject(with: applicationContext["dataC"] as! Data) as! Array

        if self.arrayData.count > 0
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "dataAvaliableForWatch"), object: nil)
        }
        
//        dispatch_async(dispatch_get_main_queue()) {
//            // make sure to put on the main queue to update UI!
//        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

// MARK: - USER INFO

@available(iOS 9.0, *)
extension WatchSessionManager
{
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////

    func transferUserInfo(_ userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer?
    {
        return validSession?.transferUserInfo(userInfo)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////

    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?)
    {
        // implement this on the sender if you need to confirm that
        // the user info did in fact transfer
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
  
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any])
    {
        let status = userInfo["showAlert"] as! Bool
        
        if (status)
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "appNeedShowNoDataScreen"), object:userInfo)
        }
        else
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "appNeedUpdateExerciseList"), object:userInfo)
        }
        
//        // handle receiving user info
//        dispatch_async(dispatch_get_main_queue()){
//            // make sure to put on the main queue to update UI!
//        }
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

// MARK: - TRANSFER FILES

@available(iOS 9.0, *)
extension WatchSessionManager
{
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func transferFile(_ file: URL, metadata: [String : AnyObject]) -> WCSessionFileTransfer?
    {
        return validSession?.transferFile(file, metadata: metadata)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    @available(iOS 9.0, *)
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?)
    {
        // handle filed transfer completion
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    @available(iOS 9.0, *)
    func session(_ session: WCSession, didReceive file: WCSessionFile)
    {
        // handle receiving file
        DispatchQueue.main.async {
            // make sure to put on the main queue to update UI!
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

// MARK: - MESSAGING

@available(iOS 9.0, *)
extension WatchSessionManager
{
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate var validReachableSession: WCSession?
    {
        if let session = validSession, session.isReachable
        {
            return session
        }
        
        return nil
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func sendMessage(_ message: [String : AnyObject],
        replyHandler: (([String : Any]) -> Void)? = nil,
        errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: (errorHandler as? (Error) -> Void))
    }
    
    /* RFR Original
    func sendMessage(_ message: [String : AnyObject],
                     replyHandler: (([String : AnyObject]) -> Void)? = nil,
                     errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }*/
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func sendMessageData(_ data: Data,
        replyHandler: ((Data) -> Void)? = nil,
        errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler as? (Error) -> Void)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void)
    {
        // handle receiving message
        DispatchQueue.main.async {
            // make sure to put on the main queue to update UI!
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void)
    {
        // handle receiving message data
        DispatchQueue.main.async {
            // make sure to put on the main queue to update UI!
        }
    }
    
    @available(iOS 9.3, *)
    @available(watchOSApplicationExtension 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
             print(WCSessionActivationState.self) //RFR
    }
    
    func sessionDidBecomeInactive(_ session: WCSession){
        
    }
    
    func sessionDidDeactivate(_ session: WCSession){
        
    }

}

///////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO ////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
