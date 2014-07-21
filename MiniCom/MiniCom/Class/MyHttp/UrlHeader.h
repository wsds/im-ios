//
//  UrlHeader.h
//  MiniCom
//
//  Created by wlp on 14-5-20.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#ifndef MiniCom_UrlHeader_h
#define MiniCom_UrlHeader_h


//NET
#define DefaultMess         @"正在处理中..."
#define ResponseMessKey     @"提示信息"

//URL

#define BaseURL @"http://im.lejoying.com"
#define BaseURL_IMAGE @"http://images1.lejoying.com/"

//#define BaseURL @"http://www.we-links.com"
//#define BaseURL_IMAGE @"http://images1.we-links.com"

//////////////////////////upload//////////////////////////

/*
http://im.lejoying.com/image/upload?phone=121&accessKey=lejoying&filename=aa.png&imagedata=1234

比传的4个参数，imagedata是图片或者音频的base64，filename是文件的名称，需要带后缀，filename 的名字是文件base64的sha1值，需要注意，上传文件之前需要调用image/check方法，判断该我该文件在服务器是否存在，返回true代表存在，false代表不存在，然后你就上传就Ok了。
*/
//http://im.lejoying.com/image/upload


#define URL_resources_upload [BaseURL stringByAppendingString:@"/image/upload"]

#define URL_resources_check [BaseURL stringByAppendingString:@"/image/check"]

//////////////////////////lbs//////////////////////////

#define URL_lbs_updatelocation [BaseURL stringByAppendingString:@"/lbs/updatelocation"]

#define URL_lbs_setgrouplocation [BaseURL stringByAppendingString:@"/lbs/setgrouplocation"]

#define URL_group_lbs_nearbygroups [BaseURL stringByAppendingString:@"/lbs/nearbygroups"]

#define URL_relation_lbs_nearbyaccounts [BaseURL stringByAppendingString:@"/lbs/nearbyaccounts"]


//////////////////////////session//////////////////////////

#define URL_session_event [BaseURL stringByAppendingString:@"/api2/session/event"]

//////////////////////////account//////////////////////////

#define URL_account_auth [BaseURL stringByAppendingString:@"/api2/account/auth"]

#define URL_account_verifyphone [BaseURL stringByAppendingString:@"/api2/account/verifyphone"]

#define URL_account_verifycode [BaseURL stringByAppendingString:@"/api2/account/verifycode"]

#define URL_account_get [BaseURL stringByAppendingString:@"/api2/account/get"]

#define URL_account_modify [BaseURL stringByAppendingString:@"/api2/account/modify"]

#define URL_account_exit [BaseURL stringByAppendingString:@"/api2/account/exit"]

//////////////////////////square//////////////////////////

#define URL_square_sendsquaremessage [BaseURL stringByAppendingString:@"/api2/square/sendsquaremessage"]

#define URL_square_getsquaremessage [BaseURL stringByAppendingString:@"/api2/square/getsquaremessage"]

#define URL_square_addsquarepraise [BaseURL stringByAppendingString:@"/api2/square/addsquarepraise"]

#define URL_square_getsquarecomments [BaseURL stringByAppendingString:@"/api2/square/getsquarecomments"]



//////////////////////////group//////////////////////////

#define URL_group_getgroupsandmembers [BaseURL stringByAppendingString:@"/api2/group/getgroupsandmembers"]

#define URL_group_getallmembers [BaseURL stringByAppendingString:@"/api2/group/getallmembers"]

#define URL_group_get [BaseURL stringByAppendingString:@"/api2/group/get"]

#define URL_group_create [BaseURL stringByAppendingString:@"/api2/group/create"]

#define URL_group_modify [BaseURL stringByAppendingString:@"/api2/group/modify"]

#define URL_group_addmembers [BaseURL stringByAppendingString:@"/api2/group/addmembers"]

#define URL_group_removemembers [BaseURL stringByAppendingString:@"/api2/group/removemembers"]

#define URL_group_getusergroups [BaseURL stringByAppendingString:@"/api2/group/getusergroups"]


//////////////////////////relation 密友//////////////////////////

//此接口用于获取 用户的分组及好友
#define URL_relation_getcirclesandfriends [BaseURL stringByAppendingString:@"/api2/relation/getcirclesandfriends"]

//此接口用于获取 请求要加你为好友的用户信息
#define URL_relation_getaskfriends [BaseURL stringByAppendingString:@"/api2/relation/getaskfriends"]

#define URL_relation_getfriends [BaseURL stringByAppendingString:@"/api2/relation/getfriends"]

//添加好友
#define URL_relation_addfriend [BaseURL stringByAppendingString:@"/api2/relation/addfriend"]

//好友请求 同意拒绝
#define URL_relation_addfriendagree [BaseURL stringByAppendingString:@"/api2/relation/addfriendagree"]

//修改备注
#define URL_relation_modifyalias [BaseURL stringByAppendingString:@"/api2/relation/modifyalias"]

//解除好友
#define URL_relation_deletefriend [BaseURL stringByAppendingString:@"/api2/relation/deletefriend"]

//////////////////////////circle 分组//////////////////////////

#define URL_circle_modify [BaseURL stringByAppendingString:@"/api2/circle/modify"]

#define URL_circle_delete [BaseURL stringByAppendingString:@"/api2/circle/delete"]

#define URL_circle_addcircle [BaseURL stringByAppendingString:@"/api2/circle/addcircle"]

#define URL_circle_moveorout [BaseURL stringByAppendingString:@"/api2/circle/moveorout"]

//////////////////////////message

#define URL_message_send [BaseURL stringByAppendingString:@"/api2/message/send"]


#endif
