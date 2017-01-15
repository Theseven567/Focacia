//
//  CollectionViewController.swift
//  Focacia
//
//  Created by Егор on 1/10/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase



class CollectionViewController: UICollectionViewController {

    
    var Categories = [String]()
    
    override func viewDidLoad() {
        loadCategories()

        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.red
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.count
    }
    


    
    func loadCategories(){
        let ref = FIRDatabase.database().reference().child("Food")
        
        ref.observe(.value, with: { (snapshot) in
            
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? FIRDataSnapshot{
                self.Categories.append(snap.key)
            }
            self.collectionView?.reloadData()
        })
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        as! CategoryViewCell
        cell.category.text = Categories[indexPath.row]
        cell.layer.cornerRadius = 20
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "loadCategories", sender: Categories[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest  = segue.destination as! PizzasViewController
        guest.childToLoad = sender as? String
    }
}
