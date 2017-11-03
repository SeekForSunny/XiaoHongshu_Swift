//
//  NavSearchView.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/12.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class NavSearchView: UIView {


   static func viewWithTitle(title:String) -> NavSearchView {
        
        //设置搜索框
        let searchView = NavSearchView();
        searchView.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(30*APP_SCALE);
        }
        searchView.backgroundColor = SEARCH_BAR_RED_COLOR;
        searchView.layer.cornerRadius = 5*APP_SCALE;
        searchView.clipsToBounds = true;
        
        //搜索图标
        let searchIcon = UIImageView();
        searchIcon.image = UIImage(named: "navibar_search_19x19_");
        searchIcon.contentMode = .scaleAspectFill;
        searchView.addSubview(searchIcon);
        searchIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(searchView);
            make.left.equalTo(searchView.snp.left).offset(20*APP_SCALE);
            make.size.equalTo(CGSize(width: 15*APP_SCALE, height: 15*APP_SCALE));
        }
        
        //搜索框文字
        let searchLabel = UILabel();
        searchLabel.text = title
        searchLabel.textColor = UIColor.white;
        searchLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE);
        searchView.addSubview(searchLabel);
        searchLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(searchView);
            make.left.equalTo(searchIcon.snp.right).offset(10*APP_SCALE);
        }

        return searchView;
        
    }

}
