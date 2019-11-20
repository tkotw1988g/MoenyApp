//
//  SaveTVC.swift
//  MoenyApp
//
//  Created by 張哲禎 on 2019/11/15.
//  Copyright © 2019 SHIH-YING PAN. All rights reserved.
//

import UIKit

class SaveTVC: UITableViewController {
    @IBAction func goBack(segue:UIStoryboardSegue){}
    var saves = [SaveMoney]()
    var bell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "支出紀錄"
        if let savesDefault = UserDefaults.standard.data(forKey: "saves"){
            if let saves = try? JSONDecoder().decode([SaveMoney].self, from: savesDefault){
                self.saves = saves
            }
        }
        if UserDefaults.standard.bool(forKey: "bell") != nil {
            bell = UserDefaults.standard.bool(forKey: "bell")
            var totalMoney = 0
            if bell {
                for i in 0..<saves.count{
                    let save = saves[i]
                    totalMoney += save.money
                }
                let controller = UIAlertController(title: "保持努力,繼續花錢", message: "已經花費\(totalMoney)元", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default) { (alert) in
                }
                controller.addAction(ok)
                present(controller,animated: true)
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return saves.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let save = saves[indexPath.row]
        var text = ""
        text += "花費項目：\(save.name)"
        text += "花費金額：\(save.money)"
        cell.textLabel?.text = text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        let dateStr = dateFormatter.string(from: save.date)
        cell.detailTextLabel?.text = "於\(dateStr)花費"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIAlertController(title: "確認是否刪除該花費", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) { (alert) in
            self.saves.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            if let savesData = try? JSONEncoder().encode(self.saves) {
                UserDefaults.standard.set(savesData, forKey: "saves")
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (alert) in
        }
        controller.addAction(ok)
        controller.addAction(cancel)
        present(controller,animated: true)
    }
}
