![](https://github.com/shi-edward/iMessage-App/blob/master/Project-Image/331e6d85b608d71c4768cf9bdc8c0a881bd2b48cda39a3ee5e6b4b0d3255bfef95601890afd80709da39a3ee5e6b4b0d3255bfef95601890afd807094b42ce91c202d9b29c399c36bde2f353.png)

# iMessage-IOS-app

* a chat application to communicate with each other
* Designed application with swift to realize features including registration, email verification, login system, changing the username, password and image, creating and joining in a chat room, profile customisation and user interaction.
* Built background system based on Firebase to maintain and manage data
* the contraints have some problems, but the code is great, no problem

![](https://github.com/shi-edward/iMessage-App/blob/master/Project-Image/FuozbAn5S3Zkp1TgTKD3BzLkqsQk-2.png)

##Requirements
* Firebase account
* Mac & Xcode (nonsense word)

##Installation
```
$ cd your-project directory
$ pod init
$ pod install
$ open your-project.xcworkspace
```
Please follow the Firebase's document.
##To do list
* Use sketch3 to optimize UI
* Fix contrains problems
* Create a web application about it

##Custom
Configure firebase
```
target 'Connection' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  # Pods for Connection

  target 'ConnectionTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ConnectionUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
```



##Architecture

![](https://github.com/shi-edward/iMessage-App/blob/master/Project-Image/FqJBTyU77VBzLX5nmFhohwiVNqfl.png)

##Demo show

![](https://github.com/shi-edward/iMessage-App/blob/master/Project-Image/ezgif.com-video-to-gif-2.gif)

##Screenshots

![](https://github.com/shi-edward/iMessage-App/blob/master/Project-Image/FkwGdtpN4sV2uhTGQAH3nAcvaO6K.png)



##Discusssing

* [submit issue](https://github.com/shi-edward/iMessage-App/issues)
* email: edwardshi95@gmail.com
