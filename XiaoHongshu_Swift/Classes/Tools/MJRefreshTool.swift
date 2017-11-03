//
//  MJRefreshTool.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/10.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import MJRefresh

extension UICollectionView{
    
    
    //MARK:头部刷新
    func setupHeaderRefresh(target:Any,selector:Selector) -> (){
        
        mj_header = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: selector)
        
    }
    
    //MARK:底部刷新
    func setupFooterRefresh(target:Any,selector:Selector) -> (){
        mj_footer = MJRefreshAutoFooter(refreshingTarget: target, refreshingAction: selector)
    }
    
    //MARK:开始头部刷新
    func headerBeginRefreshing()  {
        mj_header.beginRefreshing()
    }
    
    //MARK:结束刷新
    func endRefresh()  {
        mj_header.endRefreshing()
        mj_footer.endRefreshing()
    }
    
    //MARK:结束头部刷新
    func headerEndRefresh()  {
        mj_header.endRefreshing()
    }
    
    //MARK:结束底部刷新
    func footerEndRefresh()  {
        mj_footer.endRefreshing()
    }
    
    //MARK:带动画的头部刷新
    func setupGifHeaderRefresh(target:Any,selector:Selector) -> () {
        
        let header =  MJRefreshGifHeader.init(refreshingTarget: target, refreshingAction: selector)
        
        var imageArr:[UIImage] = []
        for i in 0...32 {
            let image = UIImage(named:"xy_loading_"+"\(i)"+"_32x32_")
            imageArr.append(image!)
        }
        header?.setImages(imageArr, for: MJRefreshState.refreshing)
        header?.setImages([imageArr[0]], duration: 0.5, for: MJRefreshState.pulling)
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        mj_header = header
        
    }
    
}

extension UITableView {
    
    
    //MARK:头部刷新
    func setupHeaderRefresh(target:Any,selector:Selector) -> (){
        
        mj_header = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: selector)
        
    }
    
    //MARK:底部刷新
    func setupFooterRefresh(target:Any,selector:Selector) -> (){
        mj_footer = MJRefreshAutoFooter(refreshingTarget: target, refreshingAction: selector)
    }
    
    //MARK:开始头部刷新
    func headerBeginRefreshing()  {
        mj_header.beginRefreshing()
    }
    
    //MARK:结束刷新
    func endRefresh()  {
        
        mj_header.endRefreshing()
        
        mj_footer.endRefreshing()
    }
    
    //MARK:结束头部刷新
    func headerEndRefresh()  {
        
        mj_header.endRefreshing()
        
    }
    
    //MARK:结束底部刷新
    func footerEndRefresh()  {
        
        mj_footer.endRefreshing()
    }
    
    //MARK:带动画的头部刷新
    func setupGifHeaderRefresh(target:Any,selector:Selector) -> () {
        
        let header =  MJRefreshGifHeader.init(refreshingTarget: target, refreshingAction: selector)
        
        var imageArr:[UIImage] = []
        for i in 0...32 {
            let image = UIImage(named:"xy_loading_"+"\(i)"+"_32x32_")
            imageArr.append(image!)
        }
        header?.setImages(imageArr, for: MJRefreshState.refreshing)
        header?.setImages([imageArr[0]], duration: 0.5, for: MJRefreshState.pulling)
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        mj_header = header
        
    }
    
}
