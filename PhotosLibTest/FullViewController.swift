//
//  FullViewController.swift
//  PhotosLibTest
//
//  Created by 相澤 隆志 on 2015/03/22.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//

import UIKit
import Photos

class FullViewController: UIViewController {

    @IBOutlet weak var fullImageView: UIImageView!
    var asset:PHAsset! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action: "backButtonPushed")
        self.navigationItem.leftBarButtonItem = leftButton
 
        let rightButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Rewind, target: self, action: "infoButtonPushed")
        self.navigationItem.rightBarButtonItem = rightButton

        let sizeX:CGFloat =  CGFloat(asset.pixelWidth)
        let sizeY:CGFloat = CGFloat(asset.pixelHeight)

        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(sizeX, sizeY), contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            self.fullImageView.image = image
            let infoData:NSDictionary = info
            println("metadata:"+infoData.description)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPushed() {
        self.asset = nil
        self.navigationController?.popViewControllerAnimated(true)
    }

    func infoButtonPushed(){
        asset.requestContentEditingInputWithOptions(nil) { (contentEditingInput: PHContentEditingInput!, _) -> Void in
            let url = contentEditingInput.fullSizeImageURL
            let orientation = contentEditingInput.fullSizeImageOrientation
            var inputImage = CIImage(contentsOfURL: url)
            inputImage = inputImage.imageByApplyingOrientation(orientation)
            
            for (key, value) in inputImage.properties() {
                println("key: \(key)")
                println("value: \(value)")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
