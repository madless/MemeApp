//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by dmikhov on 16.11.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var memes: [Meme]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        memes = appDelegate?.memes
        
        let shareActionButton: UIBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addMeme))
        self.navigationItem.rightBarButtonItem = shareActionButton
        
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        memes = appDelegate?.memes
        for meme in memes! {
            print(meme.topText)
        }
        tableView.reloadData()
    }


    func addMeme() {
        performSegue(withIdentifier: "addMemeFromTable", sender: nil)
    }
    
    // MARK: tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = memes?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        let item = self.memes?[indexPath.row]
        cell.imageView?.image = item?.memedimage
        if let top = item?.topText, let bot = item?.botText {
            cell.textLabel?.text = top + "@" + bot
        }
        return cell
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(photos[indexPath.row].title)
        //performSegue(withIdentifier: "addMemeFromTable", sender: memes?[indexPath.row])
    }

}
