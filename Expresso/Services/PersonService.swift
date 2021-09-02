//
//  PersonService.swift
//  Expresso
//
//  Created by Jessi Febria on 02/05/21.
//

import CoreData
import UIKit

class PersonService {
  
    func savePerson(name: String, image: UIImage){
        let person = Person(context: ContextService.context)
        print(getLastId())
        let currId = getLastId() + 1
        person.id = Int16(currId)
        person.name = name
        
        ContextService.saveChanges()
        
        ImageService.saveImage(id: currId, image: image)
    }
    
    func deletePerson(person : Person){
        ImageService.deleteImage(id: Int(person.id))
        ContextService.deletePerson(person: person)
    }
    
    func getPersonById(id : Int) -> Person{
        let request : NSFetchRequest<Person> = Person.fetchRequest()
        
        request.predicate = NSPredicate(format: "id MATCHES %@", id)
        
        return ContextService.loadPerson(request: request)[0]
    }
    
    func getLastId() -> Int {
        let allPerson = getAllPerson()
        return Int(allPerson[allPerson.count - 1].id)
    }
    
    func getAllPerson() -> [Person] {
        let request : NSFetchRequest<Person> = Person.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        return ContextService.loadPerson(request: request)
    }
    
    func searchPerson(keyword : String) -> [Person] {
        let request : NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", keyword)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        print("REQUEST SEARCHING")
        
        return ContextService.loadPerson(request: request)
    }
    
}
