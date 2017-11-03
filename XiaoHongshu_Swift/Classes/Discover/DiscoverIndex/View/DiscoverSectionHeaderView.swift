//
//  DiscoverSectionHeaderView.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/14.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class DiscoverSectionHeaderView: UITableViewHeaderFooterView {
    
    //重用标识
    static let identifier = "DiscoverSectionHeaderView"
    
    //分组指示器
    lazy var indicator = {return UIView()}()
    //分组标题
    lazy var titleLabel = {return UILabel()}()
    //查看更多
    lazy var moreBtn = {return UIButton()}()
    //箭头图标
    lazy var arrowIcon = {return UIImageView()}()
    
    //回调
    var handleblock:(()->())?;
    
    static func headerWith(tableView:UITableView)->DiscoverSectionHeaderView{
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiscoverSectionHeaderView.identifier)
        if header == nil{
            header = DiscoverSectionHeaderView(reuseIdentifier: DiscoverSectionHeaderView.identifier);
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            header?.backgroundView = backgroundView
            
        }
        return header as! DiscoverSectionHeaderView
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
        
        addSubview(indicator)
        addSubview(titleLabel)
        addSubview(moreBtn)
        addSubview(arrowIcon)
        
    }
    
    
    //数据源方法
    func fillterWith(title:String,handleblock:@escaping ()->()) {
        self.handleblock = handleblock
        
        //指示器
        indicator.backgroundColor = NAV_BAR_RED_COLOR
        indicator.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(5*APP_SCALE)
            make.width.equalTo(2*APP_SCALE)
            make.centerY.equalTo(self)
            make.height.equalTo(15*APP_SCALE)
        }
        
        //分组标题
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(indicator.snp.right).offset(4*APP_SCALE)
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
