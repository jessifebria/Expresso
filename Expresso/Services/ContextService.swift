//
//  ContextService.swift
//  Expresso
//
//  Created by Jessi Febria on 02/05/21.
//

import CoreData
import UIKit

class ContextService {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    static func saveChanges(){
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("error saving changes context")
            }
        }
    }
    
    static func loadPerson(request : NSFetchRequest<Person>) -> [Person]{
        
        do {
            return try context.fetch(request)
        } catch  {
            print("error fetching person")
        }
        
        return []
    }
    
    static func deletePerson(person : Person) {
        context.delete(person)
        saveChanges()
    }
    
}
