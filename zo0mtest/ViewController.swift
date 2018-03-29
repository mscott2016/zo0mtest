//
//  ViewController.swift
//  zo0mtest
//
//  Created by Marley on 3/6/18.
//  Copyright © 2018 Mar Z Mar. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit
///
// this create a way to zoom on double touch and pin gesture //
///

class thumbnailImage : NSObject // object for video and images
{
    var images : UIImageView?
    var video : AVAsset?
    var isImage : Bool?
    
    override init() {
        
    }
    init (image: UIImageView) {
        images = image
        isImage = true
    }
    init (vides: AVAsset) {  // assest of a video
        video = vides
        isImage = false
    }
    
    func getIsIamge ()-> Bool
    {
        return isImage ?? false
    }
    
    
    
}

class ViewController : UIViewController{
    
    
    @IBOutlet weak var getButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getButton.addTarget(self, action: #selector(prestentsViews),
                            for: .touchUpInside) // this adds an action to the button
    }
    
    @objc func prestentsViews ()
    {
        let zoomZiew = newZoomView()
        present(zoomZiew, animated: true, completion: nil) // calls new view
    }
}
class newZoomView: UIViewController , UIScrollViewDelegate {

    // vars of images and scrolls for the view
    lazy var deleteButton: UIButton = {
        let pinn = UIButton()
        pinn.translatesAutoresizingMaskIntoConstraints = false
        pinn.backgroundColor = .clear
        pinn.layer.cornerRadius = 7
        pinn.layer.masksToBounds = true
        pinn.setImage(#imageLiteral(resourceName: "DELETE2.0"), for: .normal)
        return pinn
    }()
    lazy var scrolVoew: UIScrollView = {
        let pinn = UIScrollView()
        pinn.translatesAutoresizingMaskIntoConstraints = false
        pinn.maximumZoomScale = 5
        pinn.minimumZoomScale = 1
        pinn.delegate = self
        return pinn
    }()
    
    lazy var oButton: UIButton = {  // this is not shown
        let pinn = UIButton()
        pinn.translatesAutoresizingMaskIntoConstraints = false
        pinn.layer.cornerRadius = 20
        pinn.layer.masksToBounds = true
        pinn.backgroundColor = .blue
        pinn.setImage(#imageLiteral(resourceName: "OvalForclose"), for: .normal)
        return pinn
    }()
   
    func addButtons()
    {
        scrollImg.addSubview(oButton) // adds them to scrolls
        scrollImg.addSubview(deleteButton)
       
        
        oButton.layer.zPosition = 26
        deleteButton.layer.zPosition = 23 // set position depth
        
        
        
        oButton.topAnchor.constraint(equalTo: scrollImg.topAnchor, constant:  24).isActive = true // creating constrains for two buttons need to add them to the veiw
        oButton.rightAnchor.constraint(equalTo: scrollImg.rightAnchor, constant: 12).isActive = true
        deleteButton.topAnchor.constraint(equalTo: scrollImg.topAnchor, constant:  24).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: scrollImg.leftAnchor, constant: 12).isActive = true
        oButton.isUserInteractionEnabled = true
        deleteButton.isUserInteractionEnabled = true
        oButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
         deleteButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
  var scrollImg: UIScrollView!
    lazy var  images: UIImageView = {
        let pinn = UIImageView()
        pinn.backgroundColor = .white
        pinn.image = #imageLiteral(resourceName: "lokk")
        return pinn
    }()
    
    @objc func handleCancel() {
       print("fj") // checks to see if called
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        scrollImg = UIScrollView()
    scrollImg.delegate = self
    scrollImg.alwaysBounceVertical = false
    scrollImg.alwaysBounceHorizontal = false
    scrollImg.showsVerticalScrollIndicator = true
    scrollImg.flashScrollIndicators()
    
    scrollImg.minimumZoomScale = 1.0
    scrollImg.maximumZoomScale = 3.0
    
    let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
    doubleTapGest.numberOfTapsRequired = 2
    scrollImg.addGestureRecognizer(doubleTapGest)
    
    self.view.addSubview(scrollImg)
    scrollImg.layer.zPosition = -10
   
        
    scrollImg.addSubview(images)
        
    self.scrollImg.delaysContentTouches = true
    scrollImg.canCancelContentTouches = true
   
    addButtons() // adds the new buttons to scoll view
    images.contentMode = .scaleAspectFit
}
   
    @objc func handleDoubleTapScrollView(recognizer:   UITapGestureRecognizer) { // this is the zoom function
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)   // set scroll to normal
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = images.frame.size.height / scale //  cuts the height but the scale factor
        zoomRect.size.width  = images.frame.size.width  / scale // same for the width
        let newCenter = images.convert(center, from: scrollImg) // creates new center of image from param value
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0) // subtracts the size and creates a new center with the origins of x
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.images // needed function for scrollView
    }
    
    override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
        scrollImg.frame = self.view.bounds   // finds bounds and assigns
        images.frame = self.view.bounds     // same with image
    }
    
    
}

