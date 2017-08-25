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
        
        cycleView = KVCycleView(frame: self.view.bounds)
        cycleView.delegate = self
        self.view.addSubview(cycleView)
        
    }
    
    //let images : [String] = ["5F" ,"cfl","hsz"]

    let images : [String] = [
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503656961114&di=4b4f9880f04e0aba483d5b6cd8ee472a&imgtype=0&src=http%3A%2F%2Fpic7.nipic.com%2F20100609%2F3017209_220213550272_2.jpg" ,"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503656961114&di=466a7b00e922de834238b45535891949&imgtype=0&src=http%3A%2F%2Fimg0.ph.126.net%2FwzDDf46xdC37iq4sPeccLg%3D%3D%2F3311834576078039103.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503656961114&di=7861e456963dcfecbe6df6eaba759447&imgtype=0&src=http%3A%2F%2Fpic29.nipic.com%2F20130531%2F7447430_194454520000_2.jpg"]
    
    
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
    
    func cycleView(pageControlHeight cycleView: KVCycleView) -> Double {
        return 40
    }
    
}

