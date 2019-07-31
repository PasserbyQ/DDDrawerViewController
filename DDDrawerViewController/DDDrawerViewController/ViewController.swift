//
//  ViewController.swift
//  DDDrawerViewController
//
//  Created by yu qin on 2019/7/31.
//  Copyright © 2019 yu qin. All rights reserved.
//

import UIKit

// 屏幕的宽
private let kSCREENW = UIScreen.main.bounds.size.width
// 屏幕的高
private let kSCREENH = UIScreen.main.bounds.size.height
// 时间
private let animDuration : TimeInterval = 0.5
// 抽屉宽度
private let leftWidth = kSCREENW * 0.7

enum NowState {
    case open
    case close
}

class ViewController: UIViewController {

    // 灰色背景
    lazy fileprivate var backgroundView = UIView()
    // 抽屉视图
    lazy fileprivate var leftView = LeftMenuView.leftView()
    // 当前状态
    fileprivate var state = NowState.close
    // 侧滑的速度
    fileprivate var startTimeStamp = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
    }
    
    fileprivate func setupSideMenu(){
        
        
        backgroundView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: kSCREENW,
                                      height: kSCREENH)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tap(tapGes:)))
        tapgesture.delegate = self
        backgroundView.addGestureRecognizer(tapgesture)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(viewPan(sender:)))
        backgroundView.addGestureRecognizer(gesture)
        
        
        leftView.frame = CGRect(x: -leftWidth,
                                     y: 0,
                                     width: leftWidth,
                                     height: kSCREENH)
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(leftView)
        backgroundView.isHidden = true
        
    }
    
    @IBAction func drawer() {
        showLeftView()
    }


}

extension ViewController {
    
    // 时间戳
    fileprivate func timeInterval() -> TimeInterval {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        return timeInterval
    }
    
    // 滑动
    @objc func viewPan(sender: UIPanGestureRecognizer) {
        
        let x = sender.translation(in: self.backgroundView).x
        
        let frame = self.leftView.frame
        let frame2 = self.backgroundView.frame
        
        print("000000000x:\(x)--")
        
        if frame.origin.x > 0 {
            self.leftView.frame.origin.x = 0
            
        }
        
        if(sender.state == .changed){
            //当为close状态时，不能向左滑动
            if(self.state == NowState.close && x-leftWidth >= -leftWidth){
                //                backgroundView.transform = CGAffineTransform(translationX: x, y: 0)
                //                userInfo.transform = CGAffineTransform(translationX: x-width, y: 0)
                //                print("111111x:\(x)--main:\(frame2.origin.x)--left:\(frame.origin.x)")
                //当为open状态时，不能向右滑动
            }else if(self.state == NowState.open && x+leftWidth <= leftWidth) && frame.origin.x <= 0{
                //                backgroundView.transform = CGAffineTransform(translationX: x+width, y: 0)
                leftView.transform = CGAffineTransform(translationX: x, y: 0)
                print("222222x:\(x)--main:\(frame2.origin.x)--left:\(frame.origin.x)")
            }
            
        }else if(sender.state == .ended || sender.state == .cancelled || sender.state == .failed){
            
            //当前时间的时间戳
            let endTimeStamp = Double(timeInterval())
            
            UIView.animate(withDuration: animDuration) {
                //结束滑动的时候，根据结束时的位置来判断剩下的动画是打开还是关闭
                if(frame.origin.x >= -(leftWidth * 0.5) && endTimeStamp - self.startTimeStamp > 0.3) {
                    self.state = NowState.open
                    self.backgroundView.isHidden = false
                    self.leftView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.leftView.frame.origin.x = 0
                    print("333333x:\(x)--main:\(frame2.origin.x)--left:\(frame.origin.x)")
                }else{
                    UIView.animate(withDuration: animDuration, animations: {
                        self.leftView.frame.origin.x = -leftWidth
                    }) { (fished:Bool) in
                        if fished {
                            self.backgroundView.isHidden = true
                            self.state = NowState.close
                        }
                    }
                    self.leftView.transform = CGAffineTransform(translationX: -leftWidth, y: 0)
                    print("44444x:\(x)--main:\(frame2.origin.x)--left:\(frame.origin.x)")
                }
            }
        } else if(sender.state == .began){
            print("开始了。。。")
            //当前时间的时间戳
            startTimeStamp = Double(timeInterval())
        }
        print("x:\(x)--main:\(frame2.origin.x)--left:\(frame.origin.x)")
        
    }
    
    // 点击消失
    @objc fileprivate func tap(tapGes: UITapGestureRecognizer) {
        dismissLeftView()
    }
    
    // 展示
    fileprivate func showLeftView() {
        if leftView.frame.origin.x < 0 {
            backgroundView.isHidden = false
            self.state = NowState.open
            UIView.animate(withDuration: animDuration) {
                self.leftView.frame.origin.x = 0
            }
        }
    }
    
    // 消失
    fileprivate func dismissLeftView() {
        
        if leftView.frame.origin.x >= 0 {
            UIView.animate(withDuration: animDuration, animations: {
                self.leftView.frame.origin.x = -leftWidth
                
            }) { (fished:Bool) in
                if fished {
                    self.backgroundView.isHidden = true
                    self.state = NowState.close
                }
            }
        }
    }
    
}


// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    
    // 指定区域可以响应手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: leftView))! {
            return false
        }
        return true
    }
}
