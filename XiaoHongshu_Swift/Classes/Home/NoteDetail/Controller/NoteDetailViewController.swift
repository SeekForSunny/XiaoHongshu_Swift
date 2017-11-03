//
//  NoteDetailViewController.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/25.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class NoteDetailViewController: UICollectionViewController {
    
    //传递的数据模型
    var model:HomeIndexModel?
    //间隙
    let margin:CGFloat = 10*APP_SCALE;
    //顶部View
    lazy var headerView:NoteDetailViewHeader = NoteDetailViewHeader()
    
    //顶部标题View
    lazy var titleView:UILabel = UILabel()
    
    //接口信息
    lazy var apiMap:[String:Any] = {
        
        let apiInfo = AppDelegate.apiInfo()
        let map = apiInfo["home_index_note_detail"] as?[String:Any]
        return map ?? ["error":"解析失败"]
        
    }()
    
    //布局变量
    let layout:WaterFlowLayout = WaterFlowLayout()
    
    //数据源
    lazy var contentArr:[HomeIndexModel] = [];
    
    //头部笔记详情
    lazy var detailInfo:[String:Any] = [:]
    //头部评论信息
    lazy var commentInfo:[String:Any] = [:]
    
    //当前选中Item所展示的图片索引
    var showIndex:Int = 0
    
    //回调block:传递当前选中Item所展示图片索引
    var handleblock:((Int)->())?
    
    init() {
        layout.columnsCount = 2;
        layout.columnMargin = margin;
        layout.rowMargin = margin;
        layout.edgeInset = UIEdgeInsetsMake(0, margin, margin, margin);
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillterWith(model:HomeIndexModel,handleblock:@escaping (Int)->())  {
        self.handleblock = handleblock
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置背景颜色
        collectionView?.backgroundColor = BACK_GROUND_COLOR
        
        //禁止自适应
        self.automaticallyAdjustsScrollViewInsets = false
        
        //注册组件
        collectionView?.register(NoteInfoCell.self, forCellWithReuseIdentifier: NoteInfoCell.identifer)
        
        //添加头部View
        collectionView?.addSubview(headerView)
        
        //加载网络数据
        loadDataInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //设置导航栏
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //返回按钮
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named:"navi_back_shadow_25x25_"), for: UIControlState.normal)
        backBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        backBtn.addTarget(self, action: #selector(turnBack), for: UIControlEvents.touchUpInside)

        titleView.text = "陈喵达"
        titleView.sizeToFit()
        titleView.textColor = .white
        titleView.font = UIFont.systemFont(ofSize: 18*APP_SCALE)
        navigationItem.titleView = titleView;
        titleView.alpha = 0
        
    }
    
    func turnBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - 设置头部View
extension NoteDetailViewController{
    
    func setupHeaderView(){
        
        let headerH = headerView.fillterWith(detailInfo: detailInfo, commentInfo: commentInfo) {[weak self] (height:CGFloat,index:Int) -> () in
            OperationQueue.main.addOperation({
                self?.showIndex = index
                
                if self?.handleblock != nil { self?.handleblock!(index) }
                
                guard let weakSelf = self else{ return }
                weakSelf.layout.edgeInset = UIEdgeInsetsMake(height, weakSelf.margin, weakSelf.margin, weakSelf.margin);
                weakSelf.headerView.snp.remakeConstraints({ (make) in
                    make.top.equalTo(weakSelf.collectionView!)
                    make.left.equalTo(weakSelf.collectionView!)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(height)
                })
            })
        }
        
        layout.edgeInset = UIEdgeInsetsMake(headerH, margin, margin, margin);
        headerView.snp.remakeConstraints({ (make) in
            make.top.equalTo(self.collectionView!)
            make.left.equalTo(self.collectionView!)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(headerH)
        })
    }
    
}

//MARK: - 加载网络数据
extension NoteDetailViewController{
    
    func loadDataInfo() {
        
        //加载笔记详情
        loadNoteDetail()
        
        //加载相关笔记
        loadAboutNotes()
        
    }
    
    //detail
    //加载笔记详情
    func loadNoteDetail() {
        
//        let url = apiMap["detail"] as? String
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        print(timeStamp)
        let url = "https://www.xiaohongshu.com/api/sns/v8/note/" + model!.id!
        let params:[String:Any] = ["deviceId":"FB7A814E-A1DD-4CBC-BDCB-7619DAF3DEE0","lang":"zh","oid":"596658bdb46c5d0fd3a7f5b5",
                                   "platform":"iOS","sid":"session.1184097392794470890","sign":"469ec66db124b36c22a1225aa5b68798",
                                   "size":"l","t":"1501384055"]
        NetWokTool.request(type: requestType.get, url: url, params: params) {[weak self] (response:Any?, error:Error?) in
            if error != nil{
                print(error!);
            }else{
                if let responseData = response as? [String:Any] {
                    if let data = responseData["data"] as? [String:Any]{
                        self?.detailInfo = data
                        //加载相关评论
                        self?.loadNoteComment()
                    }
                }
            }
        }
    }
    
    //comment
    //评论信息
    func loadNoteComment() {
        
        let url = apiMap["comment"] as? String
        let params:[String:Any] = [:]
        NetWokTool.request(type: requestType.get, url: url!, params: params) {[weak self] (response:Any?, error:Error?) in
            if error != nil{
                print(error!);
            }else{
                if let responseData = response as? [String:Any] {
                    if let data = responseData["data"] as? [String:Any]{
                        self?.commentInfo = data;
                        OperationQueue.main.addOperation({
                            //设置头部信息
                            self?.setupHeaderView()
                        })
                    }
                }
            }
        }
    }
    
    //about
    //加载相关笔记
    func loadAboutNotes() {
        
        let url = apiMap["about"] as? String
        let params:[String:Any] = [:]
        NetWokTool.request(type: requestType.get, url: url!, params: params) {[weak self] (response:Any?, error:Error?) in
            if error != nil{
                print(error!);
            }else{
                if let responseData = response as? [String:Any] {
                    if let data = responseData["data"] as? [[String:Any]]{
                        self?.contentArr =  HomeIndexModel.mj_objectArray(withKeyValuesArray: data) as! [HomeIndexModel]
                        self?.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    
}

//MARK: - WaterFlowLayoutDelegate
extension NoteDetailViewController:WaterFlowLayoutDelegate{
    func waterFlowLayout(layout: WaterFlowLayout, widthForItem: CGFloat, indexPath: IndexPath) -> CGFloat {
        guard contentArr.count != 0 else{
            return 0
        }
        let model = contentArr[indexPath.item]
        
        if let height = model.cellHeight as? CGFloat {
            return height;
        }
        
        var height:CGFloat = 0;
        //图片
        if let images_list  = model.images_list {
            
            if let info = images_list[0] as? [String:Any]{
                
                let imageH = (info["height"] as? CGFloat) ?? 0
                let imageW = (info["width"] as? CGFloat) ?? 0
                height = imageH/imageW * widthForItem
                
            }
            
        }
        
        //标题
        if let title = model.title {
            
            if title.characters.count != 0{
                let lineH =  (title as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)]).height
                let rect = (title as NSString).boundingRect(with: CGSize(width:widthForItem - 10*APP_SCALE,height:lineH*2), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)], context: nil)
                
                height += rect.height + 5*APP_SCALE
                
            }
        }
        
        //内容描述
        if let desc = model.desc {
            
            if desc.characters.count != 0{
                let lineH =  (desc as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)]).height
                let rect = (desc as NSString).boundingRect(with: CGSize(width:widthForItem - 10*APP_SCALE,height:lineH*2), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12*APP_SCALE)], context: nil)
                height += rect.height + 5*APP_SCALE
            }
            
        }
        
        //用户信息
        height += 40*APP_SCALE
        model.setValue(height, forKeyPath: "cellHeight")
        
        return height
    }
}

//MARK: - UICollectionView数据源代理方法
extension NoteDetailViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NoteInfoCell.identifer, for: indexPath) as! NoteInfoCell;
        if contentArr.count != 0{
            let model = contentArr[indexPath.item]
            cell.fillterItem(model: model){[weak self]
                ()->() in
                print("点击查看笔记详情回调");
            }
        }
        
        return cell;
    }
}


extension NoteDetailViewController{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let alpha = scrollView.contentOffset.y / 100
        let color = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: alpha)
        navigationController?.navigationBar.setBackgroundImage(UIImage.image(color: color), for: UIBarMetrics.default)
        
        titleView.alpha = alpha
        
    }
}
