# KVCycleView

轮播图的封装

## Requirements
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

## 使用方法

cycleView = KVCycleView(frame: self.view.bounds)

cycleView.delegate = self

self.view.addSubview(cycleView)

页面更新时执行 cycleView.reload() 即可

在代理中可设置轮播的间隔、设置pageVControl的背景色、当前显示点的色值等等


