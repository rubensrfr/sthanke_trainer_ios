//
//  CircuitListController.swift
//  mobitrainer
//
//  Created by Reginaldo Lopes on 11/11/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

import WatchKit
import Foundation

class CircuitListController: WKInterfaceController
{
    // MARK: - GLOBALS
    
    @IBOutlet var table: WKInterfaceTable!
    
    fileprivate var arrayData = [ExerciseList]()
    fileprivate var exerciseCircuito : ExerciseList?
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - LIFECYCLE
    
    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        self.setTitle("mobitrainer")
    //  RFR  let showMenu = context!["showMenu"] as! Bool
        
        let showMenuValue = context as! NSDictionary
        let showMenu = showMenuValue["showMenu"] as! Bool
        
        if showMenu == true
        {
            addMenuItem(with: WKMenuItemIcon.accept, title:"Feito", action: #selector(CircuitListController.menuActionDone))
        }
        else
        {
            clearAllMenuItems()
        }
        
        // Configure interface objects here.
        // RFR arrayData = context!["array"] as! [ExerciseList]
        
        let arrayDataValue = context as! NSDictionary
        let arrayData = arrayDataValue["array"] as! [ExerciseList]
        
        
     //   RFR exerciseCircuito = context!["data"] as? ExerciseList
        
        let exerciseCircuitoValue = context as! NSDictionary
        let exerciseCircuito = exerciseCircuitoValue["data"] as? [ExerciseList]
        
        
        table.setNumberOfRows(arrayData.count, withRowType:"TableRowController")
        
        
        
        
        for index in 0..<arrayData.count {
        
            let exe = arrayData[index] 
            let row = table.rowController(at: index) as! TableRowController
            row.rowLabel.setText(exe.name)
            
            if arrayData.count > 2
            {
                row.rowGroup.setBackgroundColor(UIColor(red:222/255, green:173/255, blue:84/255, alpha: 1.0))
            }
            else
            {
                row.rowGroup.setBackgroundColor(UIColor(red:146/255, green:119/255, blue:169/255, alpha: 1.0))
            }
            
        }
        
        table.scrollToRow(at: 0)
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
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
    
    // MARK: - TABLE DELEGATE
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int)
    {
        let e = arrayData[rowIndex] as ExerciseList
        
        var color : UIColor
        
        if arrayData.count > 2
        {
            color = UIColor(red:222/255, green:173/255, blue:84/255, alpha: 1.0)
        }
        else
        {
            color = UIColor(red:146/255, green:119/255, blue:169/255, alpha: 1.0)
        }
        
        let userInfo: [String: AnyObject] = ["showMenu" : false as AnyObject,"data" : e, "setColor" : color]
        pushController(withName: "ExerciseDetail", context:userInfo)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - MENU ACTION
    
    func menuActionDone()
    {
        let userInfo : [String : String] = ["exerciseID":exerciseCircuito!.exerciseID, "trainingID":exerciseCircuito!.trainingID]
        WatchSessionManager.sharedManager.transferUserInfo(userInfo as [String : AnyObject])
        self.pop()
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
