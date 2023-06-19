//
//  FileManager.swift
//  JobHunt
//
//  Created by User on 12/04/2023.
//

import UIKit


enum MImgType {
    case profile
    case resume
}


class MFileManager {
    static let shared = MFileManager()
    private init() {}
    
    private var rFileName: String  { return "My-Resume" }
    private var pFileName: String  { return "My-Profile" }
    
    
    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return documentDirectory[0]
    }
    
    private func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        
        return nil
    }
    
    
    func read(type: MImgType) -> (img: UIImage?, url: URL?) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = rFileName
        let docURL = documentDirectory.appendingPathComponent("\(fileName).png")
        
        let image = UIImage(contentsOfFile: docURL.absoluteString)
        
        return (img: image, url: docURL)
    }
    
    func readImage(type: MImgType) -> UIImage? {
        let fileName = type == .resume ? rFileName : pFileName
        guard let filePath = append(toPath: documentDirectory(), withPathComponent: "\(fileName).png") else { return nil }
        
        let image = UIImage(contentsOfFile: filePath)
        
        return image
    }
    
    
    func savePNG(data: Data, type: MImgType) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = type == .resume ? rFileName : pFileName
        let docURL = documentDirectory.appendingPathComponent("\(fileName).png")

        do {
           try data.write(to: docURL)
        } catch {
            print(error.localizedDescription)
        }
        
        return docURL
    }
}
