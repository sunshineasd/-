# -
实现苹果手机不管是在前台，后台，还是杀死进程后，都能收到推送，并进行语音合成播报

相信很多做过推送的，都遇到过程序在前台，可以收到合成的语音提示，类似于到账金额XXX元，但在后台或者杀死进程后，有推送却没有声音。
苹果的退出到后台，过了一段时间后，程序就被挂起，想要在走回代码里的方法就不可能了。

Notification Service Extension 通知服务扩展
这是iOS 10.0推出的新功能。
按我的理解总结下来一句话，就是他能让你在收到远程推送的时候先对推送内容进行预处理，处理完之后，再让你的app进行处理。
而且这部分代码是和你本身app隔离开的（这个在接下来的代码环节会有个直观的认识），这样就给了我们单独处理相应推送的地方。下面就让我们具体的看一下怎么操作。

简单实现
一、为项目添加Notification Service Extension

首先打开你的项目 File ----> New ------> Target

选择Notification Service Extension 进行命名。这里Bundle identifier之类的内容，xcode会自动为你配置好，所以不用担心。
其实从这里可以看出来，这个target并不属于你的app里面的一部分，而是另一个全新的程序，但是他是和你的app绑定的，
这样，当推送来的时候iphone就知道究竟是谁的推送过来，需不需要进行额外处理。
Finish之后，你就可以在你的工程里看到你app的Notification Service Extension了。
需要注意的是，因为是两个完全独立的target所以，你原有项目里的自己写的类，或原有项目里的资源文件，
在Notification Service Extension里是完全访问不到的（打包之后也是两个完全独立的bundle）。
所以如果你想要使用项目里的资源或者文件，你需要拖到Notification Service Extension目录里面，才可以使用。


二、对推送内容进行预处理

接下来就是业务代码了，在生成的NotificationService.m文件里对推送来的payload进行处理，在这里，你可以进行一些操作，
例如修改推送的内容。要注意的是，并不是所有的推送都会走这个额外的方法。
必须是会弹出alert、并且payload里面要设置"mutable-content"字段的值为1，才会进入这个方法，这都是需要跟你们后台沟通的。
{
"aps": {
"alert": "This is some fancy message.",
"badge": 1,
"sound": "default",
"mutable-content": "1",
}
}


mutable-content让后台设置为true，不然不走扩展的方法


三、配置扩展需要的开关
点击原项目的 Capablities ----> Background Modes打开ON ----> 勾选最后两项就可以了

把扩展里的Deployment Target 改成 10.0，毕竟扩展10.0以后才能用哈。

之后你就可以感受到推送的快感，你可以将程序杀死。
如果你发现测试了但没声音，你可能需要换个手机试一下，推送是必须要打开的，不行的话，卸载APP重新安装就可以了。
其实推送扩展没啥代码的，很容易的，如果你觉得系统机器人声音难听，支付宝的好听，那是因为他们在扩展里加了判断，
声音是由多个音频文件合成的。
