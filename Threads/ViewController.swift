//
//  ViewController.swift
//  Threads
//
//  Created by Maryan on 17.01.2020.
//  Copyright © 2020 Maryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var array: SynchronizedArray = SynchronizedArray<UIImage?>()
    
    let image = UIImage(named: "huge_image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let timer = Timer(timeInterval: 1.0, target: self,
                          selector: #selector(updateLabel),
                          userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        DispatchQueue.global(qos: .background).async {
            while true {
                let time: Double = Double.random(in: 0.1..<0.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    self.array.append(self.image)
                }
                
                DispatchQueue.global().sync {
                    self.array.removeLast()
                }
            }
        }
    }
    
    @objc func updateLabel() {
        self.label.text = "\(self.array.getDeletedObjectCounter())"
        self.array.clearDeletedObjectCounter()
    }
}

