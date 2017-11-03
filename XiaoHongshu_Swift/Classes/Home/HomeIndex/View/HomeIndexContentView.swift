//
//  HomeIndexContentView.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/6.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

class HomeIndexContentView: UIView {
    
    let header = MJRefreshNormalHeader()
    
    //动画代理
    lazy var animation:ShowNoteDetailAnimation = {
        let animation = ShowNoteDetailAnimation()
        animation.presentDelegate = self
        animation.dismissDelegate = self
        return animation
    }()
    
    
    //collectionView
    var collectionView:UICollectionView?
    
    //url
    var url:String = ""
    
    //当前View所在控制器
    var controller:HomeIndexController?
    
    //模型数组
    var contentArr:[HomeIndexModel]?
    
    //选中Item显示图片索引
    var showIndex:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置随机色
        backgroundColor = UIColor.clear
        
        //创建内容View
        setupUIContent()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}


//MARK: - 网络请求
extension HomeIndexContentView{
    
    //数据源方法
    func fillter(URL:String,title:String ,controller:HomeIndexController){
        url = URL
        
        self.controller = controller
        
        //设置刷新
        setupRefresh()
    }
    
    func setupRefresh() {
        
        collectionView!.setupGifHeaderRefresh(target:self,selector: #selector(refreshHeader))
        collectionView!.headerBeginRefreshing()
        
    }
    
    func refreshHeader(){
        
        let params:[String:Any] = [:]
        NetWokTool.request(type: requestType.get, url: url, params: params) { [weak self] (response:Any?, error:Error?) in
            
            if error == nil{
                if let tempDict = response as? [String:Any] {
                    
                    if let data = tempDict["data"] as? [[String:Any]]{
                        
                        self?.contentArr = HomeIndexModel.mj_objectArray(withKeyValuesArray: data) as? [HomeIndexModel]
                        self?.collectionView?.reloadData()
                        
                    }
                }
                
            }else{
                print(error!);
            }
            self?.collectionView!.headerEndRefresh()
        }
    }
    
}


//MARK: - UICollectionView 数据源代理方法
extension HomeIndexContentView:WaterFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    //MARK: 初始化设置
    func setupUIContent(){
        
        let layout = WaterFlowLayout()
        layout.columnsCount = 2;
        let margin:CGFloat = 10*APP_SCALE;
        layout.columnMargin = margin;
        layout.rowMargin = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        layout.delegate = self
        
        collectionView = UICollectionView(frame: CGRect(x:0,y:0,width:0,height:0), collectionViewLayout: layout)
        addSubview(collectionView!);
        collectionView!.delegate = self
        collectionView!.dataSource = self;
        collectionView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self);
        }
        
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.register(NoteInfoCell.self, forCellWithReuseIdentifier: NoteInfoCell.identifer)
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell =  collectionView.dequeueReusableCell(withReuseIdentifier: NoteInfoCell.identifer, for: indexPath) as! NoteInfoCell;
        if let model = contentArr?[indexPath.item]{
            cell.fillterItem(model: model){[weak self]
                ()->() in
                self?.showUserInfo(model: model)
            }
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = contentArr?[indexPath.row] {
            let detailVc = NoteDetailViewController()
            detailVc.fillterWith(model: model, handleblock: {[weak self] (index:Int) in
                print(index)
                self?.showIndex = index
            })
            let navigationVC =  NavigationController(rootViewController: detailVc)
            navigationVC.modalPresentationStyle = .custom
            navigationVC.transitioningDelegate = animation
            controller?.present(navigationVC, animated: true, completion: nil);
           
        }
    }
    
    
    func waterFlowLayout(layout: WaterFlowLayout, widthForItem: CGFloat, indexPath: IndexPath) -> CGFloat {
        
        guard contentArr?.count != 0 else{
            return 0
        }
        let model = contentArr?[indexPath.item]
        
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
        if let title = model!.title {
            
            if title.characters.count != 0{
                let lineH =  (title as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)]).height
                let rect = (title as NSString).boundingRect(with: CGSize(width:widthForItem - 10*APP_SCALE,height:lineH*2), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)], context: nil)
                
                height += rect.height + 5*APP_SCALE
                
            }
        }
        
        //内容描述
        if let desc = model!.desc {
            
            if desc.characters.count != 0{
                let lineH =  (desc as NSString).substring(to: 1).size(attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12*APP_SCALE)]).height
                let rect = (desc as NSString).boundingRect(with: CGSize(width:widthForItem - 10*APP_SCALE,height:lineH*2), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12*APP_SCALE)], context: nil)
                height += rect.height + 5*APP_SCALE
            }
            
        }
        
        //用户信息
        height += 40*APP_SCALE
        model!.setValue(height, forKeyPath: "cellHeight")
        
        return height
    }
    
    func showUserInfo(model:HomeIndexModel)  {//展示用户个人主页
        
        let userInfoVc = UserInfoViewController()
        userInfoVc.model = model
        controller?.navigationController?.pushViewController(userInfoVc, animated: true)
        
    }
    
}

//MARK: - 弹出动画代理方法
extension HomeIndexContentView:PresentAnimationDelegate{
    func presentAnimationView() -> UIView {
        let iMGView = UIImageView()
        guard let indexpath = collectionView?.indexPathsForSelectedItems?.first else {
            return UIView()
        }
        iMGView.contentMode = .scaleAspectFill
        iMGView.clipsToBounds = true
        let model = contentArr?[indexpath.item]
        if  let info = model?.images_list?.first as? [String :Any]{
            if let url = info["url"] as? String{
                iMGView.sd_setImage(with: URL(string:url), completed: nil)
            }
        }
        return iMGView
    }
    
    func presentAnimationFromFrame() -> CGRect {
        guard let indexpath = collectionView?.indexPathsForSelectedItems?.first else {
            return CGRect.zero
        }
        let cell =  collectionView?.cellForItem(at: indexpath)
        let frame = collectionView?.convert(cell!.frame, to: UIApplication.shared.keyWindow)
        let model = contentArr?[indexpath.item]
        var iviewH:CGFloat = 0
        if  let info = model?.images_list?.first as? [String :Any]{
            let width = info["width"] as? CGFloat
            let height = info["height"] as? CGFloat
            
            let scale = frame!.size.width/width!
            iviewH = height!*scale
        }
        return CGRect(x: frame!.origin.x, y: frame!.origin.y, width: frame!.size.width, height: iviewH)
        
    }
    
    func presentAnimationToFrame() -> CGRect {
        
        guard let indexpath = collectionView?.indexPathsForSelectedItems?.first else {
            return CGRect.zero
        }
        let model = contentArr?[indexpath.item]
        var iviewH:CGFloat = 0
        if  let info = model?.images_list?.first as? [String :Any]{
            let height = info["height"] as? CGFloat
            let width = info["width"] as? CGFloat
            let scale = SCREEN_WIDTH/width!
            iviewH = height!*scale
        }
        return CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: iviewH)
    }
}


//MARK: - 消失动画代理方法
extension HomeIndexContentView:DismissAnimationDelegate{
    func dismissAnimationView() -> UIView{
        let iView = UIImageView()
        guard let indexpath = collectionView?.indexPathsForSelectedItems?.first else {
            return UIView()
        }
        let model = contentArr?[indexpath.item]
        iView.contentMode = .scaleAspectFill
        iView.clipsToBounds = true
        //已经获取到对应展示图片索引:self.showIndex
        print(self.showIndex)
        print(model?.images_list?.count)
        if  let info = model?.images_list?[self.showIndex] as? [String :Any]{
            if let url = info["url"] as? String{
                iView.sd_setImage(with: URL(string:url), completed: nil)
            }
        }
        return iView
    }
    func dismissAnimationFromFrame() -> CGRect{
        guard let indexpath = collectionView?.indexPathsForSelectedItems?.first else {
            return CGRect.zero
        }
        let model = contentArr?[indexpath.item]
        var iviewH:CGFloat = 0
        //已经获取到对应展示图片索引:self.showIndex
        if  let info = model?.images_list?[self.showIndex] as? [String :Any]{
            let height = info["height"] as? CGFloat
            let width = info["width"] as? CGFloat
            let scale = SCREEN_WIDTH/width!
            iviewH = height!*scale
        }
        return CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: iviewH)
    }
    func dismissAnimationToFrame() -> CGRect{
        guard let indexpath = collectionView?.indexPathsForSelectedItems?.first else {
            return CGRect.zero
        }
        let cell =  collectionView?.cellForItem(at: indexpath)
        let frame =  collectionView?.convert(cell!.frame, to: UIApplication.shared.keyWindow)
        let model = contentArr?[indexpath.item]
        var iviewH:CGFloat = 0
        if  let info = model?.images_list?.first as? [String :Any]{
            let width = info["width"] as? CGFloat
            let height = info["height"] as? CGFloat
            
            let scale = frame!.size.width/width!
            iviewH = height!*scale
        }
        return CGRect(x: frame!.origin.x, y: frame!.origin.y, width: frame!.size.width, height: iviewH)
        
    }
}



