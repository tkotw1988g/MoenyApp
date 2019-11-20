//
//  AddSaveTVC.swift
//  MoenyApp
//
//  Created by 張哲禎 on 2019/11/15.
//  Copyright © 2019 SHIH-YING PAN. All rights reserved.
//

import UIKit

class AddSaveTVC: UITableViewController {
    @IBOutlet weak var tfMoney: UITextView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDate: UIDatePicker!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var swBell: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userDefault = UserDefaults.standard.data(forKey: "saves"){
            if let saves = try? JSONDecoder().decode([SaveMoney].self, from: userDefault){
                var count = 0
                for i in 0..<saves.count{
                let save = saves[i]
                    count += save.money
                }
                lbMoney.text = "\(count)"
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func btSubmit(_ sender: UIBarButtonItem) {
        print("AA")
        let name = tfName.text ?? ""
        let money = Int(tfMoney.text) ?? -1
        let date = tfDate.date
        let bell = swBell.isOn
        
        if name != "" && money > 0 {
            let saveMoney = SaveMoney(name: name, money:money, date: date)
            var saves = [SaveMoney]()
            if let  data = UserDefaults.standard.data(forKey: "saves"){
                if let savesDefault = try? JSONDecoder().decode([SaveMoney].self, from: data){
                    saves = savesDefault
                }else {
                    print("有檔,但解析失敗")
                }
            }
            saves.append(saveMoney)
            let savesDefault = try? JSONEncoder().encode(saves)
//            嘗試物件沒辦法直接存在default,所以先轉成JSON格式的data,再做存入userDefault動作
            UserDefaults.standard.set(savesDefault, forKey: "saves")
            UserDefaults.standard.set(bell, forKey: "bell")
            performSegue(withIdentifier: "saveMoneyS", sender: nil)
        }else {
            let controller = UIAlertController(title: "請確認資料輸入完整", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default) { (alert) in
            }
            controller.addAction(ok)
            present(controller,animated: true)
        }
        
        
    }
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        let name = tfName.text ?? ""
//        let money = Int(tfMoney.text) ?? -1
//
//        if name == "" || money <= 0 {
//         return false
//        }else {
//            return true
//        }
//    }
}
