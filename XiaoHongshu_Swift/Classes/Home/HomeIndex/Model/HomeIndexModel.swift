//
//  HomeIndexModel.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/10.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

class HomeIndexModel: NSObject {
    
    var comments:Any?//    comments = 64;
    var cursor_score:String?//    "cursor_score" = "1499616820.9400";
    /**描述*/
    var desc:String?//    desc = "\U7f51\U7ea2\U8d8a\U6765\U8d8a\U591a";
    var enabled:Any?//    enabled = 1;
    var fav_count:Any?//    "fav_count" = 4131;
    /**动态id*/
    var id:String?//    id = 595b5f4714de4150e112c074;
    /**图片描述*/
    var images_list:[Any]?
    //    "images_list" =     (
    //    {
    //    height = 1230;
    //    original = "http://ci.xiaohongshu.com/84e7519e-cca4-42a1-ae68-9ce6d07b71db";
    //    url = "http://ci.xiaohongshu.com/84e7519e-cca4-42a1-ae68-9ce6d07b71db@r_640w_640h.webp";
    //    width = 922;
    //    }
    //    );
    /***/
    var infavs:Any?//    infavs = 0;
    /***/
    var inlikes:Any?//    inlikes = 0;
    var level:Any?//    level = 2;
    var likes:Any?//    likes = 840;
    /**类型*/
    var model_type:String?//    "model_type" = note;
    var name:String?//    name = "\U4e0d\U6613\U649e\U886b\U7684tb\U597d\U5e97 \U8bbe\U8ba1\U611f\U5341\U8db3\Uff01";
    var newest_comments:[Any]?
    //    "newest_comments" =     (
    //    );
    var recommend:[String:Any]?
    //    recommend =     {
    //    desc = "";
    //    icon = "";
    //    "target_id" = "";
    //    "target_name" = "";
    //    "track_id" = "gl_36@59625635303168358f519ca9";
    //    type = group;
    //    };
    var relatedgoods_list:[Any]?
    //    "relatedgoods_list" =     (
    //    );
    var share_link:String?//    "share_link" = "http://www.xiaohongshu.com/discovery/item/595b5f4714de4150e112c074";
    var show_more:Any?//    "show_more" = 1;
    var time:String?//    time = "2017-07-04 17:26";
    var title:String?//    title = "\U4e0d\U6613\U649e\U886b\U7684tb\U597d\U5e97 \U8bbe\U8ba1\U611f\U5341\U8db3\Uff01";
    var type:String?//    type = normal;
    var user:[String:Any]?
    //    user =     {
    //    followed = 0;
    //    images = "https://img.xiaohongshu.com/avatar/5959a67db46c5d18053e58db.jpg@80w_80h_90q_1e_1c_1x.jpg";
    //    nickname = "Chocolate\Ud83d\Udc7c";
    //    userid = 5860b24b82ec392393890374;
    //    };
    var video_id:String?//    "video_id" = "";
    //计算高度
    var cellHeight:Any?
    

    
}
