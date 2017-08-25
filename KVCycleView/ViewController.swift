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
    
    let images : [String] = ["5F" ,"cfl","hsz"]

//    let images : [String] = [
//        "http://v1.qzone.cc/avatar/201409/24/19/58/5422b1ff86ed0232.jpg%21200x200.jpg" ,
//        "http://img2.100bt.com/upload/ttq/20131103/1383470553132_middle.jpg",
//        "http://img0.imgtn.bdimg.com/it/u=4128355576,3453965016&fm=214&gp=0.jpg"
//    ]
    
    
    func cycleView(index cycleView: KVCycleView) -> Int {
        return images.count
    }
    
    func cycleView(_ cycleView: KVCycleView, _ index: Int) -> String? {
        return images[index]
    }
    func cycleView(_ cycleView: KVCycleView, didSelected index: Int) {
        cycleView.reloadData()  
    }
    func cycleView(_ cycleView: KVCycleView, didShow index: Int) {
        print(index)
    }
    
    func cycleView(timeInterval cycleView: KVCycleView) -> Double {
        return 3
    }
    
    
}

