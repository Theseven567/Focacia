//
//  PizzaView.swift
//  Focacia
//
//  Created by Егор on 12/17/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
class PizzaView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func deletePizza(_ sender: UIButton) {
        let ref = FIRDatabase.database().reference().child("Food").child("Pizza").child(name.text!)
        ref.observe(.value, with: { (snapshot) in
            if let val = snapshot.value  as? [String : String]{
                let picName = val["picName"]
                FIRStorage.storage().reference().child(picName!).delete { error in
                    if error != nil {
                    } else {
                        ref.removeValue()
                        self.removeFromSuperview()
                    }
                }
            }})
            
            
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("PizzaView", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("PizzaView", owner: self, options: nil)
        self.view.frame = bounds
        self.addSubview(self.view)
    }

}
