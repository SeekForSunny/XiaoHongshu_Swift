//
//  HomeIndexController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import SnapKit

class HomeIndexController: UIViewController{
    
    //MARK: 懒加载
    //标题栏按钮数组
    lazy var optionCardArr:NSMutableArray = { return NSMutableArray() }();
    //接口信息
    lazy var url:String = {
        let apiInfo = AppDelegate.apiInfo();
        let url = apiInfo["home_titles"] as! String
        return url
    }()
    //标题数组
    lazy var titleArr:[[String:String]] = []
    
    //内容滚动View
    lazy var scrollView :UIScrollView = {
        return UIScrollView();
    }();
    
    //内容View数组
    lazy var contentViewArr:NSMutableArray = { return NSMutableArray()}();
    
    //选中按钮
    var selectBtn:UIButton = UIButton();
    
    //标题栏高度
    let TITLE_H = 44*APP_SCALE;
    
    //标题栏间隔
    let margin:CGFloat = 15*APP_SCALE;
    
    //标题栏
    lazy var titleView:UIScrollView = {return UIScrollView();}();
    
    //记录下标
    lazy var loadInfo:[Int:String] = {return [:]}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置背景颜色
        view.backgroundColor = BACK_GROUND_COLOR;
        
        //设置导航栏
        setupNavigationBar();
        
        //请求标题栏数据
        loadTitleInfo()
    }
    
}

extension HomeIndexController{
    
    //请求标题信息
    func loadTitleInfo()  {
        let params:[String:Any] = [:]
        NetWokTool.request(type: requestType.get, url: url, params: params) {[weak self] (response:Any?, error:Error?) in
            
            if error != nil {
                print(error!)
            }else{
                if let responseData = response as? [String:Any]{
                    if let data = responseData["data"] as? [[String:String]]{
                        self!.titleArr = data
                        //设置标题栏及内容View
                        self!.setupContentView();
                    }
                }
            }
        }
    }
}


//MARK:  - 初始化UIView
extension HomeIndexController{
    
    
    //MARK: 设置导航栏
    func setupNavigationBar() {
        
        //设置搜索框
        let searchView = NavSearchView.viewWithTitle(title: "搜索笔记,商品和用户")
        navigationItem.titleView = searchView;
        
        //设置右侧Item
        let rightItem = UIBarButtonItem.item(normal: "btn_cam_24x20_", selected: "", target: self, selector: #selector(rigtItemCliekd))
        navigationItem.rightBarButtonItems = rightItem
        
    }
    
    //MARK:点击导航栏右侧按钮
    func rigtItemCliekd() {
        
    }
    
    //MARK:设置内容显示View
    func setupContentView(){
        
        //设置标题栏
        setupTitleView();
        
        //设置滚动容器View
        scrollView.backgroundColor = UIColor.clear;
        view.addSubview(scrollView);
        scrollView.delegate = self;
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(TITLE_H);
            make.left.right.equalTo(view);
            make.bottom.equalTo(view.snp.bottom).offset(-49);
        }
        scrollView.isPagingEnabled = true;
        scrollView.contentSize = CGSize(width: CGFloat(optionCardArr.count)*SCREEN_WIDTH, height: 0);
        
        //默认滚动设置
        scrollViewDidEndDecelerating(scrollView)
        
    }
    
    //MARK: - 设置标题栏
    func setupTitleView() {
        
        //关闭自适应内边距
        self.automaticallyAdjustsScrollViewInsets = false;
        
        titleView.showsHorizontalScrollIndicator = false;
        view.addSubview(titleView);
        
        let TITLE_H = 44*APP_SCALE;
        titleView.snp.makeConstraints { (make) in
            make.left.width.equalTo(view);
            make.height.equalTo(TITLE_H);
        }
        titleView.backgroundColor = UIColor.white;
        
        var offsetX:CGFloat = 0.0;
        for (_,map) in titleArr.enumerated() {
            
            let title = map["name"]
            let optionBtn = UIButton();
            titleView.addSubview(optionBtn);
            optionCardArr.add(optionBtn);
            
            optionBtn.setTitle(title, for: UIControlState.normal);
            optionBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            optionBtn.setTitleColor(UIColor.red, for: UIControlState.selected);
            optionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14*APP_SCALE);
            optionBtn.sizeToFit();
            optionBtn.addTarget(self, action: #selector(optionBtnClicked), for: UIControlEvents.touchUpInside);
            
            optionBtn.snp.makeConstraints({ (make) in
                make.top.equalTo(titleView);
                make.left.equalTo(titleView.snp.left).offset(margin + offsetX);
                make.width.equalTo(optionBtn.frame.size.width);
                make.height.equalTo(TITLE_H);
            })
            offsetX += optionBtn.frame.size.width + margin;
            
        }
        titleView.bounces = false;
        titleView.contentSize = CGSize(width: offsetX, height: 0);
        
        //设置默认选中按钮
        if  let firstBtn = optionCardArr.firstObject {
            selectBtn = firstBtn as! UIButton;
            selectBtn.isSelected = true;
            selectBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14*APP_SCALE);
        }
        
        
    }
    
    //MARK:设置内容显示View
    func setupContentView(index:Int){
        
        NSLog("%d:-%@", index,titleArr[index]);
        if (loadInfo.index(forKey: index) != nil) {return}
        
        let contentView = HomeIndexContentView();
        scrollView.addSubview(contentView);
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(CGFloat(index)*SCREEN_WIDTH);
            make.top.equalTo(scrollView.snp.top);
            make.width.equalTo(SCREEN_WIDTH);
            make.height.equalTo(scrollView.snp.height);
        }
        contentViewArr.add(contentView);
        if let title = titleArr[index]["name"] {
            //用于判断是否已经加载过
            loadInfo.updateValue(title, forKey: index);

            let apiInfo = AppDelegate.apiInfo()
            if let apiArr = apiInfo["home"] as? [String]  {
                let url =  apiArr[index]
                contentView.fillter(URL:url,title:title,controller:self)
            }
            
        }
        
    }
    
    
}

//MARK: - UIScrollViewDelegate
extension HomeIndexController:UIScrollViewDelegate{
    
    //MARK:scrollView 停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index:Int = Int(scrollView.contentOffset.x/SCREEN_WIDTH);
        if let button = optionCardArr.object(at: index) as? UIButton {
            optionBtnClicked(sender: button as UIButton);
        }
        
        
        //设置滚动
        var offsetX = selectBtn.center.x - SCREEN_WIDTH*0.5;
        
        if(offsetX < 0){
            offsetX = 0;
        }
        
        //计算最大的标题视图滚动区域
        var maxOffsetX = titleView.contentSize.width - SCREEN_WIDTH + margin;
        
        if (maxOffsetX < 0) {
            maxOffsetX = 0;
        }
        
        if (offsetX > maxOffsetX) {
            offsetX = maxOffsetX;
        }
        
        titleView.setContentOffset(CGPoint(x:offsetX,y:0), animated: true);
        
    }
    
    
    //MARK: 标题按钮点击事件
    func optionBtnClicked(sender:UIButton) {
        
        selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        selectBtn.isSelected = false;
        sender.isSelected = true;
        selectBtn = sender;
        selectBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14);
        
        let index = optionCardArr.index(of: sender);
        //设置偏移位
        scrollView.setContentOffset(CGPoint(x:CGFloat(index)*SCREEN_WIDTH,y:0), animated: true);
        
        //设置具体内容view
        setupContentView(index: index);
    }
    
    
    
    
    
    
    
}
