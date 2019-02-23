//
//  CoreDataHandler.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/23/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHandler {

   static func inset(entityName : String , entityData : [String : AnyObject] )->Bool{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // unique Data
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            let dataInfo = NSManagedObject(entity: entity, insertInto: context)
            dataInfo.setValuesForKeys(entityData)
            do {
                try context.save()
                return true
            } catch {
                print("Failed saving")
            }
        }
   


        
        return false
    }
    
    static func featchData (entityName : String ) -> Any? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let result = try context.fetch(request)
            if let data = result as? [NSManagedObject] {
                let jsonData = self.convertToJSONArray(mangedObjectArray: data)
                return jsonData
            }
            
        } catch let caught as NSError{
            
            print("Failed " , caught.localizedDescription)
        }
        
        
        return nil
    }
    
    
    private static func convertToJSONArray(mangedObjectArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in mangedObjectArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
    
    
    
}
