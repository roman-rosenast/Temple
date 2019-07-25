//
//  BuildViewController.swift
//  Temple
//
//  Created by Roman Rosenast on 6/4/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BuildViewController: UIViewController  {

    @IBOutlet weak var modalWindow: UIView!
    @IBOutlet weak var scrollContainer: UIView!
    
    var pillarData: [Pillar]?
    var dailyChecklist: [Bool]?
    var streaks: [Int]?
    var templeNumber: Int?
    
    var templesComplete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupImageScrollview()
    }
    
    func applyStyles() {
        modalWindow.layer.cornerRadius = 8
        modalWindow.clipsToBounds = true
    }
    
    func setupImageScrollview() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollContainer.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: scrollContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: scrollContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: scrollContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: scrollContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
    
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40.0
        scrollView.addSubview(stackView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    
        for iterator in 1...NUMBER_OF_TEMPLES {
            if (iterator < templeNumber!) {
                stackView.addArrangedSubview(image("Temple\(iterator)-Thumbnail"))
            } else {
                stackView.addArrangedSubview(image("Temple\(iterator)-Thumbnail", grayed: true))
            }
        }
        stackView.addArrangedSubview(image("MoreTemplesComingSoon", grayed: true))
    }
    
    func image(_ filename: String, grayed: Bool = false) -> UIImageView {
        var img = UIImage(named: filename)
        if grayed {
            img = UIImage(named: filename)!.convertToGrayScale().alpha(0.25)
        }
        
        let imgView = UIImageView(image: img)
        
        let width = scrollContainer.frame.width
        var height = scrollContainer.frame.width
        
        let imgWidth = img!.size.width
        let imgHeight = img!.size.height
        height = height*(imgHeight/imgWidth)
        
        imgView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: height).isActive = true

        return imgView
    }
    
    @IBAction func dismissBuildVC(_ sender: Any) {
        performSegue(withIdentifier: "hideBuildModal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ViewController
        vc.pillarData = pillarData
        vc.dailyChecklist = dailyChecklist
        vc.streaks = streaks
        vc.templeNumber = templeNumber
    }

}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func convertToGrayScale() -> UIImage {
        let filter: CIFilter = CIFilter(name: "CIPhotoEffectMono")!
        filter.setDefaults()
        filter.setValue(CoreImage.CIImage(image: self)!, forKey: kCIInputImageKey)

        return UIImage(cgImage: CIContext(options:nil).createCGImage(filter.outputImage!, from: filter.outputImage!.extent)!)
    }

    
}
