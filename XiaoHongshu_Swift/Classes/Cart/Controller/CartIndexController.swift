//
//  CartIndexController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import MJExtension

class CartIndexController: UICollectionViewController ,WaterFlowLayoutDelegate{
    
    //MARK: - 懒加载
    let layout = WaterFlowLayout()
    //间隙
    let margin:CGFloat = 10*APP_SCALE;
    
    //商品
    var storeArr:[CartStoreModel] = {return []}()
    //头部View
    lazy var headerView:CartIndexHeaderView = {return CartIndexHeaderView()}()
    
    //接口信息
    lazy var  apiMap:[String:String] = {
        
        let dict = AppDelegate.apiInfo()
        
        if let cart = dict["cart"] as? [String:String]{
            return cart;
        }
        
        return [:]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置背景颜色
        collectionView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        collectionView?.backgroundColor = BACK_GROUND_COLOR
        
        //添加头部View
        collectionView?.addSubview(headerView)
        
        //注册Cell
        collectionView?.register(CartStoreCell.self, forCellWithReuseIdentifier: CartStoreCell.identifier)
        
        //设置导航栏
        setupNavigationBar()
        
        //设置网络
        setupRefresh()
        collectionView?.headerBeginRefreshing()
        
    }
    
    //初始化设置
    init() {
        
        layout.columnsCount = 2;
        layout.columnMargin = margin;
        layout.rowMargin = margin;
        layout.edgeInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        layout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 50*APP_SCALE)
        super.init(collectionViewLayout: layout)
        layout.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

//MARK: - 设置导航栏
extension CartIndexController{
    
    
    func setupNavigationBar() {
        
        //设置搜索框
        let searchView = NavSearchView.viewWithTitle(title: "搜索笔记,商品和用户")
        navigationItem.titleView = searchView;
        
        //设置右侧Item
        let rightItem = UIBarButtonItem.item(normal: "navi_store_category_30x30_", selected: "", target: self, selector: #selector(rigtItemCliekd))
        navigationItem.rightBarButtonItems = rightItem
        
    }
    
    //MARK:导航栏右侧按钮点击事件
    func rigtItemCliekd(){
        
    }
    
    
}

//MARK: - 网络相关
extension CartIndexController{
    
    
    func setupRefresh(){
        
        collectionView?.setupGifHeaderRefresh(target: self, selector: #selector(refreshHeader))
    }
    
    func refreshHeader(){
        
        let params:[String:Any] = [:]
        
        //请求头部信息
        if let url = apiMap["header"] {
            
            NetWokTool.request(type: requestType.get, url: url, params: params, resultBlock: { [weak self]  (response:Any?, error:Error?) in
                
                if error != nil{
                    print(error!)
                }else{
                    if let responseData = response as? [String:Any]{
                        if let data = responseData["data"] as? [[String:Any]]{
                            let headerH = self?.headerView.fillterWith(dictArr: data)
                            self?.layout.edgeInset = UIEdgeInsetsMake(headerH!, self!.margin, self!.margin, self!.margin);
                            self?.headerView.snp.makeConstraints { (make) in
                                make.top.equalTo((self?.collectionView)!)
                                make.left.equalTo((self?.collectionView)!)
                                make.height.equalTo(headerH!)
                                make.width.equalTo(SCREEN_WIDTH)
                            }
                        }
                    }
                }
                self?.collectionView?.headerEndRefresh()
            })
            
        }
        
        //请求商品信息
        
        if let url = apiMap["store"] {
            
            NetWokTool.request(type: requestType.get, url: url, params: params, resultBlock: {[weak self] (response:Any?, error:Error?) in
                
                if error != nil{
                    print(error!)
                }else{
                    if let responseData = response as? [String:Any]{
                        if let data = responseData["data"] as? [[String:Any]] {
                            self?.storeArr = CartStoreModel.mj_objectArray(withKeyValuesArray: data) as! [CartStoreModel];
                        }
                    }
                }
                self?.collectionView?.reloadData()
                self?.collectionView?.headerEndRefresh()
            })
            
        }
    }
    
    
}

//MARK: CollectionView数据源代理方法
extension CartIndexController{
    
    func waterFlowLayout(layout: WaterFlowLayout, widthForItem: CGFloat, indexPath: IndexPath) -> CGFloat {
        
        let model = storeArr[indexPath.item]
        
        if let height = model.cellHeight as? CGFloat {
            return height;
        }
        
        var height:CGFloat = 0
        
        //计算图片高度
        let imageH = (model.height as? CGFloat)!
        let imageW = (model.width as? CGFloat)!
        height = widthForItem * imageH/imageW
        
        //类型
        if let model_type = model.model_type {
            
            if model_type.contains("banner") {//大图模式
                return height;
            }
            
        }
        
        //-----普通Item类型
        //折扣信息
        //标题
        if let title = model.title {
            if title.characters.count != 0{
                let lineH = (title as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)]).height
                let rect = (title as NSString).boundingRect(with: CGSize(width:widthForItem - 2*5*APP_SCALE,height:lineH), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)], context: nil)
                
                height += rect.size.height + 5*APP_SCALE
            }
        }
        
        //描述
        if let desc = model.desc as? String {
            if desc.characters.count != 0{
                let lineH = (desc as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12*APP_SCALE)]).height
                let rect = (desc as NSString).boundingRect(with: CGSize(width:widthForItem - 2*5*APP_SCALE,height:2*lineH), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)], context: nil)
                
                height += rect.size.height + 5*APP_SCALE
            }
        }
        //其他信息
        height += 30*APP_SCALE
        
        //存储高度
        model.setValue(height, forKey: "cellHeight");
        return height
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> CartStoreCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartStoreCell.identifier, for: indexPath) as! CartStoreCell
        let model = storeArr[indexPath.item]
        cell.fillterWith(model:model)
        return cell
        
    }
    
}


