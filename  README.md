# Peer Review 6
#### A simple project for logging into Instagram, and pulling the latest photo from logged-in account.
##### This project is 6/15 Peer Review projects done in the course \"iOS Development for Creative Entrepreneurs\" by UCI.

***

This project uses a cocoa-pod ```NXOAuth2Client(1.2.8)``` for logging into the Instagram, since Instagram has no default settings in iOS.
It first will open Safari for your permissions to login instagram using the app.
Once you allow the permission instagram sends a secret key which identifies the account logged in by the app. This complete process of managing security is done by *NXOAuth2Client*.
Now after that the instagram site will redirect to a custom site where a small forward script is opened. This is done so that the App will be opened.

```
Note:
		The app needs to be registered with Instagram along with the forward site 
	(https://www.instagram.com/developer).
		The forward site's URL scheme has to be mentioned in the plist file along 
	'App Transport Security Settings''s field 'Exception Domains' needs to be
	set as 'api.instagam.com'
```
Once logged in we are able to download image from instagram by just hitting the *Refresh* button as shown below.

***

![PeerReview6](https://github.com/Ananta11/PeerReview5/raw/master/Common/Screenshot.png)
---
