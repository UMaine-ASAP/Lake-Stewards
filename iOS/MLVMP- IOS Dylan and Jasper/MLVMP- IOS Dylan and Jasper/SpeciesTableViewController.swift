//
//  TableViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by Dylan Landry on 7/13/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

class SpeciesTableViewController: UITableViewController {
    
    
    @IBOutlet weak var info: UIBarButtonItem!
    // MARK: Properties
    
    var locationPicked = Bool()                                             //If location button is clicked
    var jsonNavigator: JsonNavigator = JsonNavigator(json: jsonResponse())  //Navigates through json search tree
    var needToDisplayLocation: Bool = true                                  //if start needsLocation
    var pickedLocation = String()
    var arrayOfCards = [Card]()                                             //Array of Cards representing species / categories
    var notfirstLaunch = true
    var pageViewController = TutorialPageViewController()                   //Governs tutorial that shows on first use after install
    var heights = [CGFloat]()
    override func viewDidLoad() {
        
        
        //Also happens in the advance func.
        jsonNavigator.updateCards()
        arrayOfCards = jsonNavigator.cards                                  //Get new cards
        var index = 0
        
        
        for c in arrayOfCards
        {
            //Get image for card
            var parsedImageName = c.pictureName.components(separatedBy: ".")
            let newImageName: String = parsedImageName[0] as String
            let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
            var image = UIImage()
            
            if(path != nil){
                image = UIImage(contentsOfFile: path!)!
            }
            
            //Ideal proportions
            let wantedwidth = self.view.frame.width - 34
            
            
            //Actual proportions
            let width  = image.size.width
            let height = image.size.height
            
            //Adjust height based on scale
            let scale = wantedwidth/width
            let newheight = height*scale
            heights.append(newheight)
            index += 1

        
        }
        if(locationPicked != false && (locationPicked != true))
        {
            locationPicked = false
        }
        
        super.viewDidLoad()
        
        //Adjust tableview and nav bar appearance
        info.tintColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.bounces = false
        self.tableView.backgroundColor =  UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)]
        self.navigationController!.navigationBar.isTranslucent = false
        let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "backarrow", ofType: "png")
        var image = UIImage()
        
        if (path != nil)
        {
            image = UIImage(contentsOfFile: path!)!
        }
        backButton.isEnabled = true
        backButton.image = image
        
        
        var newJson = [String: AnyObject]()
        if((!(needToDisplayLocation)) && locationPicked)
        {
            
            for var i in (0 ..< arrayOfCards.count)
            {
                
                if(jsonNavigator.json[arrayOfCards[i].name] != nil)
                {
                    
                    newJson = jsonNavigator.json[arrayOfCards[i].name] as! [String : AnyObject]
                    if(!(jsonNavigator.checkAvail(newJson, categoryToCheck: arrayOfCards[i].name)))
                    {
                        arrayOfCards.remove(at: i)
                        i -= 1
                    }
                }
                
            }
            
        }
        
        //If this is first launch, disable buttons and show tutorial
        notfirstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
        if (!notfirstLaunch)
        {   self.navigationItem.rightBarButtonItem!.isEnabled = false
            backButton.isEnabled = false
            self.tableView.isScrollEnabled = false
            
            self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController") as! TutorialPageViewController
            self.pageViewController.view.frame = CGRect(x: 0,y: 0, width:self.view.frame.width, height:self.view.frame.size.height)
            self.addChildViewController(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
            self.pageViewController.didMove(toParentViewController: self)
        }
        
        //Some categories have particular notes associated with them.  These are shown in page controllers
        //If tag is particular categories of algae, display note on category
        let chosenTag = jsonNavigator.orderOfNavigation.last
        if chosenTag == "filamentous mat-forming algae" || chosenTag == "cotton candy-like clouds of algae" || chosenTag == "algae that color the water"
        {
            let note = self.storyboard?.instantiateViewController(withIdentifier: "NotePageViewController") as! NotePageViewController
            note.tag = chosenTag!
            note.view.frame = CGRect(x: 0,y: 0, width:self.view.frame.width, height:self.view.frame.size.height)
            
            self.addChildViewController(note)
            self.view.addSubview(note.view)
            note.didMove(toParentViewController: self)
        }
    }
    
    
    //Remove page controller and enable buttons when tutorial is done.
    func endTutorial()
    {
        self.pageViewController.willMove(toParentViewController: nil)
        self.pageViewController.view.removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        self.tableView.isScrollEnabled = true
        self.navigationItem.rightBarButtonItem!.isEnabled = true
        backButton.isEnabled = true
        UserDefaults.standard.set(true, forKey: "FirstLaunch")
    
    }
    
    //Pop view controller and regress json search when back is pressed
    @IBAction func back(_ sender: AnyObject) {
        
        if(self.title != "Home" )
        {
            SortThread.getSortThread().back()
            if(jsonNavigator.orderOfNavigation.count != 0)
            {
                jsonNavigator.regress()
            }
            
            
        }
        self.navigationController?.popViewController(animated: true)
        
    }

    //Regress json to start and pop view controllers
    func goHome()
    {
        let switchViewController = self.navigationController?.viewControllers[1] as! SpeciesTableViewController
        let times = jsonNavigator.orderOfNavigation.count
        switchViewController.jsonNavigator = JsonNavigator(json: jsonResponse())
        SortThread.getSortThread().resetMatches()
        
        //Regress the json tree search back to start
        for x in 0 ..< times
        {
            jsonNavigator.regress()
        }
        self.navigationController?.popToViewController(switchViewController, animated: true)
        
    }
    
    //Pass jsonNavigator to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        if let destinationVC = segue.destination as? SpeciesTableViewController
        {
            destinationVC.jsonNavigator = jsonNavigator
        }
        
    }
    
   
    @IBOutlet weak var backButton: UIBarButtonItem!

    
    //Occurs when species / category card is pressed
    func pressed(_ sender: UIButton){

        jsonNavigator.updateCards()
        //If card leads to more categories or species
        if(jsonNavigator.pullSpecies == false)
        {
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "SpeciesTableViewController") as! SpeciesTableViewController
            secondViewController.jsonNavigator = self.jsonNavigator
            secondViewController.jsonNavigator.advance(sender.titleLabel!.text!)
            SortThread.getSortThread().addToQueue(sender.titleLabel!.text!.lowercased())
            
            secondViewController.needToDisplayLocation = false
            
            if(locationPicked){
                
                secondViewController.locationPicked = true
                
            }
            
            self.navigationController!.pushViewController(secondViewController, animated: true)
            
        }
            //If card leads to one species
        else
        {
            
            let resultViewController = self.storyboard!.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            resultViewController.jsonNavigator = self.jsonNavigator
            resultViewController.selectedSpeciesName = sender.titleLabel!.text!.lowercased()
            
            var speciesArray = SortThread.getSortThread().retrieveMatches()
            
            //Searches through matches array for the species that pairs with the title of the button and sets the species object in the resultViewController equal to the match.
            
            for index: Int in (0 ..< speciesArray.count){
                
                if(speciesArray[index].name.lowercased() == sender.titleLabel!.text!.lowercased())
                {
                    resultViewController.species = speciesArray[index]
                  
                }
                
        }
        self.navigationController!.pushViewController(resultViewController, animated: true)
        }

    }
    
    
    
    
   
    
    
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     override func numberOfSections(in tableView: UITableView) -> Int
     {
        
        return 1
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        
        
        
        let homeButton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(SpeciesTableViewController.goHome))
        let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "home1", ofType: "png")
        var i = UIImage()
        if(p1 != nil)
        {
            i = UIImage(contentsOfFile: p1!)!
        }
        //Resize image
        let newSize = CGSize(width: 17, height: 15)
        let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
        let imageRef = i.cgImage
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality.high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context?.concatenate(flipVertical)
        // Draw into the context; this scales the image
        context?.draw(imageRef!, in: newRect)
        let newImageRef = context?.makeImage()! as! CGImage
        let newImage = UIImage(cgImage: newImageRef)
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        homeButton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        homeButton.image = newImage
        navigationController!.navigationBar.barTintColor = UIColor(red:0.07, green:0.24, blue:0.07, alpha:1.0)
        
        //handles titles and appearance of buttons
        //Determine nav bar icons to use based on page type
        if(!(jsonNavigator.orderOfNavigation.count == 0 ))
        {
            
            self.title = jsonNavigator.orderOfNavigation.last?.capitalized
            self.navigationItem.setRightBarButton(homeButton, animated: false)
        }
        else{
            
            if(locationPicked == true)
            {
                
                self.title = jsonNavigator.orderOfNavigation.last?.capitalized
                self.navigationItem.setRightBarButton(homeButton, animated: false)
                title = pickedLocation
                
            }
            else
            {

                let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "abt", ofType: "png")
                var i = UIImage()
                if(p1 != nil)
                {
                    i = UIImage(contentsOfFile: p1!)!
                }
                //Resize image
                let newSize = CGSize(width: 15, height: 15)
                let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
                let imageRef = i.cgImage
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
                let context = UIGraphicsGetCurrentContext()
                // Set the quality level to use when rescaling
                context!.interpolationQuality = CGInterpolationQuality.high
                let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
                context?.concatenate(flipVertical)
                // Draw into the context; this scales the image
                context?.draw(imageRef!, in: newRect)
                let newImageRef = context?.makeImage()! as! CGImage
                let newImage = UIImage(cgImage: newImageRef)
                // Get the resized image from the context and a UIImage
                UIGraphicsEndImageContext()
                info.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
                info.image = newImage
                    self.navigationItem.rightBarButtonItem = info
                self.title = "Home"
            }
        }
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()

    }
    
    //Return number of cards as number of rows (+1 for browse button)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        jsonNavigator.updateCards()
        return arrayOfCards.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Get # of cells in tableview
        let maxRows = tableView.numberOfRows(inSection: 0)
        
        //If cell is not last
        if(indexPath.item != (maxRows - 1))
        {
            
            let cellIdentifier = "tableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
            let cellButton = cell.speciesUIButton
            
            cellButton?.addTarget(self, action: #selector(SpeciesTableViewController.pressed(_:)), for: UIControlEvents.touchUpInside)
            //Fetches the appropriate species for the data source layout.
            cell.buttonView.layer.shadowColor = UIColor.black.cgColor
                        cell.buttonView.layer.shadowOffset = CGSize(width: 0, height: 4)
                        cell.buttonView.layer.shadowRadius = 5
                        cell.buttonView.layer.shadowOpacity = 1.0
                        cell.buttonView.layer.masksToBounds = false
            jsonNavigator.updateCards()
            let thisCard = arrayOfCards[indexPath.row]
            thisCard.name = thisCard.name.capitalized
            
            //Create title label for species / category
            let attributedString = NSMutableAttributedString(string: thisCard.name)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
            cellButton?.titleLabel!.frame = CGRect(x: 0, y: 20, width: (cellButton?.frame.width)!, height: 20)
            cellButton?.setTitle(thisCard.name, for: UIControlState())
           
            //Adjust button size based on device size
            let wantedwidth = self.view.frame.width - 34
            let scale = wantedwidth/341
            
            let h = cell.speciesImageView.frame.height
            var k = cell.speciesUIButton.titleEdgeInsets
            if !(h == 223)
            {
               
                    cell.buttonBottomY.constant = scale*11
                    k.bottom = 223 - h
                
            }
            else
            {
                k.bottom = 0
            }
            cell.buttonY.constant = 0
            cell.speciesUIButton.titleEdgeInsets = k
            cell.speciesUIButton.titleLabel!.text = thisCard.name
            
            //Color button based on species invasive status
            if(thisCard.invasive == true)
            {
                cell.buttonView.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1)
            }
            else
            {
                cell.buttonView.backgroundColor = UIColor(red: 0.196, green: 0.322, blue: 0.196, alpha: 1)
            }
            cell.speciesUIButton.titleLabel!.textAlignment = .center
            
            //Get species / category image
            var parsedImageName = thisCard.pictureName.components(separatedBy: ".")
            let newImageName: String = parsedImageName[0] as String
            let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
            var image = UIImage()
            if(path != nil)
            {
                image = UIImage(contentsOfFile: path!)!
            }
            cell.speciesImageView.image = image
            
            //Add text to first cell on home page
            if (title == "Home" && indexPath.row == 0)
            {
                
                let speciesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
                speciesLabel.backgroundColor = UIColor(white: 1, alpha: 0)
                let attributes = [NSForegroundColorAttributeName: UIColor(red: 0, green: 40/255, blue: 0, alpha: 1.0),  NSFontAttributeName: UIFont(name: "Arial-BoldItalicMT", size: 17.0)!]
                let finalString = NSMutableAttributedString(string: "Browse Aquatic Phenomena by Type", attributes: attributes)
                speciesLabel.attributedText = finalString
                speciesLabel.textAlignment = NSTextAlignment.center
                //Add space to top of cell for text
                cell.buttonY.constant = 40
                cell.imageY.constant = 40
                cell.addSubview(speciesLabel)
                k.bottom = 223 - h - 10
                cell.speciesUIButton.titleEdgeInsets = k
                
            }
            return cell
        }
        else    //If it is the last cell, it must be either the location cell on the home page or the browse cell
        {
            //If location cell
            if(needToDisplayLocation)
            {
                let cellIdentifier = "Location Cell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LocationCell
                let cellButton = cell.locationButton
                cell.locationButtonView.layer.shadowColor = UIColor.black.cgColor
                cell.locationButtonView.layer.shadowOffset = CGSize(width: 0, height: 4)
                cell.locationButtonView.layer.shadowRadius = 5
                cell.locationButtonView.layer.shadowOpacity = 1.0
                cell.locationButtonView.layer.masksToBounds = false
                
                //Add text and set up press function
                cellButton?.addTarget(self, action: #selector(SpeciesTableViewController.pressedLocationButton(_:)), for: UIControlEvents.touchUpInside)
                let speciesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
                speciesLabel.backgroundColor = UIColor(white: 1, alpha: 0)
                let attributes = [NSForegroundColorAttributeName: UIColor(red: 0, green: 40/255, blue: 0, alpha: 1.0),  NSFontAttributeName: UIFont(name: "Arial-BoldItalicMT", size: 17.0)!]
                let finalString = NSMutableAttributedString(string: "Or Browse by Location", attributes: attributes)
                speciesLabel.attributedText = finalString
                speciesLabel.textAlignment = NSTextAlignment.center
                
                let attributes2 = [NSForegroundColorAttributeName: UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0),  NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 22.0)!]
                let finalString2 = NSMutableAttributedString(string: "Location", attributes: attributes2)
                cellButton?.setAttributedTitle(finalString2, for: UIControlState())
                cellButton?.titleEdgeInsets.bottom = (0 - (cellButton?.frame.height)!) + 40
                cell.addSubview(speciesLabel)
                
                return cell
            }
            //Otherwise it must be a browse cell
            else
            {
                let cellIdentifier = "Browse Cell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BrowseTableViewCell
                cell.browseButton.addTarget(self, action: #selector(SpeciesTableViewController.pressedBrowse(_:)), for: UIControlEvents.touchUpInside)
                return cell
                
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = self.view.frame.width - 34
        let scale = width/341
        
        let locationHeight = 357*scale
        //Give extra room to first and last cells on home page for text
        if ((title == "Home") && ((indexPath.item == 0) || (indexPath.item == 3)))
        {
            if (indexPath.row < heights.count)
            {
            return heights[indexPath.row] + 130
            }
            else
            {
                return locationHeight
            }
        }
        else
        {   //Adjust cell height according to adjust values calculated earlier
            if (indexPath.row < heights.count)
            {
                return heights[indexPath.row] + 90
            }
            else
            {
                return locationHeight
            }

        }
    }

    
    
    func pressedBrowse(_ sender: UIButton)
    {
        //Send current category data to browse table view controller and go there
        let browseTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "BrowseTableViewController") as! BrowseTableViewController
        if let pt = jsonNavigator.orderOfNavigation.last?.capitalized
        {
            browseTableViewController.title = pt
        }
        browseTableViewController.jsonNavigator = jsonNavigator
        self.navigationController!.pushViewController(browseTableViewController, animated: true)

    }
    
    //Go to location view controller if location button is pressed
    @IBAction func pressedLocationButton(_ sender: UIButton) {
        
        let locationViewController = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController2
        
        self.navigationController!.pushViewController(locationViewController, animated: true)
        
    }
    
    
    //Keep device portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool
    {
       return UIInterfaceOrientationIsLandscape(interfaceOrientation)
    }
    

    
}

