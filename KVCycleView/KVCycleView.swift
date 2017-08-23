//
//  cycleView.swift
//  collection轮播
//
//  Created by Kevin on 2017/8/16.
//  Copyright © 2017年 KeVin. All rights reserved.
//


//****** 出现拖拽位置改变的状态,请在控制器的viewDidLoad 中添加self.automaticallyAdjustsScrollViewInsets = false
//或者放在viewDidAppear中

import UIKit

enum imageStringType {
    case url
    case local
}

struct imageModel {
    var name : String?
    var type : imageStringType?
}
 
protocol KVCycleViewDelegate : class {
    func cycleView(index cycleView:KVCycleView) -> Int
    
    func cycleView(_ cycleView:KVCycleView, _ index: Int) -> imageModel
    
    //optional
    //点击图片的回调
    func cycleView(_ cycleView:KVCycleView, didSelected index:Int)
    //图片显示之后的回调
    func cycleView(_ cycleView:KVCycleView, didShow index:Int)
    //滚动的时间间隔
    func cycleView(timeInterval cycleView:KVCycleView) -> Double
    //默认图
    func cycleView(placeholder cycleView:KVCycleView) -> UIImage?
    //页码控制器的高度  ****** 返回0时隐藏page
    func cycleView(pageControlHeight cycleView:KVCycleView) -> Double
    
}


extension KVCycleViewDelegate {
    func cycleView(_ cycleView:KVCycleView, didSelected index:Int){
        
    }
    
    func cycleView(_ cycleView:KVCycleView, didShow index:Int)  {
        
    }
    func cycleView(timeInterval cycleView:KVCycleView) -> Double {
        return 3
    }
    func cycleView(placeholder cycleView:KVCycleView) -> UIImage? {
        return UIImage(named: "")
    }
    
    func cycleView(pageControlHeight cycleView:KVCycleView) -> Double{
        return Double(cycleView.bounds.size.height) * 0.1
    }
    
}


class KVCycleView: UIView ,UIScrollViewDelegate{
    
    //懒加载控件
    fileprivate lazy var contentScrollView : UIScrollView! = {
        let contentScrollView = UIScrollView(frame: self.bounds)
        contentScrollView.contentSize = CGSize(width: self.bounds.size.width * 3, height: 0)
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.delegate = self
        return contentScrollView
    }()
    fileprivate lazy var lastImageView : UIImageView! = {
        let lastImageView = UIImageView(frame: self.bounds)
        return lastImageView
    }()
    fileprivate lazy var currentImageView : UIImageView! = {
        let currentImageView = UIImageView(frame: CGRect(origin: CGPoint(x:self.bounds.size.width,y:0), size: self.bounds.size))
        currentImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageAction))
        currentImageView.addGestureRecognizer(tap)
        currentImageView.backgroundColor = UIColor.gray
        return currentImageView
    }()
    
    fileprivate lazy var nextImageView : UIImageView! = {
        let nextImageView = UIImageView(frame: CGRect(origin: CGPoint(x:self.bounds.size.width * 2,y:0), size: self.bounds.size))
        nextImageView.backgroundColor = UIColor.gray
        return nextImageView
    }()
    fileprivate lazy var pageControl : UIPageControl! = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor.orange
        return pageControl
    }()
    
    //定时器
    fileprivate var timer : Timer?
    
    //当前显示第几张图片
    fileprivate var indexOfCurrentImage : Int! = 0 {
        didSet{
            pageControl.currentPage = indexOfCurrentImage
        }
    }
    
    
    
    //代理对象
    weak open var delegate : KVCycleViewDelegate?
    //页面布局
    override init(frame: CGRect) {
        super.init(frame: frame)
        UISetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UISetUp()
    }
    
    open func reloadData() {
        setScrollViewOfImage()
        if timer != nil {
            deinitTimer()
        }
        //解决没有图片的情况
        if delegate?.cycleView(index: self) ?? 0 <= 1{
            self.contentScrollView.isScrollEnabled = false
        }else {
            self.contentScrollView.isScrollEnabled = true
            initTimer(delegate?.cycleView(timeInterval: self) ?? 3)
        }
        
        pageControl.numberOfPages = delegate?.cycleView(index: self) ?? 0
        
        
        
    }
    //添加页面
    fileprivate func UISetUp() {
        self.addSubview(contentScrollView)
        contentScrollView.addSubview(lastImageView)
        contentScrollView.addSubview(currentImageView)
        contentScrollView.addSubview(nextImageView)
        self.addSubview(pageControl)
        reloadData()
    }
    
    //imageView赋值
    fileprivate func setScrollViewOfImage() {
        guard let tempDelegate = delegate , self.indexOfCurrentImage < tempDelegate.cycleView(index: self) else {
            return
        }
        
        setModel(currentImageView, tempDelegate.cycleView(self, indexOfCurrentImage))
        setModel(lastImageView, tempDelegate.cycleView(self, getLastIndex(indexOfCurrentImage)))
        setModel(nextImageView, tempDelegate.cycleView(self, getNextIndex(indexOfCurrentImage)))
        
    }
    
    
    //获取上下页
    fileprivate func getLastIndex(_ index: Int) -> Int{
        return
            index <= 0
            ? delegate!.cycleView(index: self) - 1
            : index - 1
    }
    fileprivate func getNextIndex(_ index: Int) -> Int {
        return
            index >= delegate!.cycleView(index: self)-1
            ? 0
            : index + 1
    }
    
    //imageView添加iamge方法
    fileprivate func setModel(_ imageView:UIImageView,_ imageModel:imageModel) {
        switch imageModel.type! {
        case .url:
            do {
                let data = try Data(contentsOf: URL(string: imageModel.name!)!)
                imageView.image = UIImage(data: data)
            } catch let error {
                print("error  " , error)
            }
        case .local:
            imageView.image = UIImage(named: imageModel.name ?? "")
        }
    }
    
    //时间控制器方法
    @objc private func timerAction() {
        self.contentScrollView.setContentOffset(CGPoint(x: self.bounds.size.width * 2, y: 0), animated: true)
    }
    //初始化定时器
    fileprivate func initTimer(_ timeInterval: Double) {
        timer = Timer.scheduledTimer(timeInterval:TimeInterval(delegate?.cycleView(timeInterval: self) ?? 2), target: self, selector: #selector(timerAction), userInfo:nil, repeats: true)
        timer?.fireDate = Date(timeIntervalSinceNow: timeInterval)
    }
    //销毁定时器
    fileprivate func deinitTimer() {
        if timer != nil {
            timer = nil
            timer!.invalidate()
        }
    }
    
    deinit {
        deinitTimer()
    }
    //点击动作的响应
    @objc private func imageAction() {
        delegate?.cycleView(self, didSelected: indexOfCurrentImage)
    }
    
    
    
}

extension KVCycleView {
    
    
    //开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("WillBeginDragging   ",self.currentImageView.frame)
        
        deinitTimer()
    }
    //停止拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("DidEndDragging   ",self.currentImageView.frame)
        
        initTimer(5)
    }
    
    //滚动结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        debugPrint(offset)
        
        if offset == 0 {
            self.indexOfCurrentImage = getLastIndex(indexOfCurrentImage)
        }else if offset == self.bounds.size.width * 2 {
            self.indexOfCurrentImage = getNextIndex(indexOfCurrentImage)
        }
        self.setScrollViewOfImage()
        scrollView.setContentOffset(CGPoint(x:self.bounds.size.width,y: 0), animated: false)
        delegate?.cycleView(self, didShow: indexOfCurrentImage)
        
    }
    //滚动页面之后重新布局
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(self.contentScrollView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageControl.isHidden = delegate?.cycleView(pageControlHeight: self) == 0
        pageControl.frame = CGRect(x: 0, y: Double(self.bounds.size.height) - (delegate?.cycleView(pageControlHeight: self) ?? 0), width: Double(self.bounds.size.width), height: delegate?.cycleView(pageControlHeight: self) ?? 0)
        contentScrollView.setContentOffset(CGPoint(x:self.bounds.size.width,y: 0), animated: false)
    }
    
    
}
















