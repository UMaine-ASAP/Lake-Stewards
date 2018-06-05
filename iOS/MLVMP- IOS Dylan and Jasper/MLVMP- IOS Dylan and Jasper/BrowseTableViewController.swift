

//
//  BrowseTableViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by MIke Scott on 8/11/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

let reuseTableViewCellIdentifier = "TableViewCell"
let reuseCollectionViewCellIdentifier = "CollectionViewCell"

class BrowseTableViewController: UITableViewController
{
    var jsonNavigator: JsonNavigator = JsonNavigator(json: jsonResponse())
    var matches: [Species]!
    var sourceArray: NSMutableArray!
    var contentOffsetDictionary: NSMutableDictionary!
    var window: UIWindow?
    var root: UINavigationController?
    var darkGreen = UIColor(red: 0/255, green: 40/255, blue: 0/255, alpha: 1.0)
    var photoList = [String]()
    var photos = [[UIImage]]()

    override func viewDidLoad() {
        matches = SortThread.getSortThread().retrieveMatches()
        
       
       
        
        //On separate thread, go through all pictures of all species and put them in tableview
                
                
            DispatchQueue.global().async {
            
        
                //Matches for other aquatic curiosities have certain order
                if self.title != "Other Aquatic Curiosities"
                {   self.matches.sort { return $0.name < $1.name}
                }
                //otherwise Get Matches and sort alphabetically
                else
                {
                    self.matches.sort { return $0.order < $1.order}
                }
                for var x in (0 ..< self.matches.count)
                {   let s = self.matches[x]
                    if let pics = s.pictures
                    {   var picList = [UIImage]()
                        for var y in (0 ..< pics.count)
                        {
                            let p = pics[y]
                            var parsedImageName = p.components(separatedBy: ".")
                            let newImageName: String = parsedImageName[0] as String
                            let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
                            var image = UIImage()
                            let imageView = UIImageView()
                            imageView.frame = CGRect(x: 0,y: 0,width: 91,height: 91)
                            imageView.contentMode = UIViewContentMode.scaleAspectFit
                            if (path != nil)
                            {
                                image = UIImage(contentsOfFile: path!)!
                            }
                            
                            //Resize image
                            let newSize = CGSize(width: 55, height: 55)
                            let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
                            let imageRef = image.cgImage
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
                            
                            //let image = UIImage(named: imageName as! String)
                            if (path != nil)
                            {
                                image = newImage
                                
                            }
                            else
                            {
                                imageView.image = UIImage(named: "fragrant_waterlily5")
                                
                            }
                            
                            picList.append(image)
                        }
                        self.photos.append(picList)
                        
                    }
                }
                
        }

        
        
        
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //Set up tableView
        self.tableView.register(BrowseTableViewCell2.self, forCellReuseIdentifier: reuseTableViewCellIdentifier)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.contentOffsetDictionary = NSMutableDictionary()
        tableView.backgroundColor = UIColor(red: 0.792, green: 0.769, blue: 0.694, alpha: 1)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let numberOfTableViewRows: NSInteger = matches.count            //Number of species = number of rows
        let numberOfCollectionViewCells: NSInteger = 20                 //Max number of pictures for each species
        
        
        let speciesArray = NSMutableArray(capacity: numberOfCollectionViewCells)
        for tableViewRow in (0 ..< numberOfTableViewRows)
        {                                                               //Loops through species and creates array of arrays containing species pictures
            let pictureArray: NSMutableArray = NSMutableArray(capacity: numberOfCollectionViewCells)
            for var collectionViewItem in  (0 ..< matches[tableViewRow].pictures!.count)
            {
                pictureArray.add(matches[tableViewRow].pictures![collectionViewItem])
            }
            speciesArray .add(pictureArray)
        }
        //Create Navigation items
        let homeButton = UIBarButtonItem(title: "Home", style: .plain , target: self, action: #selector(BrowseTableViewController.goHome))
        homeButton.tintColor = UIColor.white
        self.navigationItem.setRightBarButton(homeButton, animated: false)
        let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "backarrow", ofType: "png")
        var i = UIImage()
        if(p1 != nil)
        {
            
            i = UIImage(contentsOfFile: p1!)!
            
            
        }
        let backbutton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(BrowseTableViewController.back))
        backbutton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        backbutton.image = i
        self.navigationItem.setLeftBarButton(backbutton, animated: false)
                self.sourceArray = speciesArray
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
    }
    
    //Go to home page
    func goHome()
    {
        
        let switchViewController = self.navigationController?.viewControllers[1] as! SpeciesTableViewController
        let times = jsonNavigator.orderOfNavigation.count
        switchViewController.jsonNavigator = JsonNavigator(json: jsonResponse())
        SortThread.getSortThread().resetMatches()
        
        for x in (0 ..< times)
        {
            jsonNavigator.regress()
        }
        self.navigationController?.popToViewController(switchViewController, animated: true)

    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        let homeButton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(BrowseTableViewController.goHome))
        
        let p2 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "home1", ofType: "png")
        var i = UIImage()
        if(p2 != nil)
        {
            
            i = UIImage(contentsOfFile: p2!)!
            
            
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
        let newImageRef = context!.makeImage()! as CGImage
        let newImage = UIImage(cgImage: newImageRef)
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        
        //let image = UIImage(named: imageName as! String)
        
        
        
        
        
        
        
        homeButton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        homeButton.image = newImage

        self.navigationItem.setRightBarButton(homeButton, animated: false)

    }
    
   func back()
   {
    self.navigationController?.popViewController(animated: true)
    }
}

//
// MARK: - Table view data source
//
//
//
extension BrowseTableViewController
{
    //Returns # of table rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {return self.sourceArray.count}
    
    //Generates cell and corresponding label
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = (tableView.dequeueReusableCell(withIdentifier: reuseTableViewCellIdentifier, for: indexPath) as! BrowseTableViewCell2)
        
        let maximumLabelSize: CGSize = CGSize(width: view.bounds.width-5, height: 150)
        let labelRect: CGRect = (matches[indexPath.item].name as NSString).boundingRect(with: maximumLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
        let leftIndent: CGFloat = 5
        let speciesLabel = UILabel(frame: CGRect(x: leftIndent, y: cell.frame.origin.y, width: labelRect.width, height: labelRect.height))
        speciesLabel.numberOfLines = 0
        speciesLabel.textColor = darkGreen                              //Need to change invasive species to red
        speciesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        speciesLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        speciesLabel.text = matches[indexPath.item].name
        
        if(matches[indexPath.item].invasive != nil){
            speciesLabel.textColor = UIColor.red
        }
        
        tableView.addSubview(speciesLabel)
        
        
        cell.backgroundColor = UIColor(red: 226.0/255, green: 230.0/255, blue: 226.0/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 226.0/255, green: 230.0/255, blue: 226.0/255, alpha: 1.0)
        return cell
    }
    
    //Set up cell
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let collectionCell: BrowseTableViewCell2 = cell as! BrowseTableViewCell2
        collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
        let index: NSInteger = collectionCell.collectionView.tag
        let value: AnyObject? = self.contentOffsetDictionary.value(forKey: index.description) as AnyObject
        //let horizontalOffset: CGFloat = CGFloat(value != nil ? value!.floatValue : 0)
        //collectionCell.collectionView.setContentOffset(CGPoint(x: horizontalOffset, y: 0), animated: false)
    }
    
    //Determines row height based on # of pictures divided by four per row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {   let imageLength = (UIScreen.main.bounds.width-12)/4
        let value = (sourceArray[indexPath.item] as AnyObject).count
        let fractionNum = Double(value!) / 4.0
        let roundedNum = Int(ceil(fractionNum))
        let height = (CGFloat(roundedNum) * imageLength) + 40
        return CGFloat(height)
    }
}
// MARK: - Collection View Data source and Delegate
extension BrowseTableViewController:UICollectionViewDataSource,UICollectionViewDelegate
{
    //Gets number of items based on number of pictures
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let collectionViewArray: NSArray = self.sourceArray[collectionView.tag] as! NSArray
        return collectionViewArray.count
    }
    
    //Get correct collectionview cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: UICollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewCellIdentifier, for: indexPath) )
      let  subviews = cell.subviews
        if (indexPath.item == 0)
        {
            for subview in subviews
            {
                subview.removeFromSuperview()
            }
        }
        var image = UIImage()
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0,y: 0,width: 91,height: 91)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        //Get correct image
        var imagegot = false
        if (self.photos.count >= collectionView.tag+1)
        {
            if self.photos[collectionView.tag].count >= indexPath.item+1
            {
                image = (self.photos[collectionView.tag])[indexPath.item]
                imagegot = true
            }
        }
        if !imagegot
        {
            let collectionViewArray = self.sourceArray[collectionView.tag] as! NSArray
            var parsedImageName = (collectionViewArray[indexPath.item] as AnyObject).components(separatedBy: ".")
            let newImageName: String = parsedImageName[0] 
            let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
            
            
            if (path != nil)
            {
                image = UIImage(contentsOfFile: path!)!
            }
            
            //Resize image
            let newSize = CGSize(width: 55, height: 55)
            let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
            let imageRef = image.cgImage
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
            
            //let image = UIImage(named: imageName as! String)
            if (path != nil)
            {
                imageView.image = newImage
                cell.backgroundView = imageView
            }
            else
            {
                imageView.image = UIImage(named: "fragrant_waterlily5")
                
            }
        }
        else
        {
            imageView.image = image
            cell.backgroundView = imageView
            
        }
        return cell
        
    }

    //Go to slideshow view if photo is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "BrowseSlideshowViewController") as! BrowseSlideshowViewController
        vc.title = title
        vc.speciesIndex = collectionView.tag
        vc.speciesList = matches
        vc.species = matches[collectionView.tag]
        vc.startIndex = indexPath.item
        vc.jsonNavigator = jsonNavigator
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
        
    }
    
    //Handles scrolling
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !scrollView.isKind(of: UICollectionView.self)
        {
            return
        }
        let horizontalOffset: CGFloat = scrollView.contentOffset.x
        let collectionView: UICollectionView = scrollView as! UICollectionView
        self.contentOffsetDictionary.setValue(horizontalOffset, forKey: collectionView.tag.description)
    }
}

