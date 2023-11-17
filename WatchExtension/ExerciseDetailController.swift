//
//  ExerciseDetailController.swift
//  mobitrainer
//
//  Created by Reginaldo Lopes on 06/11/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

import WatchKit
import Foundation

class ExerciseDetailController: WKInterfaceController
{
    // MARK: - GLOBALS
    
    @IBOutlet var lblExerciseName: WKInterfaceLabel!
    @IBOutlet var lblExecution: WKInterfaceLabel!
    @IBOutlet var lblInstruction: WKInterfaceLabel!
    @IBOutlet var groupLabel: WKInterfaceGroup!

    fileprivate var elist : ExerciseList?
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - VIEW LIFECYCLE
    
    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.setTitle("mobitrainer")
        
        if context != nil
        {
            //  RFR  let showMenu = context!["showMenu"] as! Bool
            
            let showMenuValue = context as! NSDictionary
            let showMenu = showMenuValue["showMenu"] as! Bool

            
            
            
            if showMenu == true
            {
                addMenuItem(with: WKMenuItemIcon.accept, title:"Feito", action: #selector(ExerciseDetailController.menuActionDone))
            }
            else
            {
                clearAllMenuItems()
                
                let contextValue = context as! NSDictionary
                
              //RFR  groupLabel.setBackgroundColor(context!["setColor"] as? UIColor)
                groupLabel.setBackgroundColor(contextValue["setColor"] as? UIColor)
                
            }
            let contextValue = context as! NSDictionary
            elist = contextValue["data"] as? ExerciseList
            lblExerciseName.setText(elist!.name)
            lblExecution.setText(elist!.fullExecution.replacingOccurrences(of: "\\n", with:"\n"))
            lblInstruction.setText(elist!.instruction)
        }
        else
        {
            print("Sem Contexto!")
        }
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
    
    // MARK: - MENU ACTION
    
    func menuActionDone()
    {
        WatchSessionManager.sharedManager.deleteExercise(elist!)
        
        let userInfo : [String : String] = ["exerciseID":elist!.exerciseID, "trainingID":elist!.trainingID ]
        
        WatchSessionManager.sharedManager.transferUserInfo(userInfo as [String : AnyObject])
        
        self.pop()
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO ////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
