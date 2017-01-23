////
////  FBHelper.swift
////  RAB
////
////  Created by RAB on 1/21/16.
////  Copyright © 2016 Rab LLC. All rights reserved.
////
//
//import Foundation
//import FBSDKLoginKit
//import FBSDKCoreKit
//import FBSDKShareKit
//import FBAudienceNetwork
//
//
//class FBHelper{
//    var accessToken: FBSDKAccessToken?
//    let baseUrl = "https://graph.facebook.com/v2.4/"
//    init(){
//        accessToken = FBSDKAccessToken.currentAccessToken()
//    }
//    
//    func fetchFriendsPhoto(link:String, completionHandler: (img:UIImage)->()){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//            
//            //http://graph.facebook.com/v2.4/10150192451235958/picture?type=thumbnail
//            let userImageURL = "\(self.baseUrl)\(link)/picture?type=album&access_token=\(self.accessToken!.tokenString)";
//            
//            let url = NSURL(string: userImageURL);
//            
//            let imageData = NSData(contentsOfURL: url!);
//            
//            if let imageDataHas = imageData{
//                let image = UIImage(data: imageData!);
//                
//                completionHandler(img: image!)
//            }
//            
//        })
//    }
//    
//    func fetchPhoto(link:String, addItemToTable: (album:AlbumImage)->()){
//        
//        let fbRequest = FBSDKGraphRequest(graphPath: link, parameters: nil, HTTPMethod: "GET")
//        fbRequest.startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, data:AnyObject!, error:NSError!) -> Void in
//            if let gotError = error{
//                println("Error: %@", gotError)
//            }
//            else{
//                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//                    
//                    //println(data)
//                    var pictures:[AlbumImage] = [AlbumImage]();
//                    let graphData = data.valueForKey("data") as Array;
//                    var albums:[AlbumModel] =  [AlbumModel]();
//                    
//                    for obj:AnyObject in graphData{
//                        //println(obj.description);
//                        //println(obj)
//                        
//                        let pictureId = obj.valueForKey("id") as String;
//                        
//                        let smallImageUrl = "\(self.baseUrl)\(pictureId)/picture?type=thumbnail&access_token=\(self.accessToken!.tokenString)";
//                        let url = NSURL(string: smallImageUrl);
//                        let picData = NSData(contentsOfURL: url!);
//                        
//                        var img:UIImage? = nil
//                        if let picDataHas = picData{
//                            img = UIImage(data: picData!);
//                        }
//                        
//                        
//                        let bigImageUrl = "\(self.baseUrl)\(pictureId)/picture?type=normal&access_token=\(self.accessToken!.tokenString)";
//                        let sourceURL = NSURL(string: bigImageUrl)
//                        let sourceData = NSData(contentsOfURL: sourceURL!)
//                        
//                        var sourceImg:UIImage? = nil
//                        if let hasSouceData = sourceData{
//                            sourceImg = UIImage(data: hasSouceData)
//                        }
//                        
//                        
//                        let commentLink = "\(self.baseUrl)\(pictureId)/comments?access_token=\(self.accessToken!.tokenString)"
//                        let likeLink = "\(self.baseUrl)\(pictureId)/likes?access_token=\(self.accessToken!.tokenString)"
//                        
//                        
//                        var commentsByUser = self.executeComment(commentLink)
//                        var likesByUser = self.executeLike(likeLink)
//                        
//                        
//                        
//                        //println("Comment: \(commentLink)")
//                        //println("Like: \(likeLink)")
//                        
//                        
//                        
//                        //pictures.append(AlbumImage(smallImage: img!, bigImage: sourceImg!));
//                        addItemToTable(album: AlbumImage(smallImage: img!, bigImage: sourceImg!, likes: likesByUser, comments: commentsByUser))
//                        //NSThread.sleepForTimeInterval(2)
//                    }
//                    NSNotificationCenter.defaultCenter().postNotificationName("photoNotification", object: nil, userInfo: nil);
//                })
//                
//                
//            }
//        }
//        
//        
//    }
//    
//    func executeLike(likeLink:String) -> [Like]{
//        let request = NSMutableURLRequest(URL: NSURL(string: likeLink)!)
//        request.HTTPMethod = "GET"
//        var likes = [Like]()
//        
//        var responseObject:NSURLResponse?
//        var err:NSErrorPointer = NSErrorPointer()
//        
//        let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &responseObject, error: err)
//        if let response = responseData{
//            if(err == nil){
//                var likeResponse: AnyObject? = NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.AllowFragments, error: nil)
//                
//                //println(likeResponse)
//                if let likeDict:NSDictionary = likeResponse as? NSDictionary{
//                    let data = likeDict.objectForKey("data") as NSArray
//                    //println(data)
//                    for likeObj in data{
//                        likes.append(Like(likeBy: likeObj.valueForKey("name") as? String, likeDate: "", likeByUrl: likeObj.valueForKey("id") as? String, likeByImage: nil))
//                    }
//                    
//                }
//            }
//        }
//        return likes
//    }
//    
//    
//    func executeComment(commentLink:String) -> [Comment]{
//        let request = NSMutableURLRequest(URL: NSURL(string: commentLink)!)
//        request.HTTPMethod = "GET"
//        var comments = [Comment]()
//        
//        var responseObject:NSURLResponse?
//        var err:NSErrorPointer = NSErrorPointer()
//        
//        let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &responseObject, error: err)
//        if let response = responseData{
//            if(err == nil){
//                var likeResponse: AnyObject? = NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.AllowFragments, error: nil)
//                
//                //println(likeResponse)
//                if let likeDict:NSDictionary = likeResponse as? NSDictionary{
//                    let data = likeDict.objectForKey("data") as NSArray
//                    //println(data)
//                    for commentObj in data{
//                        comments.append(Comment(commentString: commentObj.valueForKey("message") as? String, commentBy: commentObj.valueForKey("from")?.valueForKey("name") as? String, commentLocation: "", commentDate: "", commentByUrl: commentObj.valueForKey("from")?.valueForKey("id") as? String, commentByImage: nil))
//                    }
//                }
//            }
//            
//        }
//        return comments
//    }
//    
//    
//    
//    func fetchCoverPhoto(coverLink: String, completion:(image:UIImage)->()){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//            
//            
//            //http://graph.facebook.com/v2.4/10150192451235958/picture?type=thumbnail
//            let userImageURL = "\(self.baseUrl)\(coverLink)?type=album&access_token=\(self.accessToken!.tokenString)";
//            
//            let url = NSURL(string: userImageURL);
//            
//            let imageData = NSData(contentsOfURL: url!);
//            
//            if let imageDataHas = imageData{
//                let image = UIImage(data: imageData!);
//                
//                completion(image: image!)
//            }
//            
//        })
//    }
//    
//    func fetchNewPhoto(link:String, completionHandler:()->()){
//        
//        let fbRequest = FBSDKGraphRequest(graphPath: link, parameters: nil, HTTPMethod: "GET")
//        
//        fbRequest.startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, data:AnyObject!, error:NSError!) -> Void in
//            if let gotError = error{
//                println("Error: %@", gotError)
//            }
//            else{
//                println(data)
//            }
//        }
//    }
//    
//    
//    
//    
//    func fetchAlbum(user:User){
//        
//        let userImageURL = "\(self.baseUrl)\(user.id)/albums?access_token=\(self.accessToken!.tokenString)";
//        
//        let graphPath = "/\(user.id)/albums";
//        let request =  FBSDKGraphRequest(graphPath: graphPath, parameters: nil, HTTPMethod: "GET")
//        request.startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//            if let gotError = error{
//                println(gotError.description);
//            }
//            else{
//                println(result)
//                let graphData = result.valueForKey("data") as Array;
//                var albums:[AlbumModel] =  [AlbumModel]();
//                for obj:AnyObject in graphData{
//                    let desc = obj.description;
//                    //println(desc);
//                    let name = obj.valueForKey("name") as String;
//                    //println(name);
//                    let id = obj.valueForKey("id") as String;
//                    var cover = "";
//                    
//                    cover = "\(id)/picture";
//                    
//                    
//                    //println(coverLink);
//                    let link = "\(id)/photos";
//                    
//                    let model = AlbumModel(name: name, link: link, cover:cover);
//                    albums.append(model);
//                    
//                }
//                NSNotificationCenter.defaultCenter().postNotificationName("albumNotification", object: nil, userInfo: ["data":albums]);
//            }
//        }
//    }
//    
//    func logout(){
//        FBSDKLoginManager().logOut()
//    }
//    
//    func readPermission() -> [String]{
//        return ["email", "user_photos", "user_friends", "public_profile"]
//    }
//    
//    func login(){
//        
//        let loginManager = FBSDKLoginManager()
//        loginManager.logInWithReadPermissions(["email", "public_profile", "user_friends", "user_photos"], handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
//            
//            if let gotError = error{
//                //got error
//            }
//            else if(result.isCancelled){
//                println("login canceled")
//            }
//            else{
//                
//                println(result.grantedPermissions)
//                if(result.grantedPermissions.containsObject("email")){
//                    
//                    let request = FBSDKGraphRequest(graphPath: "me", parameters: nil, HTTPMethod: "GET")
//                    request.startWithCompletionHandler({ (connection:FBSDKGraphRequestConnection!, data:AnyObject!, error:NSError!) -> Void in
//                        
//                        if let gotError = error{
//                            //got error
//                        }
//                        else {
//                            
//                            //println(data)
//                            
//                            let email : String = data.valueForKey("name") as String;
//                            let firstName:String = data.valueForKey("name") as String;
//                            let userFBID:String = data.valueForKey("id") as String;
//                            let userImageURL = "https://graph.facebook.com/\(userFBID)/picture?type=small";
//                            
//                            let url = NSURL(string: userImageURL);
//                            
//                            let imageData = NSData(contentsOfURL: url!);
//                            
//                            let image = UIImage(data: imageData!);
//                            
//                            println("userFBID: \(userFBID) Email \(email) \n firstName:\(firstName) \n image: \(image)");
//                            
//                            var userModel = User(email: email, name: firstName, image: image!, id: userFBID);
//                            
//                            
//                            NSNotificationCenter.defaultCenter().postNotificationName("PostData", object: userModel, userInfo: nil);
//                        }
//                    })
//                    
//                    self.accessToken = FBSDKAccessToken.currentAccessToken();
//                }
//                
//            }
//        })
//    }
//    
//}
