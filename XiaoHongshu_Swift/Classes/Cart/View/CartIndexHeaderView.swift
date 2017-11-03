//
//  CartIndexHeaderView.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/15.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import SDCycleScrollView
class CartIndexHeaderView: UIView,SDCycleScrollViewDelegate {
    
    //banner
    lazy var playView:SDCycleScrollView={return SDCycleScrollView()}()
    //指示器
    lazy var indicator = {return UILabel()}()
    //总页码
    var pageCount:Int?
    
    //MARK: 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置子控件
        setupUIContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //设置子控件
    func setupUIContent(){
        
        addSubview(playView)
        playView.delegate = self
        
        playView.addSubview(indicator)
        indicator.textColor = UIColor.white
        indicator.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
        indicator.snp.makeConstraints { (make) in
            make.right.equalTo(playView.snp.right).offset(-15)
            make.bottom.equalTo(playView.snp.bottom).offset(-15)
        }
        
    }
    
    //数据源方法
    func fillterWith(dictArr:[[String:Any]]) ->CGFloat{
        
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        //累计高度
        var headerH :CGFloat = 0;
        
        for dict in dictArr {
            
            let model_type = dict["model_type"] as? String
            guard model_type != nil else {
                return headerH
            }
            
            if model_type!.contains("grids"){
                
                let item_height = dict["item_height"] as? CGFloat
                let item_width = dict["item_width"] as? CGFloat
                
                if let items = dict["items"] as? [[String:Any]] {
                    
                    let col = items.count
                    let scale = SCREEN_WIDTH / (item_width!*CGFloat(col))
                    let itemH = item_height!*scale
                    let itemW = item_width!*scale
                    
                    let contentView = UIView();
                    addSubview(contentView)
                    contentView.snp.makeConstraints({ (make) in
                        make.top.equalTo(self.snp.top).offset(headerH)
                        make.left.right.equalTo(self)
                        make.height.equalTo(itemH)
                    })
                    
                    for (index,item) in items.enumerated(){
                        
                        let iView = UIImageView()
                        contentView.addSubview(iView)
                        
                        iView.sd_setImage(with: URL(string:item["image"] as! String), placeholderImage: nil)
                        iView.contentMode = .scaleAspectFill
                        iView.snp.makeConstraints({ (make) in
                            make.left.equalTo(contentView.snp.left).offset(CGFloat((index%col))*itemW)
                            make.top.equalTo(contentView.snp.top)
                            make.height.equalTo(contentView.snp.height)
                            make.width.equalTo(itemW)
                        })
                    }
                    headerH += itemH;
                }
                
            }else if model_type!.contains("slides"){
                
                
                let item_height = dict["item_height"] as? CGFloat
                let item_width = dict["item_width"] as? CGFloat
                let bannerH = SCREEN_WIDTH*item_height!/item_width!
                
                var images:[String] = []
                if let items = dict["items"] as? [[String:Any]] {
                    for item in items{
                        images.append((item["image"] as? String)!)
                    }
                }
                
                addSubview(playView)
                playView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.snp.top).offset(headerH)
                    make.height.equalTo(bannerH)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.left.equalTo(self)
                }
                //总页码
                pageCount = images.count
                indicator.text = "1 / \(pageCount!)"
                playView.imageURLStringsGroup = images
                playView.bannerImageViewContentMode = .scaleAspectFill
                playView.autoScrollTimeInterval = 5
                playView.showPageControl = false
                playView.hidesForSinglePage = true
                
                headerH += bannerH
                
            }else if model_type!.contains("channels"){
                
                let contentView = UIView();
                contentView.backgroundColor = .white
                let itemH = 80*APP_SCALE;
                addSubview(contentView);
                contentView.snp.makeConstraints({ (make) in
                    make.left.right.equalTo(self)
                    make.top.equalTo(self.snp.top).offset(headerH)
                    make.height.equalTo(itemH)
                })
                headerH += itemH
                
                if let items = dict["items"] as? [[String:Any]] {
                    
                    let col = items.count
                    let itemW = SCREEN_WIDTH/CGFloat(col)
                    
                    for (index,item) in items.enumerated(){
                        
                        let iView = sepcialItemView();
                        contentView.addSubview(iView)
                        
                        iView.filleterWith(dict: item)
                        iView.snp.makeConstraints({ (make) in
                            make.left.equalTo(contentView.snp.left).offset(CGFloat((index%col))*itemW)
                            make.top.equalTo(contentView.snp.top)
                            make.height.equalTo(contentView)
                            make.width.equalTo(itemW)
                        })
                        
                    }
                    
                }
                
                
            }else if model_type!.contains("sale_event"){
                
                var contentH:CGFloat = 0
                
                let item_height = dict["item_height"] as? CGFloat
                let item_width = dict["item_width"] as? CGFloat
                
                let scale = SCREEN_WIDTH/item_width!;
                
                contentH += item_height! * scale
                
                let contentView = UIView()
                addSubview(contentView)
                
                //头部展示图片
                let iMGView = UIImageView()
                contentView.addSubview(iMGView)
                iMGView.sd_setImage(with: URL(string:dict["image"] as! String), placeholderImage: nil);
                iMGView.snp.makeConstraints({ (make) in
                    make.top.equalTo(contentView);
                    make.left.right.equalTo(contentView)
                    make.height.equalTo(contentH)
                })
                
                //商品列表
                if let goods_list = dict["goods_list"] as? [[String:Any]]{
                    
                    let scrollView = UIScrollView()
                    scrollView.backgroundColor = UIColor.white
                    contentView.addSubview(scrollView)
                    
                    var itemH:CGFloat = 0;
                    let item = goods_list[0]
                    let width = (item["width"] as! CGFloat) * scale
                    for (index,item) in goods_list.enumerated() {
                        
                        let itemView = GoodItemView()
                        scrollView.addSubview(itemView)
                        itemH = itemView.fillterWith(dict: item,scale:scale)
                        itemView.snp.makeConstraints({ (make) in
                            make.left.equalTo(CGFloat(index)*width);
                            make.width.equalTo(width)
                            make.top.equalTo(scrollView)
                            make.height.equalTo(itemH)
                        })
                        
                    }
                    
                    scrollView.snp.makeConstraints({ (make) in
                        make.top.equalTo(iMGView.snp.bottom)
                        make.left.right.equalTo(contentView)
                        make.height.equalTo(itemH)
                    })
                    scrollView.contentSize = CGSize(width:width*CGFloat(goods_list.count), height: 0);
                    contentH += itemH
                    
                }
                
                contentView.snp.makeConstraints({ (make) in
                    make.left.right.equalTo(self)
                    make.top.equalTo(self.snp.top).offset(headerH)
                    make.width.equalTo(self.snp.width)
                    make.height.equalTo(contentH)
                })
                headerH += contentH;
                
            }
            
        }
        
        return headerH;
        
    }
    
    
}

extension CartIndexHeaderView {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        if pageCount != nil {
            indicator.text = "\(index+1) / \(pageCount!)"
        }
    }
}

//商品Item
class GoodItemView:UIView{
    
    //描述图片
    lazy var iView = {return UIImageView()}()
    //标题
    lazy var descLabel = {return UILabel()}()
    //价格
    lazy var discountPriceLabel = {return UILabel()}()
    //原价
    lazy var priceLabel = {return UILabel()}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //设置子控件
    func setupContentView(){
        addSubview(iView)
        addSubview(descLabel)
        addSubview(discountPriceLabel)
        addSubview(priceLabel)
    }
    
    //数据源方法
    func fillterWith(dict:[String:Any],scale:CGFloat) -> CGFloat{
        
        var contentH:CGFloat = 0
        
        //描述图片
        if let url = dict["image"] as? String{
            
            let height = (dict["height"] as! CGFloat) * scale
            iView.sd_setImage(with: URL(string:url), placeholderImage: nil);
            iView.snp.remakeConstraints { (make) in
                make.top.equalTo(self)
                make.left.right.equalTo(self)
                make.height.equalTo(height);
            }
            contentH += height;
            
        }
        
        //标题
        if let desc = dict["desc"] as? String{
            
            descLabel.textColor = UIColor.gray
            descLabel.numberOfLines = 2;
            let width = (dict["width"] as! CGFloat) * scale
            
            //设置富文本内容
            descLabel.attributedText = NSAttributedString.init(string: desc)
            //设置段落
            let paraStyle = NSMutableParagraphStyle()
            //行段落
            paraStyle.lineBreakMode = NSLineBreakMode.byCharWrapping;
            /** 行高 */
            paraStyle.lineSpacing = 3.0*APP_SCALE;
            let attributes = [NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:UIFont.systemFont(ofSize: 12*APP_SCALE)]
            
            let lineH =  (desc as NSString).size(attributes:attributes).height
            let descH = (desc as NSString).boundingRect(with: CGSize(width:width - 2*5*APP_SCALE,height:2*lineH), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).height
            
            let attrText = NSAttributedString.init(string: desc, attributes: attributes)
            descLabel.attributedText = attrText
            
            descLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(iView.snp.bottom);
                make.left.equalTo(self).offset(5*APP_SCALE)
                make.right.equalTo(self).offset(-5*APP_SCALE)
                make.height.equalTo(descH)
            })
            contentH += descH;
        }
        
        return contentH
    }
    
}

//MARK: - 专区
class sepcialItemView: UIView {
    
    //标题
    lazy var titlebel:UILabel = {return UILabel()}()
    //文字描述
    lazy var descLabel:UILabel = {return UILabel()}()
    //描述图片
    lazy var iView:UIImageView = {return UIImageView()}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置子控件
        setupUIContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUIContent(){
        
        addSubview(titlebel)
        addSubview(descLabel)
        addSubview(iView)
        
    }
    
    func filleterWith(dict:[String:Any]){
        
        
        
        //标题
        if let title = dict["title"] as? String{
            titlebel.text = title
            titlebel.font = UIFont.boldSystemFont(ofSize: 14*APP_SCALE)
            titlebel.textColor = UIColor.darkGray
            titlebel.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(15*APP_SCALE)
                make.bottom.equalTo(self.snp.centerY).offset(-5*APP_SCALE)
            })
        }
        
        //描述文字
        if let desc = dict["desc"] as? String{
            descLabel.text = desc
            descLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            descLabel.textColor = UIColor.darkGray
            descLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(15*APP_SCALE)
                make.top.equalTo(self.snp.centerY).offset(5*APP_SCALE)
            })
        }
        
        //描述图片
        if let image = dict["image"] as? String{
            iView.sd_setImage(with: URL(string:image), placeholderImage: nil)
            iView.contentMode = .scaleAspectFit
            iView.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.snp.right).offset(-15*APP_SCALE)
                make.centerY.equalTo(self.snp.centerY)
                make.height.width.equalTo(self.snp.height).multipliedBy(0.5)
            })
        }
        
        titlebel.isHidden = false
        descLabel.isHidden = false
        
    }
    
}
