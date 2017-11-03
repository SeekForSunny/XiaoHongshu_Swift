//
//  UserInfoViewController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/13.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit


class UserInfoViewController: UICollectionViewController,WaterFlowLayoutDelegate,UICollectionViewDelegateFlowLayout{
    
    //模型
    var model:HomeIndexModel?
    
    //用户笔记
    var notesArr:[HomeIndexModel]?
    
    let layout = WaterFlowLayout()
    
    //接口信息
    lazy var  apiMap:[String:String] = {
        let dict = AppDelegate.apiInfo()
        if let user = dict["home_index_user"] as? [String:String]{
            return user;
        }
        return [:]
    }()
    
    
    //初始化设置
    init() {
        super.init(collectionViewLayout: layout)
        layout.columnsCount = 2;
        let margin:CGFloat = 10*APP_SCALE;
        layout.columnMargin = margin;
        layout.rowMargin = margin;
        layout.edgeInset = UIEdgeInsetsMake(0, margin, margin, margin);
        layout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 50*APP_SCALE)
        layout.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置背景颜色
        collectionView!.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        collectionView!.backgroundColor = BACK_GROUND_COLOR
        
        //注册组件
        collectionView!.register(NoteInfoCell.self, forCellWithReuseIdentifier: NoteInfoCell.identifer)
        collectionView!.register(UserInfoReusableViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserInfoReusableViewHeader.identifier)
        //设置头部View
        setupHeaderView()
        
        //设置网络
        setupRefresh()
        headerRefresh()
        
    }
    
    //MARK:设置头部View
    func setupHeaderView(){
        
        let margin:CGFloat = 10*APP_SCALE;
        let header =  UserInfoViewHeader();
        let headerH = header.fillterWith(dict: [:])
        self.collectionView?.addSubview(header)
        layout.edgeInset = UIEdgeInsetsMake(headerH, margin, margin, margin);
        header.snp.makeConstraints { (make) in
            make.top.equalTo((self.collectionView?.snp.top)!)
            make.left.equalTo((self.collectionView?.snp.left)!)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(headerH);
        }
        header.backgroundColor = SM_RANDOM_COLOR()
    }
    
    
}


//MARK: - 设置网络请求
extension UserInfoViewController{
    
    func setupRefresh(){
        collectionView?.setupGifHeaderRefresh(target: self, selector: #selector(headerRefresh))
    }
    
    
    //MARK: - 头部刷新
    func headerRefresh(){
        
        //参数
        let params:[String:Any] = [:]
        
        //用户信息
        if let url =  apiMap["user"] {
            
            NetWokTool.request(type: requestType.get, url: url, params: params) {[weak self]  (response:Any?, error:Error?) in
                if error != nil{
                    print(error!)
                }else{
                    if let result = response {
                        print("用户信息:",result);
                    }
                }
                
                self?.collectionView?.headerEndRefresh()
            }
            
        }
        
        
        //用户笔记
        if let url = apiMap["notes"] {
            
            NetWokTool.request(type: requestType.get, url: url, params: params) {[weak self]  (response:Any?, error:Error?) in
                if error != nil{
                    print(error!)
                }else{
                    if let result = response as? [String:Any]{
                        if let data = result["data"] as? [String:Any]{
                            if let notes = data["notes"] as? [[String:Any]]{
                                self?.notesArr = HomeIndexModel.mj_objectArray(withKeyValuesArray: notes) as? [HomeIndexModel];
                                self?.collectionView?.reloadData()
                            }
                        }
                    }
                }
                
                self?.collectionView?.headerEndRefresh()
            }
            
        }
        
        
        //专辑
        if let url = apiMap["board"]{
            
            NetWokTool.request(type: requestType.get, url: url, params: params) {[weak self]  (response:Any?, error:Error?) in
                if error != nil{
                    print(error!)
                }else{
                    if let result = response {
                        print("专辑",result);
                    }
                }
                self?.collectionView?.headerEndRefresh()
            }
            
        }
        
        //推荐
        if let url = apiMap["recommend"]{
            
            NetWokTool.request(type: requestType.get, url: url, params: params) {[weak self]  (response:Any?, error:Error?) in
                if error != nil{
                    print(error!)
                }else{
                    if let result = response {
                        print("推荐",result);
                    }
                }
                self?.collectionView?.headerEndRefresh()
            }
            
        }
        
        
    }
    
}

//MARK:collectionView数据源代理方法
extension UserInfoViewController{
    
    func waterFlowLayout(layout: WaterFlowLayout, widthForItem: CGFloat, indexPath: IndexPath) -> CGFloat {

        let model = notesArr?[indexPath.item];
        guard model != nil else {
            return 0
        }

        if let height = model!.cellHeight as? CGFloat {
            return height;
        }
        
        var height:CGFloat = 0;
        //图片
        if let images_list  = model!.images_list {
            
            if let info = images_list[0] as? [String:Any]{
                
                let imageH = (info["height"] as? CGFloat) ?? 0
                let imageW = (info["width"] as? CGFloat) ?? 0
                height = imageH/imageW * widthForItem
                
            }
            
        }
        
        //标题
        let title = model!.title
        if title?.characters.count != 0{
            let lineH =  (title! as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)]).height
            let rect = (title! as NSString).boundingRect(with: CGSize(width:widthForItem - 10*APP_SCALE,height:lineH*2), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)], context: nil)
            height += rect.height + 5*APP_SCALE
            
        }
        
        //内容描述
        let desc = model!.desc
        if desc?.characters.count != 0{
            
            let lineH =  (desc! as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12*APP_SCALE)]).height
            let rect = (desc! as NSString).boundingRect(with: CGSize(width:widthForItem - 10*APP_SCALE,height:lineH*2), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12*APP_SCALE)], context: nil)
            height += rect.height + 5*APP_SCALE
            
        }
        
        //用户信息
        height += 40*APP_SCALE
        model!.setValue(height, forKeyPath: "cellHeight")
        return height
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesArr?.count ?? 0;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteInfoCell.identifer, for: indexPath) as! NoteInfoCell
        cell.backgroundColor = UIColor.white
        if let model = notesArr?[indexPath.item]  {
            cell.fillterItem(model: model){
             NSLog("展示用户详情回调")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserInfoReusableViewHeader.identifier, for: indexPath) as! UserInfoReusableViewHeader
        reusableView.fillterWith(titleArr: ["笔记","专辑"])
        reusableView.backgroundColor = SM_RANDOM_COLOR()
        return reusableView

    }
    
}
