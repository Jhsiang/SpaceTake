//
//  SaveData.swift
//  SpaceTake
//
//  Created by Jim Chuang on 2018/11/1.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation
import UIKit

class SaveData{
    static let share = SaveData()

    // 存檔檔名
    private let file = "ViewArrayFile"

    func loadArr() -> Array<UIView>?{
        var myAllArr:Array<UIView>? = nil
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let myData = try Data(contentsOf: fileURL)
                let myObjcet = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(myData) as! Array<UIView>
                myAllArr = myObjcet
            }
            catch {
                print("load fail")
            }
        }

        return myAllArr
    }

    func saveArr(allArr:Array<UIView>){
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)

            do {
                let arrData = try NSKeyedArchiver.archivedData(withRootObject: allArr, requiringSecureCoding: false)
                try arrData.write(to: fileURL)
            }
            catch {
                print("save fail")
            }
        }
    }

    func removeArr(){
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch {
                print("remove fail")
            }
        }
    }




}
