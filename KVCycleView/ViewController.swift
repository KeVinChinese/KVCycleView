//
//  ViewController.swift
//  collection轮播
//
//  Created by Kevin on 2017/8/15.
//  Copyright © 2017年 KeVin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,KVCycleViewDelegate {

    var cycleView : KVCycleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        cycleView = KVCycleView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: 200))
        cycleView.delegate = self
        self.view.addSubview(cycleView)
        
    }
    
    let images : [String] = ["mpay_useing"]//["mpay_useing" ,"bus_beijing-507","bank_pay"]
    
    
    func cycleView(index cycleView: KVCycleView) -> Int {
        return images.count
    }
    
    func cycleView(_ cycleView: KVCycleView, _ index: Int) -> imageModel {
        return imageModel(name: images[index], type: imageStringType.local)
        
    }
    func cycleView(_ cycleView: KVCycleView, didSelected index: Int) {
        cycleView.reloadData()  
    }
    func cycleView(_ cycleView: KVCycleView, didShow index: Int) {
        print(index)
    }
    
    func cycleView(timeInterval cycleView: KVCycleView) -> Double {
        return 1
    }
    
}

