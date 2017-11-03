//
//  DiscoverShowMoreController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/17.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class DiscoverShowMoreController: UITableViewController {
    
    //接口信息
    var api:String?
    //标题
    var navTitle:String?
    //内容模型数组
    var contenArr:[Any]?
    //头部分组标题内容数组
    var titleArr:[Any]=[]
    //类型
    var cellType:AnyClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航栏标题
        self.title = navTitle;
        //分割线样式
        tableView.separatorStyle = .none;
        //背景颜色
        tableView.backgroundColor = BACK_GROUND_COLOR;
        
        //设置网络请求
        setupRefresh()
        tableView.headerBeginRefreshing();
    }
    
}

//MARK: - 设置网络请求
extension DiscoverShowMoreController{
    
    func setupRefresh(){
        tableView.setupGifHeaderRefresh(target: self, selector: #selector(refreshHeader))
    }
    
    func refreshHeader(){
        print(api ?? " ")
        guard api != nil else {
            return;
        }
        let params:[String:Any] = [:]
        NetWokTool.request(type: requestType.get, url: api!, params: params) {[weak self] (response : Any?, error : Error?) in
            if error != nil{
                print(error!);
            }else{
                
                if let responseData = response as? [String:Any] {
                    print(responseData)
                    if self?.cellType! == DiscoverHotTopicCell.self{
                        if let data = responseData["data"] as? [Any]{
                            self?.contenArr = DiscoverHotTopicModel.mj_objectArray(withKeyValuesArray: data) as? [Any]
                            self?.tableView.reloadData();
                        }
                    }else if self?.cellType! == DiscoverGlobalBuyCell.self{
                        if let data = responseData["data"] as? [[String:Any]]{
                            print(data)
                            var tempArr:[[DiscoverGlobalBuyModel]] = [];
                            for dict in data  {
                                let city_list = dict["city_list"]
                                let array = DiscoverGlobalBuyModel.mj_objectArray(withKeyValuesArray: city_list) as! [DiscoverGlobalBuyModel]
                                tempArr.append(array)
                                
                                if let country = dict["country"]{
                                    self?.titleArr.append(country)
                                }
                            }
                            self?.contenArr = tempArr
                            self?.tableView.reloadData();
                        }
                    }
                    
                }
            }
            self?.tableView.headerEndRefresh();
        }
    }
    
}

// MARK: - Table view data source
extension DiscoverShowMoreController{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contenArr?.count ?? 0;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        print(cellType!)
        if cellType! == DiscoverHotTopicCell.self{
            let cell = DiscoverHotTopicCell.cell(withTableView: tableView);
            if let model = contenArr?[indexPath.section] as? DiscoverHotTopicModel {
                let isLast = indexPath.row - contenArr!.count + 1 == 0 ? true : false
                cell.fillter(model: model, isLast: isLast)
            }
            return cell
        }else if cellType! == DiscoverGlobalBuyCell.self{
            let cell = DiscoverGlobalBuyCell.cell(withTableView: tableView);
            if let array = self.contenArr?[indexPath.section] as? [DiscoverGlobalBuyModel]{
                cell.fillter(modelArr: array)
            }
            return cell
        }else if cellType! == DiscoverMultiNotesCell.self{
            let cell = DiscoverMultiNotesCell.cell(withTableView: tableView);
            cell.backgroundColor = SM_RANDOM_COLOR()
            return cell
        }else if cellType! == DiscoverHotVideosCell.self{
            let cell = DiscoverHotVideosCell.cell(withTableView: tableView);
            cell.backgroundColor = SM_RANDOM_COLOR()
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier");
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier");
            }
            cell!.backgroundColor = UIColor.yellow
            return cell!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType! == DiscoverHotTopicCell.self{
            return 80;
        }else if cellType! == DiscoverGlobalBuyCell.self{
            return 150;
        }else if cellType! == DiscoverMultiNotesCell.self{
            return 150;
        }else if cellType! == DiscoverHotVideosCell.self{
            return 120;
        }else{
            return 0;
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1*APP_SCALE;
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.lightText;
        return footer;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if cellType! == DiscoverGlobalBuyCell.self{
            return 50*APP_SCALE
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if cellType! == DiscoverGlobalBuyCell.self{
            let header =  DiscoverMoreCityListHeaderView.headerWith(tableView: tableView);
            if let dict = self.titleArr[section] as? [String:Any] {
                header.fillterWith(dict: dict) { [weak self] ()->() in
                    self?.showMore()
                }
            }
            return header;
        }
        
        return nil;
    }
    
    
    func showMore(){
        print("查看更多")
    }
}
