//
//  DiscoverMoreCityListHeaderView.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/18.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class DiscoverMoreCityListHeaderView: UITableViewHeaderFooterView {

    
    //重用标识
    static let identifier = "DiscoverMoreCityListHeaderView"

    //分组标题
    lazy var titleLabel = {return UILabel()}()
    //热门城市数量标题
    lazy var countLabel = {return UILabel()}()
    //查看更多
    lazy var moreBtn = {return UIButton()}()
    //箭头图标
    lazy var arrowIcon = {return UIImageView()}()
    //回调
    var handleblock:(()->())?;
    
    static func headerWith(tableView:UITableView)->DiscoverMoreCityListHeaderView{
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiscoverMoreCityListHeaderView.identifier)
        if header == nil{
            header = DiscoverMoreCityListHeaderView(reuseIdentifier: DiscoverMoreCityListHeaderView.identifier);
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            header?.backgroundView = backgroundView
            
        }
        return header as! DiscoverMoreCityListHeaderView
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //设置子控件
        setupContentView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupContentView(){

        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(moreBtn)
        addSubview(arrowIcon)
        
    }
    
    
    //数据源方法
    func fillterWith(dict:[String:Any],handleblock:@escaping ()->()) {
        self.handleblock = handleblock

        //分组标题
        titleLabel.text = dict["name"] as? String;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14*APP_SCALE)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15*APP_SCALE)
            make.centerY.equalTo(self)
        }
        
        //分组标题
        countLabel.text = ".\(dict["city_count"]!)个热门地区";
        countLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
        countLabel.textColor = UIColor.lightGray
        countLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(4*APP_SCALE)
            make.centerY.equalTo(self)
        }
        
        //查看更多按钮
        moreBtn.setTitle("查看更多", for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
        moreBtn.setTitleColor(.gray, for: .normal)
        moreBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self)
            make.right.equalTo(self.snp.right).offset(-20*APP_SCALE)
        }
        moreBtn.addTarget(self, action: #selector(showMore), for: UIControlEvents.touchUpInside)
        //箭头
        
    }
    
    
    //点击查看更多
    func showMore(){
        if self.handleblock != nil { self.handleblock!() }
    }
    
}
