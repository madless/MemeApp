//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by dmikhov on 16.11.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    var memes: [Meme]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        memes = appDelegate?.memes
        
        let shareActionButton: UIBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addMeme))
        self.navigationItem.rightBarButtonItem = shareActionButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        memes = appDelegate?.memes
        for meme in memes! {
            print(meme.topText)
        }
        collectionView.reloadData()
    }
    
    func addMeme() {
        performSegue(withIdentifier: "addMemeFromCollection", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = memes?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! MemeCollectionViewCell
        let item = memes?[indexPath.row]
        cell.imageView.image = item?.memedimage
        if let top = item?.topText, let bot = item?.botText {
            cell.textView.text = top + "@" + bot
        }
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
