//
//  MainTableViewController.swift
//  PhotosLibTest
//
//  Created by 相澤 隆志 on 2015/03/21.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//

import UIKit
import Photos

class MainTableViewController: UITableViewController {
    var collectionList:[PHCollectionList?] = []
    var assetaCollections:[PHAssetCollection?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        makePotoLibArray()
        //self.navigationController?.navigationBar.tintColor = UIColor(red:0.5, green:0.5, blue:0.5, alpha:0,3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makePotoLibArray() {
        let moments:PHFetchResult! = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.MomentList, subtype: PHCollectionListSubtype.Any, options: nil)
        moments.enumerateObjectsUsingBlock { (obj, Index, flag) -> Void in
            let collectionList: PHCollectionList = obj as PHCollectionList
            self.collectionList.append( collectionList )
            let collections:PHFetchResult! = PHAssetCollection.fetchMomentsInMomentList(collectionList, options: nil)
            collections.enumerateObjectsUsingBlock({ (collection, index_col, flag2) -> Void in
                self.assetaCollections.append(collection as? PHAssetCollection)
            })
        }
    }

    // MARK: - Table view data source

     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //var num = assetaCollections.count
        var num = 1
        return num
    }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        /*
        let collection:PHAssetCollection = assetaCollections[section]!
        let nameArray:[String]? = collection.localizedLocationNames as? [String]
        var num = 0
        if nameArray != nil {
            num = nameArray!.count
        }
        */
        let num = collectionList.count
        return num
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        /*
        let collection:PHAssetCollection? = assetaCollections[indexPath.section]?
        let nameArray:[String] = collection!.localizedLocationNames as [String]
        cell.textLabel?.text = nameArray[indexPath.row]
        */
        
        let collect:PHCollectionList = collectionList[indexPath.row]!
        cell.textLabel?.text = collect.localizedTitle
        
        /*
        let collect:PHCollectionList = collectionList[indexPath.row]!
        cell.textLabel?.text = collect.startDate.description
        */
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextViewController:ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ThumbnailCollectionController") as ViewController
        nextViewController.collectionList = collectionList[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
