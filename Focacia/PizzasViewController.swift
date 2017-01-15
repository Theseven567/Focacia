//
//  ViewController.swift
//  FocaciaPizzasViewController
//
//  Created by Егор on 12/13/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit
import Firebase

class PizzasViewController: UIViewController {
    
    var pizzas = [PizzaView]()
    
    var childToLoad:String?
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var addPizzaButton: UIButton!
    


   

    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        super.viewDidLoad()
        print(childToLoad ?? "noneyet")
        load()
    }



    func load(){
        let xOrigin = self.view.frame.width
        var ref: FIRDatabaseReference!
        if childToLoad == nil{
            childToLoad = "Pizza"
        }
        ref = FIRDatabase.database().reference().child("Food").child(childToLoad!)
        ref.observe(.value, with: { (snapshot) in
            var placer:CGFloat = 0
            // Deleting and reloading all the views
            for view in self.scrollView.subviews{
                view.removeFromSuperview()
            }
            
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? FIRDataSnapshot{
                if let val = snap.value as? [String: String]{
                let tempView =  PizzaView(frame: CGRect(x: placer * xOrigin, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                tempView.ingredients.text? = val["ingredients"] ?? "No ingredients"
                tempView.name.text? = val["name"] ?? "Noname"
                tempView.image.sd_setImage(with: URL(string: val["pic"]!))
                tempView.image.layer.masksToBounds = false
                tempView.image.layer.cornerRadius = tempView.image.frame.height/2
                tempView.image.clipsToBounds = true
               self.scrollView.addSubview(tempView)
                placer = placer + 1
            }
                self.scrollView.contentSize = CGSize(width: self.view.frame.width * (placer), height: self.view.frame.height)
            }
            
        })
        
//        ref.observe(.childAdded, with: { (snapshot) in
//            print("Yoy child added")
//            if let val = snapshot.value as? [String: String]{
//                let tempView =  PizzaView(frame: CGRect(x: placer * xOrigin, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//                tempView.ingredients.text? = val["ingredients"] ?? "No ingredients"
//                tempView.name.text? = val["name"] ?? "Noname"
//                tempView.image.sd_setImage(with: URL(string: val["pic"]!))
//                tempView.image.layer.masksToBounds = false
//                tempView.image.layer.cornerRadius = tempView.image.frame.height/2
//                tempView.image.clipsToBounds = true
//                self.scrollView.contentSize.width += self.view.frame.width
//                self.scrollView.addSubview(tempView)
//            }
//        })

    }
    
  



}

