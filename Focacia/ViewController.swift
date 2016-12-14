//
//  ViewController.swift
//  Focacia
//
//  Created by Егор on 12/13/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        load();
    }

    func load(){
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        ref.child("Pizza").child("Margarita").observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : String] ?? [:]
            print(postDict)
        })

    }
    
    @IBOutlet weak var label: UILabel!



}

