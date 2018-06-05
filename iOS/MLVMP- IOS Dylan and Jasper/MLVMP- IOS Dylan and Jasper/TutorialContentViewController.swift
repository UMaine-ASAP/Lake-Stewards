//
//  TutorialContentViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by MIke Scott on 8/11/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController
{
    
    var imageView: UIImageView!
    var pageIndex: Int!
    var titleIndex: String!
    var imageFile: String!
    fileprivate var scrollViewDidScrollOrZoom = false
    var textView = UITextView()
    var swipe = UIButton()
    var largeImageView = UIImageView()
    var button = UIButton()
    var smallImg1 = UIImageView()
    var smallImg2 = UIImageView()
    var smallImg3 = UIImageView()
    var smallImg4 = UIImageView()
    var fromHelp = false
    var dotArray = [UIView]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fromHelp = (self.parent as! TutorialPageViewController).fromHelp
        textView = UITextView(frame: CGRect(x: 20,y: 90, width: 300, height: 110))
        textView.isEditable = false
        //Set up text and images for various pages
        textView.frame.origin.x = (self.view.frame.width/2) - 150
        textView.font = UIFont(name: "Helvetica Neue", size: 20)
        textView.text = "The following pages will explain how to identify phenomena."
        textView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        textView.textColor = UIColor.white
        textView.textAlignment = NSTextAlignment.center
        self.view.addSubview(textView)
        
        let swipeY = UIScreen.main.bounds.height - 150
        swipe = UIButton(frame: CGRect(x: 20,y: swipeY,width: 300,height: 50))
        swipe.frame.origin.x =  (self.view.frame.width/2) - 150
        swipe.setTitle("Swipe to navigate  <", for: UIControlState())
        swipe.backgroundColor = UIColor(white: 1, alpha: 0)
        swipe.setTitleColor(UIColor.white, for: UIControlState())
        self.view.addSubview(swipe)
        
        let imgWidth = UIScreen.main.bounds.width - 40
        largeImageView = UIImageView(frame: CGRect(x: 0,y: 10,width: imgWidth,height: 2*(imgWidth/3)))
        resizeImage(largeImageView, newImageName: "bull_frog1", width: imgWidth, height: CGFloat(2*(imgWidth/3)))
        largeImageView.frame.origin.x = (self.view.frame.width/2) - imgWidth/2
        
        button = UIButton(frame: CGRect(x: 0,y: 0,width: imgWidth,height: imgWidth/4))
        button.backgroundColor = UIColor(red: 50/255, green: 80/255, blue: 50/255, alpha: 1.0)
        button.setTitle("Fauna", for: UIControlState())
        button.frame.origin.y = largeImageView.frame.origin.y + 2*(imgWidth/3)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.frame.origin.x = (self.view.frame.width/2) - imgWidth/2
        
        let arrow = UIImageView(frame: CGRect(x: 0, y: 90, width: 100, height: 100))
        let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "tutorial_arrow", ofType: "png")
        
        if(path != nil)
        {
            arrow.image = UIImage(contentsOfFile: path!)!
        }
        arrow.frame.origin.x = (self.view.frame.width/2) - 50
        
        let nostocLabel = UILabel(frame: CGRect(x: 0,y: 195,width: 100,height: 30))
        nostocLabel.text = "Nostoc"
        nostocLabel.textAlignment = NSTextAlignment.left
        nostocLabel.frame.origin.x = (self.view.frame.width/2)-147
        nostocLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        nostocLabel.textColor = UIColor.white
        nostocLabel.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let x = (self.view.frame.width/2)-147
        let smallImg1 = UIImageView(frame: CGRect(x: x,y: 220,width: 70,height: 70))
        let smallImg2 = UIImageView(frame: CGRect(x: x+75,y: 220,width: 70,height: 70))
        let smallImg3 = UIImageView(frame: CGRect(x: x+150,y: 220,width: 70,height: 70))
        let smallImg4 = UIImageView(frame: CGRect(x: x+225,y: 220,width: 70,height: 70))
        resizeImage(smallImg1, newImageName: "nostoc1", width: 55, height: 55)
        resizeImage(smallImg2, newImageName: "nostoc2", width: 55, height: 55)
        resizeImage(smallImg3, newImageName: "nostoc3", width: 55, height: 55)
        resizeImage(smallImg4, newImageName: "nostoc4", width: 55, height: 55)
        
        let infoLabel = UILabel(frame: CGRect(x: 0,y: 100,width: 100,height: 40))
        let infoButton = UIButton(frame: CGRect(x: 0,y: 100,width: 15,height: 15))
        if(fromHelp){
            infoLabel.text = "Help"
        } else {
            infoLabel.text = "Info"
        }
        
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.frame.origin.x = (self.view.frame.width/2) - 50
        infoButton.frame.origin.x = (self.view.frame.width/2) - 7
        
        let path1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "abt", ofType: "png")
        var image = UIImage()
        
        
        
        if (path1 != nil)
        {
            image = UIImage(contentsOfFile: path1!)!
        }
        infoButton.imageView!.image = image
        infoLabel.font = UIFont(name: "Helvetica Neue", size: 26)
        infoLabel.textColor = UIColor.white
        infoLabel.backgroundColor = UIColor(white: 1, alpha: 0)
       
        //Change contents of page based on index
        switch pageIndex
        {
        case (0):
            textView.text = "The following pages will explain how to identify phenomena."
        case (1):
            textView.text = "Tapping a category allows you to view its corresponding species or sub-categories."
            self.view.addSubview(button)
            self.view.addSubview(largeImageView)
            textView.frame.origin.y =  imgWidth
            textView.textAlignment = NSTextAlignment.left
            swipe.removeFromSuperview()
        case (2):
            textView.text = "Red indicates that a species is invasive."
            resizeImage(largeImageView, newImageName: "common_reed1", width: 340, height: 230)
            button.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0)
            button.setTitle("Common Reed", for: UIControlState())
            self.view.addSubview(button)
            self.view.addSubview(largeImageView)
            textView.frame.origin.y =  imgWidth
            textView.textAlignment = NSTextAlignment.left
            swipe.removeFromSuperview()
        case (3):
            textView.text = "Tapping \"Browse All\" will display categories as a collection of interactive photos."
            textView.textAlignment = NSTextAlignment.left
            button.setTitle("Browse All", for: UIControlState())
            button.frame.origin.y = 10
            textView.frame.origin.y =  imgWidth + 10
            self.view.addSubview(button)
            self.view.addSubview(arrow)
            self.view.addSubview(nostocLabel)
            self.view.addSubview(smallImg1)
            self.view.addSubview(smallImg2)
            self.view.addSubview(smallImg3)
            self.view.addSubview(smallImg4)
            swipe.removeFromSuperview()
        case (4):
            if (!fromHelp)
            {
                textView.text = "Tap the Info button to see these tips again and see information about the people behind the app."
                button.setTitle("Explore Aquatic Phenomena", for: UIControlState())
                self.view.addSubview(infoButton)
            }
            else
            {
                textView.text = "Tap \"Help\" on the Info screen to see this tutorial again."
                button.setTitle("Return to Info", for: UIControlState())
                self.view.addSubview(infoLabel)
            }
            textView.textAlignment = NSTextAlignment.left
            textView.frame.origin.y =  150
            
            
            button.frame.origin.y = UIScreen.main.bounds.height - 200
            if fromHelp
            {
                button.addTarget(self.parent?.parent, action: "back", for: UIControlEvents.touchUpInside)
            }
            else
            {
                button.addTarget(self.parent?.parent, action: "endTutorial", for: UIControlEvents.touchUpInside)
            }
            self.view.addSubview(button)
            swipe.removeFromSuperview()
        default:
            textView.text = "a"
        }
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool {
        return false
    }

    func resizeImage(_ img: UIImageView, newImageName: String, width: CGFloat, height: CGFloat)
    {
        let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
        var image = UIImage()
        
        
        img.contentMode = UIViewContentMode.scaleAspectFit
        if (path != nil)
        {
            image = UIImage(contentsOfFile: path!)!
        }
        
        //Resize image
        let newSize = CGSize(width: width, height: height)
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
            img.image = newImage
        }
        
        
    }
    deinit
    {
        
        
        smallImg1.image = nil
        smallImg2.image = nil
        smallImg3.image = nil
        smallImg4.image = nil
        largeImageView.image = nil
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dotArray[pageIndex].backgroundColor = UIColor(red: 226/255, green: 230/255, blue: 226/255, alpha: 1.0)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        dotArray[pageIndex].backgroundColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
