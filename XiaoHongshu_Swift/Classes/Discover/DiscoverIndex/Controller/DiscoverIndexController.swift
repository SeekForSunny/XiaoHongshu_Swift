//
//  DiscoverIndexController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//  发现

import UIKit
import SDCycleScrollView

class DiscoverIndexController: UITableViewController,SDCycleScrollViewDelegate {
    
    //MARK: - 懒加载
    //接口信息
    lazy var apiMap:[String:String]={
        
        let apiInfo = AppDelegate.apiInfo()
        if let apiMap = apiInfo["discover"] as? [String:String]  {
            return apiMap
        }
        return [:]
        
    }()
    
    //指示器
    lazy var indicator = {return UILabel()}()
    //总页码
    var pageCount:Int?
    
    //头部bannerView
    lazy var playView = { () -> SDCycleScrollView in
        
        let playView = SDCycleScrollView()
        playView.delegate = self
        playView.frame.size = CGSize(width: SCREEN_WIDTH, height: 125*APP_SCALE)
        self.tableView.tableHeaderView = playView
        
        //指示器
        
        playView.addSubview(self.indicator)
        self.indicator.textColor = .white
        self.indicator.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
        self.indicator.snp.makeConstraints({ (make) in
            make.right.equalTo(playView.snp.right).offset(-15)
            make.bottom.equalTo(playView.snp.bottom).offset(-10)
        })
        
        return playView
    }()
    
    
    //属性
    /**全球购*/
    var destination:[DiscoverGlobalBuyModel]?
    /**banner*/
    var events:[[String:Any]]?
    
    /**热门话题*/
    var topic:[DiscoverHotTopicModel]?
    /**热门视频*/
    var videos:[DiscoverHotVideosModel]?
    //热门长笔记
    var multi_notes:[DiscoverMuitiNotesModel]?
    //分组
    lazy var titleArr:[String] = {return ["热门话题","全球购物","热门视频","热门长笔记"]}()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = BACK_GROUND_COLOR
        tableView.separatorStyle = .none;
        
        //设置导航栏
        setupNavigationBar()
        
        //设置网络刷新
        setupRefresh()
        tableView.headerBeginRefreshing()
        
    }
    
    
    init() {
        super.init(style: UITableViewStyle.grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

//MARK: - 设置导航栏
extension DiscoverIndexController{
    
    
    func setupNavigationBar() {
        
        //设置搜索框
        let searchView = NavSearchView.viewWithTitle(title: "搜索笔记,商品和用户")
        navigationItem.titleView = searchView;
        
        //设置右侧Item
        let rightItem = UIBarButtonItem.item(normal: "btn_nav_invite_21x21_", selected: "", target: self, selector: #selector(rigtItemCliekd))
        navigationItem.rightBarButtonItems = rightItem
        
    }
    
    //MARK:导航栏右侧按钮点击事件
    func rigtItemCliekd(){
        
    }
    
    
}


//MARK: - 设置网络刷新
extension DiscoverIndexController{
    
    func setupRefresh(){
        
        tableView.setupGifHeaderRefresh(target: self, selector: #selector(refreshHeader))
        tableView.setupFooterRefresh(target: self, selector: #selector(loadMore))
        
    }
    
    //MARK:下拉刷新
    func refreshHeader(){
        print("下拉刷新")
        
        //加载头部内容
        var url = apiMap["banner"]
        let params:[String:Any] = [:]
        NetWokTool.request(type: requestType.get, url: url!, params: params) { [weak self](response:Any?, error:Error?) in
            
            if error != nil{
                print(error!);
            }else{
                
                if let responseObject = response as? [String:Any]{
                    
                    if let data = responseObject["data"] as? [String:Any]{
                        //全球购
                        if let destination = data["destination"] as? [[String:Any]]{
                            self?.destination = DiscoverGlobalBuyModel.mj_objectArray(withKeyValuesArray: destination) as? [DiscoverGlobalBuyModel];
                        }
                        //banner
                        if let events = data["events"] as? [[String:Any]]{
                            self?.events = events;
                            self?.setupPlayView(events: events);
                        }
                        //热门话题
                        if let topic = data["topic"] as? [[String:Any]]{
                            self?.topic = DiscoverHotTopicModel.mj_objectArray(withKeyValuesArray: topic) as? [DiscoverHotTopicModel];
                        }
                        //热门视频
                        if let videos = data["videos"] as? [[String:Any]]{
                            self?.videos = DiscoverHotVideosModel.mj_objectArray(withKeyValuesArray: videos) as? [DiscoverHotVideosModel];
                        }
                        
                    }
                    
                }
                
            }
            self?.tableView.reloadData()
            self?.tableView.headerEndRefresh()
        }
        
        
        //加载长笔记
        url = apiMap["multi_notes"]
        NetWokTool.request(type: requestType.get, url: url!, params: params) { [weak self](response:Any?, error:Error?) in
            
            if error != nil{
                print(error!);
            }else{
                if let responseObject = response as? [String:Any]{
                    
                    if let data = responseObject["data"] as? [[String:Any]]{
                        self?.multi_notes =  DiscoverMuitiNotesModel.mj_objectArray(withKeyValuesArray:  data) as? [DiscoverMuitiNotesModel]
                    }
                    
                }
                
            }
            self?.tableView.reloadData()
            self?.tableView.headerEndRefresh()
        }
        
    }
    
    
    //MARK:加载更多
    func loadMore(){
        print("加载更多")
    }
    
}



//MARK: - tableView数据源代理方法
extension DiscoverIndexController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else if section == 1{
            return 1;
        }else if section == 2{
            return 1;
        }else{
            return multi_notes?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return 80*APP_SCALE
        }else if section == 1{
            return 150*APP_SCALE
        }else if section == 2{
            return 150*APP_SCALE
        }else{
            return 120*APP_SCALE
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10*APP_SCALE
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        if section == 0 {//热门话题
            let cell = DiscoverHotTopicCell.cell(withTableView: tableView);
            if let model = topic?[indexPath.row] {
                let isLast = (indexPath.item - topic!.count + 1 == 0) ? true : false
                cell.fillter(model: model,isLast: isLast);
            }
            return cell;
        }else if section == 1{//全球购物
            let cell = DiscoverGlobalBuyCell.cell(withTableView: tableView);
            if destination != nil {
                cell.fillter(modelArr: destination!)
            }
            return cell;
        }else if section == 2{//热门视频
            let cell = DiscoverHotVideosCell.cell(withTableView: tableView);
            if videos != nil{
                cell.fillter(modelArr: videos!)
            }
            return cell;
        }else{//热门长笔记
            let cell = DiscoverMultiNotesCell.cell(withTableView: tableView);
            
            if let model = multi_notes?[indexPath.row] {
                let isLast = (indexPath.item - multi_notes!.count + 1 == 0) ? true : false
                cell.fillter(model: model,isLast: isLast)
            }
            
            return cell;
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35*APP_SCALE
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> DiscoverSectionHeaderView? {
        
        let sectionHeader = DiscoverSectionHeaderView.headerWith(tableView: tableView)
        sectionHeader.fillterWith(title: titleArr[section]){[weak self]  ()->() in
            self?.showMoreInSection(section)
        }
        return sectionHeader
        
    }
    
    //查看更多
    func showMoreInSection(_ section:Int){
        
        let apiInfo = AppDelegate.apiInfo();
        
        let showMoreVc = DiscoverShowMoreController();
        if section == 0 {
            showMoreVc.cellType = DiscoverHotTopicCell.self;
            if let dict = apiInfo["discover_hot_topic"] as? [String:String]{
                showMoreVc.api = dict["more"];
                showMoreVc.navTitle = "热门话题"
            }
        }else if section == 1{
            showMoreVc.cellType = DiscoverGlobalBuyCell.self;
            if let dict = apiInfo["discover_global_buy"] as? [String : String]{
                showMoreVc.api = dict["more"];
                showMoreVc.navTitle = "热门视频"
            }
        }else if section == 2{
            showMoreVc.cellType = DiscoverHotVideosCell.self;
        }else if section == 3{
            showMoreVc.cellType = DiscoverMultiNotesCell.self;
        }
        self.navigationController?.pushViewController(showMoreVc, animated: true);
    }
    
}


//MARK:设置banner
extension DiscoverIndexController{
    
    func setupPlayView(events:[[String:Any]]){
        
        var images:[String] = []
        for event in events {
            if let url = event["image"] as? String {
                images.append(url)
            }
        }
        pageCount = images.count;
        indicator.text = "1 / \(pageCount!)"
        playView.delegate = self
        playView.bannerImageViewContentMode = .scaleAspectFill
        playView.autoScrollTimeInterval = 5
        playView.imageURLStringsGroup = images
        playView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        playView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        playView.showPageControl = false
        playView.hidesForSinglePage = true
        
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        print(index)
        if pageCount != nil {
            indicator.text = "\(index+1) / \(pageCount!)"
        }
    }
    
}
