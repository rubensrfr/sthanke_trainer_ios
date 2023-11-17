//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Reginaldo Lopes on 05/11/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

import WatchKit
import Foundation

class ExercisesListController : WKInterfaceController
{
    // MARK: - GLOBALS
    
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var groupMessage: WKInterfaceGroup!
    
    fileprivate var arrayData = [ExerciseList]()
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////

    // MARK: - VIEW LIFECYCLE
    
    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
    
        // Configure interface objects here.
        self.setTitle("mobitrainer")
        checkMessage()

    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        NotificationCenter.default.addObserver(self, selector:#selector(ExercisesListController.dataAvaliableForWatch),
                                                                   name:NSNotification.Name(rawValue: "dataAvaliableForWatch"),
                                                                 object:nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(ExercisesListController.appNeedShowNoDataScreen),
                                                                   name:NSNotification.Name(rawValue: "appNeedShowNoDataScreen"),
                                                                 object:nil)
        
        updateData()
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func checkMessage()
    {
        if(arrayData.count == 0)
        {
            groupMessage.setHidden(false)
            table.setHidden(true)
        }
        else
        {
            groupMessage.setHidden(true)
            table.setHidden(false)
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - NOTIFICATION HANDLER
    
    func dataAvaliableForWatch()
    {
        updateData()
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func appNeedShowNoDataScreen()
    {
        groupMessage.setHidden(false)
        table.setHidden(true)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func updateData()
    {
        self.arrayData = WatchSessionManager.sharedManager.getData
        
        checkMessage()
        
        if arrayData.count > 0
        {
            table.setNumberOfRows(arrayData.count, withRowType:"TableRowController")
            
            for index in 0 ..< arrayData.count
            {
                let exe = arrayData[index] as ExerciseList
                let row = table.rowController(at: index) as! TableRowController
                row.rowLabel.setText(exe.name)
                
                if exe.isCircuit.boolValue
                {
                    let arrayTemp = WatchSessionManager.sharedManager.getDataCircuit as Array
                    let filteredArray = arrayTemp.filter({
                        
                        $0.circuitID == exe.exerciseID
                        
                    })
                    
                    if filteredArray.count > 2
                    {
                        row.rowGroup.setBackgroundColor(UIColor(red:222/255, green:173/255, blue:84/255, alpha: 1.0))
                    }
                    else
                    {
                        row.rowGroup.setBackgroundColor(UIColor(red:146/255, green:119/255, blue:169/255, alpha: 1.0))
                    }
                }
            }
            
            table.scrollToRow(at: 0)
        }
        else
        {
            checkMessage()
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - TABLE DELEGATE
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int)
    {
        let e = arrayData[rowIndex] as ExerciseList
        
        if e.isCircuit.boolValue
        {
            let arrayTemp = WatchSessionManager.sharedManager.getDataCircuit as Array

            let filteredArray = arrayTemp.filter({
            
                $0.circuitID == e.exerciseID
                
            })
            
            let userInfo: [String: AnyObject] = ["showMenu" : true as AnyObject,"data" : e, "array" : filteredArray as AnyObject]
            pushController(withName: "CircuitList", context:userInfo)
        }
        else
        {
            let userInfo: [String: AnyObject] = ["showMenu" : true as AnyObject,"data" : e]
            pushController(withName: "ExerciseDetail", context:userInfo)
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO ////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
