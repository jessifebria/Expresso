//
//  ImageService.swift
//  Expresso
//
//  Created by Jessi Febria on 01/05/21.
//

import UIKit

class ImageService {
    
    static func getDocumentURL() -> URL {
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return storeURL
    }
    
    static func deleteImage(id: Int) {
        let documentURL = getDocumentURL()
        let name = String(id)+".png"
        let imageURL = documentURL.appendingPathComponent(name)
        
        do{
            try FileManager.default.removeItem(atPath: imageURL.path)
            print("Image deleted")
        }catch {
            print("File is not deleted, not found")
        }
    }
    
    static func saveImage(id : Int, image : UIImage) {
        let documentURL = getDocumentURL()
        let name = String(id)+".png"
        let imageURL = documentURL.appendingPathComponent(name)
        
        print(imageURL)
        
        do{
            try FileManager.default.removeItem(atPath: imageURL.path)
        }catch {
            print("File is not deleted, not found")
        }
        
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        
        
        do {
            try data.write(to: imageURL)
        } catch {
            print("failed save image")
        }
        
        
    }
    
    static func getImage(id: Int) -> UIImage? {
        let documentURL = getDocumentURL()
        let name = String(id)+".png"
        
        if let imageURL = try? documentURL.appendingPathComponent(name) {
            print(imageURL)
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
        
    }
    
    static func deleteImage(id: Int) {
        let documentURL = getDocumentURL()
        let name = String(id)+".png"
        let imageURL = documentURL.appendingPathComponent(name)
        
        do{
            try FileManager.default.removeItem(atPath: imageURL.path)
            print("Image deleted")
        }catch {
            print("File is not deleted, not found")
        }
    }
    
}
