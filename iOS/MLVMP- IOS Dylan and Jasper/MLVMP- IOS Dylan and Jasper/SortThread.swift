//
//  SortThread.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by Administrator on 6/18/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import Foundation


class SortThread: NSObject {
    var species = [Species]()
    var matches = [Species]()
    var misMatches = [Species]()
    var stackOfMismatches = Stack<[Species]>()
    var pTagQueueCount = 0
    var corruptJsons = 0
    
    static var globalSortThread: SortThread?
    var sortThread: Thread?

    static func getSortThread() -> SortThread{
        if(globalSortThread==nil){
            globalSortThread = SortThread()
            globalSortThread?.sortThread = Thread(target: globalSortThread!, selector: #selector(SortThread.doStuff(_:)), object: nil)
        }
        return globalSortThread!
    }
    
    func getThread() -> Thread{
        return sortThread!
    }
    
     let lockQueue = DispatchQueue(label: "com.asap.LockQueue", attributes: [])
     var tagQueue: Array<String> = [];

     func addToQueue(_ tag: String){
        
        lockQueue.sync {
            self.tagQueue.append(tag)
            
            
        }
    }
    
     func retrieveMatches() -> [Species]{
        var tempMatches = [Species]()
        
        lockQueue.sync{
            
        tempMatches = self.matches
        }
        
        return tempMatches
    }
    
    func back(){
        
        
        lockQueue.sync{
            
        }
    
        if(self.stackOfMismatches.items.count != 0){
        
            var tempArray = self.stackOfMismatches.pop() as [Species]
            
        
            for i in (0 ..< tempArray.count){

                self.matches.append(tempArray[i])
            
        }
            
            
    }
}
    
    
    func resetMatches(){
        lockQueue.sync{
            
        }

        if(self.stackOfMismatches.items.count != 0){

            let stackedArrays = self.stackOfMismatches.items.count
            
            for index in (0 ..< stackedArrays){
                var tempArray = self.stackOfMismatches.pop() as [Species]

                for index2 in (0 ..< tempArray.count){

                    
                    self.matches.append(tempArray[index2])

                }
                
            }
            
        }
        
        
    }
    
    func jsonSpeciesResponse(_ location: String) -> [String : AnyObject] {
        let path = Bundle.main.path(forResource: "species JSON files (updated/" + location, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: NSData.ReadingOptions.uncached)
        let json: AnyObject! = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        
        if(!(json == nil)){
        return json as! [String : AnyObject]
        }else{
            return ["key":"value" as AnyObject]
        }
    }
    
   func doStuff(_ o: AnyObject?){
        
        //Sets up path to folder containing species json files.----------
        var error: NSError? = nil
        let mainBundle: Bundle = Bundle.main
        //Adjusts resource path name to designated folder.
        let pathToSpeciesJsonFiles: String = (mainBundle.resourcePath! as NSString).appendingPathComponent("species JSON files (updated")
        let defaultManager = FileManager()
        //Stores the names of files in the designated folder in a String array.
        let speciesJsonFiles: NSArray = try! defaultManager.contentsOfDirectory(atPath: pathToSpeciesJsonFiles) as NSArray
    
        for index in (1 ..< speciesJsonFiles.count){
            
            //Grabs json file name and parses out the file type extension.
            var parsedSpeciesName = (speciesJsonFiles[index] as AnyObject).components(separatedBy: ".")
            //First index (0) would be the name of the species while the second (1) is the file type extension.
            let speciesFileName: String = parsedSpeciesName[0] 
            //Creates an AnyObject array with String Keys (dictionary) and stores the appropriate species json file within.
            var speciesJsonFile = [String : AnyObject]()
            speciesJsonFile = jsonSpeciesResponse(speciesFileName)
            
            //JsonSpeciesResponse will return a dictionary with less than 3 keys if the json file returns nil. Json files that return nil contain invsibile characters which disrupt parsing. These files must be fixed.
            if(speciesJsonFile.count > 3){
            //Parses appropriate json file into species class parameters.
                
                
                
                //Name
                let speciesName = speciesJsonFile["name"] as! String
                
                //Optional scientific name.
                var scientificName: String? = String()
                if(!(speciesJsonFile["scientific name"] == nil)){
                    scientificName = speciesJsonFile["scientific name"] as? String
                  
                }else{
                    scientificName = nil
                }
                
                //Species tag.
                let targetSpeciesTags = speciesJsonFile["tags"] as! [String]
                
                //Species pictures.
                let targetSpeciesPictureNames = speciesJsonFile["pictures"] as! [String]
              
                
                //Grabs information dictionary within each species json file.
                var informationDictionary = [String : AnyObject]()
                informationDictionary = speciesJsonFile["information"] as! [String : AnyObject]
                var info = [informationSectionObject]()
                for section in informationDictionary
                {   let sectionName = section.0
                    let sectionParser = section.1 as! NSArray
                    var sectionArray = [String]()
                    
                    for bullet in sectionParser
                    {
                        sectionArray.append(bullet as! String)
                    }
                    let newSection = informationSectionObject(title: sectionName, bullets: sectionArray)
                    info.append(newSection)
                }
                info.sort { return $0.order < $1.order}
                
                
                
                
                
                //Optional invasive.
                var invasive: [String]? = [String]()
                if(!(informationDictionary["Invasive"] == nil)){
                    
                    
                    
                    invasive = informationDictionary["Invasive"] as? [String]
                    
                    invasive!.append("Invasive")
                    
                }else{
                    invasive = nil
                }
                
                
                //Creates species class from json parsed information.
                self.species.append(Species(name: speciesName,
                    scientificName: scientificName,
                    tags: targetSpeciesTags,
                    pictures: targetSpeciesPictureNames,
                    invasive: invasive, information: info))
                
            } else{
                corruptJsons += 1
                
            }
            
        }
    
        
        for index in (0 ..< self.species.count){
            self.matches.append(species[index])
        }
        
        while(true){
            self.lockQueue.sync {
                
                if(self.tagQueue.count == 1){

                    for var index in (0..<self.matches.count) {
                        var matched = false
                        
                        print("HERE: \(self.matches)")
                    
                        for index2 in (0 ..< self.matches[index].tags.count){
                        
                            if(self.matches[index].tags[index2] == self.tagQueue.last){
                                matched = true
                                

                                
                            }
                        }
                    
                        
                        if(matched == false){
                            self.misMatches.append(self.matches[index])
                            self.matches.remove(at: index)
                            index -= 1
                        }
                    
                    
                    }
                    
                self.stackOfMismatches.push(self.misMatches)
                self.misMatches.removeAll(keepingCapacity: false)
                self.tagQueue.remove(at: 0)
                
                }
                
            }
        }
    }
}

struct Stack<T> {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
}
