//
//  ViewController.swift
//  PhotosLibTest
//
//  Created by 相澤 隆志 on 2015/03/21.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    var collectionList:PHCollectionList? = nil
    var assetsArray:[PHAsset?] = []
    var remainLength:CGFloat = 0
    var prevHight:CGFloat = 0
    let spaceOfImage:CGFloat = 10
    var dataMngr:DataManager? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let leftButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action: "backButtonPushed")
        self.navigationItem.leftBarButtonItem = leftButton
        collectAssets()
        self.remainLength = self.view.bounds.width
        
        dataMngr = DataManager.sharedInstance
        
    }

    func collectAssets() {
        let moments:PHFetchResult! = PHAssetCollection.fetchMomentsInMomentList(collectionList, options: nil)
        moments.enumerateObjectsUsingBlock { (object, index, flag) -> Void in
            let assets:PHFetchResult! = PHAsset.fetchAssetsInAssetCollection(object as PHAssetCollection, options: nil)
            assets.enumerateObjectsUsingBlock({ (asset, indexOfAsset, flag) -> Void in
                self.assetsArray.append(asset as? PHAsset)
                self.collectionView.reloadData()
            })
        }
    }
    
    func backButtonPushed() {
        self.assetsArray.removeAll(keepCapacity: false)
        self.dataMngr.removeAll()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ThumbnailCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell",forIndexPath: indexPath) as ThumbnailCollectionViewCell
        let phAsset:PHAsset = assetsArray[indexPath.row]!
        let sizeX:CGFloat =  CGFloat(phAsset.pixelWidth/2)
        let sizeY:CGFloat = CGFloat(phAsset.pixelHeight/2)
       
        PHImageManager.defaultManager().requestImageForAsset(phAsset, targetSize: CGSizeMake(sizeX, sizeY), contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            cell.thumbnailImageView.image = image
            var exifInfo:Dictionary = getExifData(phAsset)
            exifInfo["object"] = phAsset
            self.dataMngr.add(exifInfo)
        })

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let asset:PHAsset = assetsArray[indexPath.row]!
        let imghight:CGFloat = CGFloat(asset.pixelHeight)
        let imgwidth:CGFloat = CGFloat(asset.pixelWidth)
        let frameHeight:CGFloat = self.view.bounds.height
        let frameWidth:CGFloat = self.view.bounds.width - spaceOfImage
        var width:CGFloat
        var height:CGFloat
        
        /*
        if self.remainLength == frameWidth {
            let r:Bool = imghight>imgwidth
            width = r ? frameWidth/3 : frameWidth/2
            height = width * imghight/imgwidth
            prevHight = height
            remainLength = frameHeight - width
        }else{
            if imghight>imgwidth {
                height = prevHight
                width = height * imgwidth/imghight
            }else{
                width = remainLength
                height = prevHight
            }
            remainLength = self.view.bounds.width
        }
        */
        width = frameWidth / 2
        height = frameWidth / 4
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let nextViewController:FullViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FullViewController") as FullViewController
        nextViewController.asset = assetsArray[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func getExifData( asset:PHAsset ) -> Dictionary {
        var dict:Dictionary = [:]
        asset.requestContentEditingInputWithOptions(nil) { (contentEditingInput: PHContentEditingInput!, _) -> Void in
            let url = contentEditingInput.fullSizeImageURL
            let orientation = contentEditingInput.fullSizeImageOrientation
            var inputImage = CIImage(contentsOfURL: url)
            inputImage = inputImage.imageByApplyingOrientation(orientation)
            
            for (key, value) in inputImage.properties() {
                println("key: \(key)")
                println("value: \(value)")
                dict["key"] = value
            }
        }
        return dict
    }

}

