//
//  ViewController.swift
//  SpaceTake
//
//  Created by Jim Chuang on 2018/10/31.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let roomLen:Double = 375 //375
    let roomWidth:Double = 342 //342
    @IBOutlet var myView: UIView!

    var colorIndex:Int = 0
    var colorArr:Array<UIColor> = [.blue,.green,.yellow,.brown]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {

        // 預設地板
        let myRoomView = UIView(frame: CGRect(x: 0, y: 0, width: roomWidth, height: roomLen))
        myRoomView.viewWithTag(999)
        myRoomView.backgroundColor = .red
        myRoomView.alpha = 0.2
        myRoomView.layer.borderWidth = 10
        myRoomView.layer.borderColor = UIColor(red: 0.83, green: 0.43, blue: 0.1, alpha: 1).cgColor
        myRoomView.tag = 999
        self.myView.addSubview(myRoomView)

        // 載入手勢
        myRoomView.addGestureRecognizer(setPan())
        myRoomView.addGestureRecognizer(setOTap())
        myRoomView.addGestureRecognizer(setDTap())
        myRoomView.addGestureRecognizer(setLongPress())
    }

    // 拖曳手勢
    func setPan() ->UIPanGestureRecognizer{
        let myPan = UIPanGestureRecognizer(target: self, action: #selector(whenPan))
        myPan.maximumNumberOfTouches = 1
        myPan.minimumNumberOfTouches = 1
        return myPan
    }

    // 一次點擊手勢
    func setOTap() -> UITapGestureRecognizer{
        let myTap = UITapGestureRecognizer(target: self, action: #selector(whenOTap(sender:)))
        myTap.numberOfTapsRequired = 1
        return myTap
    }

    // 四次點擊手勢
    func setDTap() -> UITapGestureRecognizer{
        let myTap = UITapGestureRecognizer(target: self, action: #selector(whenDTap(sender:)))
        myTap.numberOfTapsRequired = 4
        return myTap
    }

    func setLongPress() -> UILongPressGestureRecognizer{
        let myLongPress = UILongPressGestureRecognizer(target: self, action: #selector(whenLongPress(sender:)))
        myLongPress.minimumPressDuration = 1
        return myLongPress
    }

    // 長按圖片
    @objc func whenLongPress(sender:UILongPressGestureRecognizer){

        if sender.state == UIGestureRecognizer.State.began{
            if let size = sender.view?.bounds.size{
                let sizeView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
                sizeView.backgroundColor = .black
                let hLabel = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height/2))
                let wLabel = UILabel(frame: CGRect(x: 0, y: size.height/2, width: size.width, height: size.height/2))
                hLabel.textColor = .white
                wLabel.textColor = .white
                hLabel.text = "↕︎\(size.height)↕︎"
                wLabel.text = "↔︎\(size.width)↔︎"
                hLabel.minimumScaleFactor = 0.2
                wLabel.minimumScaleFactor = 0.2
                hLabel.font = hLabel.font.withSize(40)
                wLabel.font = wLabel.font.withSize(40)
                hLabel.adjustsFontSizeToFitWidth = true
                wLabel.adjustsFontSizeToFitWidth = true
                sizeView.addSubview(hLabel)
                sizeView.addSubview(wLabel)

                sender.view?.addSubview(sizeView)
            }
        }

        if sender.state == UIGestureRecognizer.State.ended{
            for sizeLabelView in sender.view!.subviews{
                sizeLabelView.removeFromSuperview()
            }
        }
    }

    // 拖曳圖片
    @objc func whenPan(sender:UIPanGestureRecognizer){
        // 根據旋轉角度 計算拖曳位置
        let nowCenter = sender.view!.center
        let tr = sender.translation(in: sender.view)
        let rot = sender.view!.transform
        sender.view!.center = CGPoint(x: nowCenter.x + tr.x * rot.a + tr.y * rot.c,
                                      y: nowCenter.y + tr.y * rot.d + tr.x * rot.b)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    // 點擊圖片
    @objc func whenOTap(sender:UITapGestureRecognizer){
        // 長寬互換
        //let size = sender.view!.frame.size
        //sender.view!.frame.size = CGSize(width: size.height, height: size.width)
        //sender.view!.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi/2)

        // 旋轉90度
        sender.view!.transform = sender.view!.transform.rotated(by: CGFloat.pi/2)
    }

    @objc func whenDTap(sender:UITapGestureRecognizer){
        sender.view!.removeFromSuperview()
    }


    @IBAction func cleanBtnClick(_ sender: UIBarButtonItem) {
        for x in myView.subviews{
            x.removeFromSuperview()
        }
    }

    @IBAction func addBtnClick(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "輸入大小", message: "", preferredStyle: .alert)
        alert.addTextField { (nameTF) in
            nameTF.placeholder = "家俱"
            nameTF.text = ""
        }
        alert.addTextField { (lenTF) in
            lenTF.placeholder = "長度"
            lenTF.text = ""
        }
        alert.addTextField { (widthTF) in
            widthTF.placeholder = "寬度"
            widthTF.text = ""
        }
        let okAction = UIAlertAction(title: "確定", style: .default) { (myAction) in
            let myIndex = self.colorIndex % 4
            self.colorIndex += 1
            let viewColor:UIColor = self.colorArr[myIndex]
            if let name = alert.textFields![0].text, let len = Double(alert.textFields![1].text!), let width = Double(alert.textFields![2].text!)  {

                // 如果名稱是定義中的圖片 則使用imageView 呈現，並記錄Tag
                if let index = imageNameArr.firstIndex(of: name){
                    let myIV:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: len))
                    myIV.contentMode = .scaleToFill
                    myIV.image = UIImage(named: name+".png")
                    myIV.isUserInteractionEnabled = true
                    myIV.tag = index

                    myIV.addGestureRecognizer(self.setPan())
                    myIV.addGestureRecognizer(self.setOTap())
                    myIV.addGestureRecognizer(self.setDTap())
                    myIV.addGestureRecognizer(self.setLongPress())

                    self.myView.addSubview(myIV)

                // 如果名稱是未定義圖片 則使用UILabel 呈現
                }else{
                    let addLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: len))
                    addLabel.text = name
                    addLabel.textAlignment = .center
                    addLabel.font = addLabel.font.withSize(20)
                    addLabel.numberOfLines = 0
                    addLabel.adjustsFontSizeToFitWidth = true
                    if name == "w"{
                        addLabel.text = "．"
                        addLabel.backgroundColor = .white
                    }else{
                        addLabel.backgroundColor = viewColor
                        addLabel.alpha = 0.8
                    }
                    addLabel.isUserInteractionEnabled = true
                    if name == "room"{
                        addLabel.text = ""
                        addLabel.backgroundColor = .red
                        addLabel.alpha = 0.2
                    }

                    addLabel.addGestureRecognizer(self.setPan())
                    addLabel.addGestureRecognizer(self.setOTap())
                    addLabel.addGestureRecognizer(self.setDTap())
                    addLabel.addGestureRecognizer(self.setLongPress())

                    self.myView.addSubview(addLabel)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func saveBtnClick(_ sender: UIBarButtonItem) {
        var myAllArr = Array<UIView>()
        for subView in myView.subviews{

            print("save")
            myAllArr.append(subView)
        }
        if myAllArr.count > 0 {
            SaveData.share.saveArr(allArr: myAllArr)
        }
    }

    @IBAction func loadBtnClick(_ sender: UIBarButtonItem) {
        if let myAllArr = SaveData.share.loadArr(){
            for subView in myView.subviews{
                if subView.tag != 999{
                subView.removeFromSuperview()
                }
            }
            for addSubView in myAllArr{

                // 如果是imageView 要從tag 中取得image name
                if let subIV = addSubView as? UIImageView{
                    let name = imageNameArr[subIV.tag]
                    subIV.image = UIImage(named: name+".png")
                    subIV.addGestureRecognizer(setPan())
                    subIV.addGestureRecognizer(setOTap())
                    subIV.addGestureRecognizer(setDTap())
                    subIV.addGestureRecognizer(setLongPress())
                    // 顯示長寬
/*
                    let sizeLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: subIV.bounds.size))
                    sizeLabel.text = "\(subIV.bounds.size.height) x \(subIV.bounds.size.width)"
                    sizeLabel.numberOfLines = 0
                    sizeLabel.adjustsFontSizeToFitWidth = true
                    subIV.addSubview(sizeLabel)
                    print("\(name) = \(subIV)")
*/
                    self.myView.addSubview(subIV)
                }else{
                    addSubView.addGestureRecognizer(setPan())
                    addSubView.addGestureRecognizer(setOTap())
                    addSubView.addGestureRecognizer(setDTap())
                    addSubView.addGestureRecognizer(setLongPress())

                    self.myView.addSubview(addSubView)
                }
            }
        }
    }

}
