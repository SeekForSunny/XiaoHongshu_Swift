//
//  NoteDetailViewHeader.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/28.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit


class NoteDetailViewHeader: UIView {//UIScrollView
    
    //Banner滚动容器View
    lazy var playView:UIScrollView = UIScrollView()
    //发布者信息View
    lazy var infoView:UIView = UIView()
    //评论View
    lazy var commentView:UITableView = UITableView()
    //图片数组
    lazy var images_list:[[String:Any]] = []
    //View累计高度
    var viewH:CGFloat = 0
    //头部描述图片高度
    var bannerVH:CGFloat = 0
    //文字描述View高度
    var infoVH:CGFloat = 0
    //评论View高度
    var commentVH:CGFloat = 0
    
    //评论内容
    var commentArr:[[String:Any]]?
    
    
    //图片滑动回调
    var handleblock:((CGFloat,Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化内容View
        setupContentView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //设置内容View
    func setupContentView(){
        
        
        //添加bannerView
        addSubview(playView)
        playView.delegate = self
        playView.isPagingEnabled = true
        
        //添加用户信息View
        addSubview(infoView)
        
        //添加评论View
        commentView.delegate = self;
        commentView.dataSource = self;
        addSubview(commentView)
        
        //背景颜色
        self.backgroundColor = BACK_GROUND_COLOR
        
        
    }
    
    
}


extension NoteDetailViewHeader{
    
    //MARK: - 数据源方法
    func fillterWith(detailInfo: [String:Any],commentInfo:[String:Any],handleblock:@escaping (CGFloat,Int)->())->CGFloat{
        
        self.handleblock = handleblock
        
        //设置头部描述图片
        setupPlayView(detailInfo: detailInfo)
        
        //设置笔记描述View
        setupInfoView(detailInfo:detailInfo);
        
        //设置评论View
        commentArr = commentInfo["comments"] as? [[String:Any]];
        setupCommentView()
        
        //计算总高度
        viewH = bannerVH + infoVH + SM_MRAGIN_10 + commentVH + SM_MRAGIN_10
        //        self.contentSize = CGSize(width: SCREEN_WIDTH, height: viewH);
        
        return viewH // min(viewH, SCREEN_HEIGHT)
    }
    
}


//MARK: - 设置描述详情View
extension NoteDetailViewHeader{
    
    func setupInfoView(detailInfo: [String:Any]){
        
        infoView.backgroundColor = .white
        //用户信息
        guard  let user = detailInfo["user"] as? [String:Any] else {
            return;
        }
        
        //头像
        let icoView = UIImageView()
        infoView.addSubview(icoView)
        let icoVH = 35*APP_SCALE
        infoVH += SM_MRAGIN_5 + icoVH + SM_MRAGIN_5
        if let images = user["images"] as? String{
            icoView.sd_setImage(with: URL(string:images), completed: nil)
            icoView.snp.makeConstraints{ (make) in
                make.top.equalTo(infoView.snp.top).offset(SM_MRAGIN_5)
                make.left.equalTo(infoView.snp.left).offset(SM_MRAGIN_15)
                make.size.equalTo(CGSize(width: icoVH, height: icoVH))
            }
            icoView.layer.cornerRadius = icoVH*0.5
            icoView.clipsToBounds = true
        }
        
        //昵称
        let nickNameLabel = UILabel()
        infoView.addSubview(nickNameLabel)
        if let nickname = user["nickname"] as? String{
            nickNameLabel.text = nickname
            nickNameLabel.font = UIFont.systemFont(ofSize: 14*APP_SCALE)
            nickNameLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(icoView.snp.right).offset(SM_MRAGIN_5)
                make.centerY.equalTo(icoView)
            })
        }
        
        //等级
        let iLevel = UIImageView();
        infoView.addSubview(iLevel)
        let levelH:CGFloat = 15*APP_SCALE
        if let level = user["level"] as? [String:Any]{
            if let image = level["image"] as? String{
                iLevel.sd_setImage(with: URL(string:image), completed: nil)
                iLevel.snp.makeConstraints{ (make) in
                    make.left.equalTo(nickNameLabel.snp.right).offset(SM_MRAGIN_5)
                    make.centerY.equalTo(nickNameLabel.snp.centerY)
                    make.size.equalTo(CGSize(width: levelH, height: levelH))
                }
            }
        }
        
        //是否关注
        let focusBtn = UIButton()
        infoView.addSubview(focusBtn)
        if let isFocus = detailInfo["enabled"] as? Bool{
            focusBtn.setTitle(isFocus == true ? "已关注":"+ 关注", for: UIControlState.normal);
            focusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
            focusBtn.backgroundColor = isFocus == true ? UIColor.clear : UIColor.red
            focusBtn.setTitleColor(isFocus == true ?UIColor.lightText:UIColor.white, for: UIControlState.normal)
            focusBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(icoView.snp.centerY)
                make.right.equalTo(infoView.snp.right).offset(-SM_MRAGIN_15)
                make.width.equalTo(70*APP_SCALE);
                make.height.equalTo(25*APP_SCALE)
            })
            focusBtn.layer.cornerRadius = SM_MRAGIN_5*0.5
            focusBtn.layer.borderColor = isFocus == true ? UIColor.lightText.cgColor:UIColor.red.cgColor
            focusBtn.layer.borderWidth = 0.5
            focusBtn.clipsToBounds = true
        }
        
        //底部分割线
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.lightGray
        infoView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints({ (make) in
            make.top.equalTo(icoView.snp.bottom).offset(SM_MRAGIN_5)
            make.left.equalTo(infoView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(0.5)
        })
        
        
        //笔记标题
        let titleLabel = UILabel()
        infoView.addSubview(titleLabel)
        if let title = detailInfo["title"] as? String{
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = SM_RANDOM_COLOR()
            titleLabel.font = UIFont.boldSystemFont(ofSize: 13*APP_SCALE)
            let titleH = (title as NSString).boundingRect(with: CGSize(width:SCREEN_WIDTH - 2*SM_MRAGIN_15,height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13*APP_SCALE)], context: nil).height
            titleLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(separatorLine.snp.bottom).offset(SM_MRAGIN_20)
                make.left.equalTo(icoView.snp.left)
                make.right.equalTo(focusBtn.snp.right)
                make.height.equalTo(titleH)
            })
            //标题顶部高度+标题高度
            infoVH += SM_MRAGIN_20 + titleH
        }
        
        //描述
        let descLabel = UILabel()
        infoView.addSubview(descLabel)
        if let desc = detailInfo["desc"] as? String{
            descLabel.numberOfLines = 0
            descLabel.attributedText = NSAttributedString.init(string: desc)
            
            //设置段落
            let paraStyle = NSMutableParagraphStyle()
            //行段落
            paraStyle.lineBreakMode = NSLineBreakMode.byCharWrapping;
            /** 行高 */
            paraStyle.lineSpacing = 3.0*APP_SCALE;
            
            let attributes = [NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:UIFont.systemFont(ofSize: 14*APP_SCALE)]
            let descH = (desc as NSString).boundingRect(with: CGSize(width:SCREEN_WIDTH - 2*SM_MRAGIN_15,height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).height
            
            let attrText = NSAttributedString.init(string: desc, attributes: attributes)
            descLabel.attributedText = attrText
            descLabel.backgroundColor = SM_RANDOM_COLOR()
            descLabel.textColor = UIColor.darkText
            print(desc)
            descLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(SM_MRAGIN_20)
                make.left.equalTo(icoView.snp.left)
                make.right.equalTo(focusBtn.snp.right)
                make.height.equalTo(descH)
            })
            //标题顶部高度+标题高度
            infoVH += SM_MRAGIN_20 + descH
            
        }
        
        //标签信息
        if let _ = detailInfo["hash_tag"]{
        }
        
        //发表日期
        let dateLabel = UILabel()
        infoView.addSubview(dateLabel)
        if let time = detailInfo["time"] as? String{
            dateLabel.text = (time as NSString).substring(with: NSMakeRange(5, 5))
            dateLabel.font = UIFont.systemFont(ofSize: 14*APP_SCALE)
            dateLabel.textColor = UIColor.lightGray
            dateLabel.sizeToFit()
            let timeH = dateLabel.frame.size.height
            dateLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(icoView.snp.left)
                make.top.equalTo(descLabel.snp.bottom).offset(SM_MRAGIN_20)
                make.height.equalTo(timeH)
            })
            infoVH += SM_MRAGIN_20 + timeH + SM_MRAGIN_20
        }
        
        //点赞次数
        let likesLabel = UILabel()
        infoView.addSubview(likesLabel)
        if let likes = detailInfo["likes"] as? Int{
            likesLabel.text = "\(likes)次赞"
            likesLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            likesLabel.textColor = UIColor.lightGray
            likesLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(infoView.snp.right).offset(-SM_MRAGIN_15)
                make.centerY.equalTo(dateLabel.snp.centerY)
            })
        }
        
        //收藏数
        let favLabel = UILabel()
        infoView.addSubview(favLabel)
        if let fav_count = detailInfo["fav_count"] as? Int{
            favLabel.text = "\(fav_count)次收藏"
            favLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            favLabel.textColor = UIColor.lightGray
            favLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(likesLabel.snp.centerY)
                make.right.equalTo(likesLabel.snp.left).offset(-SM_MRAGIN_5)
            })
        }
        
        infoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(bannerVH);
            make.left.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(infoVH)
        }
    }
    
}


extension NoteDetailViewHeader{
    //MARK: -  设置头部View
    
    func setupPlayView(detailInfo:[String:Any]) {
        if let images_list = detailInfo["images_list"] as? [[String:Any]]{
            
            self.images_list = images_list
            playView.contentSize = CGSize(width: SCREEN_WIDTH*CGFloat(images_list.count), height: 0);
            playView.backgroundColor = BACK_GROUND_COLOR
            
            for (index,item) in images_list.enumerated() {
                
                let iView = UIImageView()
                iView.contentMode = .scaleAspectFill
                iView.clipsToBounds = true
                if let imageURL = item["url"] as? String{
                    iView.sd_setImage(with: URL(string:imageURL), completed: nil)
                }
                playView.addSubview(iView)
                iView.snp.makeConstraints({ (make) in
                    make.left.equalTo(playView.snp.left).offset(CGFloat(index)*SCREEN_WIDTH)
                    make.top.equalTo(playView.snp.top)
                    make.width.equalTo(SCREEN_WIDTH);
                    make.height.equalTo(playView.snp.height);
                })
            }
            
            let item = images_list[0]
            let height = item["height"] as! CGFloat
            let width = item["width"] as! CGFloat
            let scale = SCREEN_WIDTH/width
            let itemH:CGFloat = height * scale
            bannerVH = itemH
            playView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.width.equalTo(self)
                make.height.equalTo(itemH)
            })
            
        }
        
    }
    
}

extension NoteDetailViewHeader:UIScrollViewDelegate{
    //MARK: - 顶部描述图片
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
        let item = images_list[index]
        let height = item["height"] as! CGFloat
        let width = item["width"] as! CGFloat
        
        let scale = SCREEN_WIDTH/width
        let itemH:CGFloat = height * scale
        if (self.handleblock != nil){
            viewH +=  itemH - bannerVH
            bannerVH = itemH
            //将当前展示的描述图片高度回调至上级界面
            self.handleblock!(viewH,index);
        }
        
        
        self.playView.snp.updateConstraints({ (make) in
            make.height.equalTo(itemH)
        })
        
        self.infoView.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(self.bannerVH)
        }
        
        self.commentView.snp.updateConstraints { (make) in
            make.top.equalTo(self.bannerVH + self.infoVH + SM_MRAGIN_10)
        }
        
        //更新高度头部约束
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
       setNeedsDisplay()
    }
    
}



//MARK: - 设置评论部分
extension NoteDetailViewHeader:UITableViewDelegate,UITableViewDataSource{
    
    func setupCommentView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        commentView.reloadData()
        commentView.separatorStyle = .none
        commentView.isScrollEnabled = false
        
        let headerView = UIView()
        let headerH = setupHeaderWith(headerView:headerView)
        commentView.tableHeaderView = headerView
        commentView.contentInset = UIEdgeInsetsMake(headerH, 0, 0, 0)
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(headerH)
            make.bottom.equalTo(commentView.snp.top)
            make.left.equalTo(commentView)
            make.width.equalTo(commentView)
        }
        
        commentVH = commentView.contentSize.height + headerH
        commentView.backgroundColor = UIColor.white
        commentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(bannerVH+infoVH+SM_MRAGIN_10)
            make.left.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(commentVH)
        }
        
    }
    
    
    //MARK:设置评论内容头部View
    func setupHeaderWith(headerView:UIView)->CGFloat{
        
        //累计头部高度
        var headerH:CGFloat = 0
        
        //分类标题
        let titleLabel = UILabel()
        headerView.addSubview(titleLabel)
        titleLabel.text = "笔记评论"
        titleLabel.font = UIFont.systemFont(ofSize: 14*APP_SCALE)
        titleLabel.textColor = UIColor.darkText
        titleLabel.sizeToFit()
        let titleSize = titleLabel.frame.size
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.top).offset(SM_MRAGIN_10)
            make.left.equalTo(headerView.snp.left).offset(SM_MRAGIN_20)
            make.size.equalTo(titleSize)
        }
        headerH += SM_MRAGIN_10 + titleSize.height
        
        //指示器
        let indicator = UIView()
        indicator.backgroundColor = UIColor.red
        headerView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-SM_MRAGIN_5)
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(3*APP_SCALE)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        //分割线
        let separatorLine = UIView()
        headerView.addSubview(separatorLine)
        separatorLine.backgroundColor = UIColor.lightGray
        separatorLine.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(SM_MRAGIN_10)
            make.left.equalTo(headerView.snp.left).offset(SM_MRAGIN_20)
            make.height.equalTo(0.5)
            make.right.equalTo(headerView.snp.right)
        }
        headerH += SM_MRAGIN_10 + 0.5
        
        //当前用户头像及评论按钮
        
        return headerH
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArr?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dict = commentArr?[indexPath.row]{
            let cellH =  NoteCommentCell.getCellHeightWith(dict:dict);
            return cellH
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NoteCommentCell.cellWith(tableView: tableView)
        if let dict = commentArr?[indexPath.row]{
            cell.fillterWith(dict: dict,index: indexPath.row)
        }
        return cell;
    }
    
    
}

//MARK: 评论cell
class NoteCommentCell: UITableViewCell {
    
    //重用标识
    static let reuseIdentifier = "NoteCommentCell"
    //头像
    lazy var icoView = UIImageView()
    //昵称
    lazy var nicknameLabel = UILabel()
    //评论内容
    lazy var contentLabel:UILabel = UILabel()
    //评论时间
    lazy var timeLabel = UILabel()
    //回复
    lazy var revertBtn = UIButton()
    //点赞
    lazy var praiseBtn = UIButton()
    //主要回复内容View
    lazy var subRevertView = UIView()
    //子回复内容
    lazy var subContentLabel:UILabel = UILabel()
    
    class func cellWith(tableView:UITableView)->NoteCommentCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil{
            cell = NoteCommentCell.init(style: UITableViewCellStyle.default, reuseIdentifier: NoteCommentCell.reuseIdentifier)
            cell?.selectionStyle = .none
        }
        return cell as! NoteCommentCell
    }
    
    //初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化子控件
    func setupContentView() -> () {
        addSubview(icoView)
        addSubview(nicknameLabel)
        addSubview(contentLabel)
        addSubview(timeLabel)
        addSubview(revertBtn)
        addSubview(praiseBtn)
        addSubview(subRevertView)
        subRevertView.addSubview(subContentLabel)
        
    }
    
    //MARK:  数据源方法
    func fillterWith(dict:[String:Any],index:Int){
        
        //cell累计高度
        var cellH:CGFloat = 0;
        
        guard let user = dict["user"] as? [String:Any]else {
            return
        }
        //评论者头像
        let icoWH = 35*APP_SCALE
        if let images = user["images"] as? String{
            icoView.sd_setImage(with: URL(string:images), completed: nil)
            icoView.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(SM_MRAGIN_15)
                make.top.equalTo(self.snp.top).offset(SM_MRAGIN_15)
                make.size.equalTo(CGSize(width:icoWH,height:icoWH))
            })
            icoView.layer.cornerRadius = icoWH*0.5
            icoView.clipsToBounds = true
            
            cellH += SM_MRAGIN_5 + icoWH
        }
        //评论者昵称
        if let nickname = user["nickname"] as? String {
            nicknameLabel.text = nickname;
            nicknameLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            nicknameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(icoView.snp.top)
                make.left.equalTo(icoView.snp.right).offset(SM_MRAGIN_15)
            })
        }
        
        //评论者评论信息
        if let content = dict["content"] as? String {
            contentLabel.text = content;
            contentLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            contentLabel.numberOfLines = 0
            let maxSize = CGSize(width: SCREEN_WIDTH - 3*SM_MRAGIN_15 - icoWH, height: CGFloat(MAXFLOAT))
            let contentH = contentLabel.sizeThatFits(maxSize).height
            contentLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(nicknameLabel.snp.bottom).offset(SM_MRAGIN_5)
                make.left.equalTo(nicknameLabel.snp.left)
                make.right.equalTo(self.snp.right).offset(-SM_MRAGIN_15)
                make.height.equalTo(contentH)
            })
            cellH += SM_MRAGIN_5 + contentH
        }
        //评论时间
        if let time = dict["time"] as? TimeInterval{
            let date = Date.init(timeIntervalSince1970: time+8*60*60)
            timeLabel.text = ("\(date)" as NSString).substring(with: NSMakeRange(5, 5))
            timeLabel.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
            timeLabel.sizeToFit()
            timeLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(contentLabel.snp.left)
                make.top.equalTo(contentLabel.snp.bottom).offset(SM_MRAGIN_5)
                make.height.equalTo(timeLabel.frame.size.height)
            })
            cellH += SM_MRAGIN_5 + timeLabel.frame.size.height
        }
        //点赞按钮
        praiseBtn.setTitle("赞", for: UIControlState.normal)
        praiseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
        praiseBtn.setTitleColor(UIColor.darkText, for: UIControlState.normal)
        praiseBtn.sizeToFit()
        praiseBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-SM_MRAGIN_5)
            make.centerY.equalTo(timeLabel.snp.centerY)
        }
        //回复按钮
        revertBtn.setTitle("回复", for: UIControlState.normal)
        revertBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12*APP_SCALE)
        revertBtn.setTitleColor(UIColor.darkText, for: UIControlState.normal)
        revertBtn.sizeToFit()
        revertBtn.snp.makeConstraints { (make) in
            make.right.equalTo(praiseBtn.snp.left).offset(-SM_MRAGIN_5)
            make.centerY.equalTo(timeLabel.snp.centerY)
        }
        
        //设置子View
        subRevertView.backgroundColor = BACK_GROUND_COLOR
        if let priority_sub_comments = dict["priority_sub_comments"] as? [Any]{
            guard priority_sub_comments.count != 0 else {
                return
            }
            //子回复内容
            guard let info = priority_sub_comments[0] as? [String:Any] else {
                return
            }
            //昵称内容
            guard let user = info["user"] as? [String:Any] else{
                return
            }
            
            guard  let nickname = user["nickname"] as? String else{
                return
            }
            
            guard  let content = info["content"] as? String else {
                return
            }
            
            subContentLabel.text = nickname + ":" + content
            subContentLabel.font = UIFont.systemFont(ofSize: 13*APP_SCALE)
            let maxSize = CGSize(width: SCREEN_WIDTH - 5*SM_MRAGIN_5 - icoWH, height: CGFloat(MAXFLOAT))
            let subContentH = subContentLabel.sizeThatFits(maxSize).height
            subContentLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(subRevertView.snp.left).offset(SM_MRAGIN_5)
                make.top.equalTo(subRevertView.snp.top).offset(SM_MRAGIN_10)
                make.height.equalTo(subContentH)
            })
            
            subRevertView.snp.makeConstraints({ (make) in
                make.left.equalTo(contentLabel.snp.left)
                make.top.equalTo(timeLabel.snp.bottom).offset(SM_MRAGIN_5)
                make.height.equalTo(subContentH + 2*SM_MRAGIN_10)
                make.right.equalTo(contentLabel.snp.right)
            })
            cellH += SM_MRAGIN_5 +  subContentH + 2*SM_MRAGIN_10
            
        }
    }
    
    //MARK: 计算高度
    class func getCellHeightWith(dict:[String:Any])->CGFloat{
        
        //头像宽高
        let icoWH = 35*APP_SCALE
        
        //cell累计高度
        var cellH:CGFloat = 0;
        
        guard let user = dict["user"] as? [String:Any]else {
            return cellH
        }
        //评论者昵称
        let maxSize = CGSize(width: SCREEN_WIDTH - 3*SM_MRAGIN_15 - icoWH, height: CGFloat(MAXFLOAT))
        if let nickname = user["nickname"] as? String {
            let nameH =  (nickname as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 13*APP_SCALE)], context: nil).height
            cellH += SM_MRAGIN_15 + nameH
        }
        
        //评论者评论信息
        if let content = dict["content"] as? String {
            let contentH =  (content as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 13*APP_SCALE)], context: nil).height
            cellH += SM_MRAGIN_5 + contentH
        }
        //评论时间
        if let time = dict["time"] as? TimeInterval{
            let timeH = ("\(time)" as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 13*APP_SCALE)], context: nil).height
            cellH += SM_MRAGIN_5 + timeH
        }
        
        //设置子View
        if let priority_sub_comments = dict["priority_sub_comments"] as? [Any]{
            guard priority_sub_comments.count != 0 else {
                return cellH
            }
            //子回复内容
            guard let info = priority_sub_comments[0] as? [String:Any] else {
                return cellH
            }
            //昵称内容
            guard let user = info["user"] as? [String:Any] else{
                return cellH
            }
            
            guard  let nickname = user["nickname"] as? String else{
                return cellH
            }
            
            guard  let content = info["content"] as? String else {
                return cellH
            }
            
            let maxSize = CGSize(width: SCREEN_WIDTH - 5*SM_MRAGIN_5 - icoWH, height: CGFloat(MAXFLOAT))
            let subContentH =  ( (nickname + content ) as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 13*APP_SCALE)], context: nil).height
            cellH += SM_MRAGIN_5 +  subContentH + 2*SM_MRAGIN_10
            
        }
        return cellH
        
    }
}
