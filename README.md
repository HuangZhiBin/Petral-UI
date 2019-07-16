![](http://www.koudaikr.cn/Petral/logo.png)

**Petral-UI**基于 Swift 实现的 UI 框架，功能包括：

- 1.UI 控件方法的连续调用
- 2.自动布局
- 3.解析 XML 布局(重点推荐)

## 接入条件

```
swift.version >= 4.0
```

## 接入方式

```Cocoapods
pod 'Petral-UI'
```

Petral-UI 主要是下面两个部分：

## 1.UI 控件方法的连续调用

连续设置 UIView 的属性，例如

```swift
let nameLabel = UILabel.init();
nameLabel.petralize()
  .frame(x: 0, y: 0, width: 80, height: 20)
  .text("姓名")
  .font(size: 14, bold: true)
  .textColor(UIColor.init(hexString: "#1f1f1f"));
```

通过直接调用.为前缀的方法，直接连续设置 View 的 UI 属性，与调用系统方法的 API 类似。可实现对 View 的连续设置，减少代码。
现有的 API 可以基本满足 UI 设置，大家可以根据实际需要自行添加更多的 API 方法。

## 2.自动布局

通过最少的代码，实现类似 AutoLayout/Masory 自动布局的功能，但代码量远少于这两个框架。

自动布局的使用步骤：

1.  View 初始化后，通过 addSubview()方法添加到当前页面。必须先执行 addSubview()方法，才能使用 Petral-UI 进行自动布局的设置。

```swift
self.view.addSubview(nameLabel);
```

2.访问 View 的 petralRestraint 属性的方法设置布局。

```swift
nameLabel.petralRestraint
.topIn(offset: 10) // View的顶部与父View的距离为10
.leftIn(offset: 20);// View的左边与父View的距离为20
```

---

### 自动布局的API

请参考：<a href="RestraintAPI.md">自动布局的API</a>

### 布局的级联更新

- **updateDependeds()**

View b 的位置受到 View a 的制约，View c 的位置受到 View b 的制约，若 View a 的位置或者大小发生改变，要保持之前的制约条件(Restraint)，需要手动调用 API 方法 a.petralRestraint.updateDependeds();进行更新，使 View b 和 View c 的位置和大小发生改变。不手动调用该方法，将不主动实现 UI 的级联更新。

```swift
a.petralRestraint.updateDependeds();
```

![](http://www.koudaikr.cn/Petral/relative.png)

![](http://www.koudaikr.cn/Petral/relative2.png)

### 布局冲突的情况

以下的情形会发生布局冲突，运行时抛出 fatalError：

- 同时设置 view 的 left、right 和 width 约束
- 同时设置 view 的 top、bottom 和 height 约束
- 同时设置 view 的 left、xCenter 约束
- 同时设置 view 的 right、xCenter 约束
- 同时设置 view 的 top、yCenter 约束
- 同时设置 view 的 bottom、yCenter 约束

运行时发现 fatalError 的情形，请通过下面的方法解决冲突。

### 解决布局冲突的办法

根据 fatalError 的说明，首先应了解冲突发生的具体规则，然后选择下面的其中一个方法解决冲突。

- 1.修改已有的约束条件（即改动已有的代码，重新修改约束条件）
- 2.**reset()** 重置布局
- 3.**remove(type: PetralRestraintType)** 删除冲突的约束条件

**PetralRestraintType**的类型：

| 类型    | 说明     |
| ------- | -------- |
| left    | 左约束   |
| right   | 右约束   |
| bottom  | 底约束   |
| top     | 顶约束   |
| xCenter | 水平居中 |
| yCenter | 垂直居中 |
| width   | 宽度约束 |
| height  | 高度约束 |

## 3.解析 XML 布局

通过新建 XML 的布局文件，实现 UI 控件的创建、属性设置、自动布局，实现 UI 层级的结构化，提高编辑及修改 UI 的效率。

### (1)新建 XML 布局文件

```XML
<?xml version="1.0" encoding="utf-8"?>
<views xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.koudaikr.cn/petral-ui.xsd">
  <label
    id="label1"
    frame="10,50,100,20"
    font="18"
    textColor="#555555"
    backgroundColor="#d3d3d3"
    text="发送短信"
    lines="1"
    align="right"
    top="image1;0"
    height="image1,0"></label>
</views>
```

#### 1.XML 布局文件的结构

XML 布局文件，即 iOS 代码在运行时动态地解析项目中指定的 XML 文件，实现 UI 的搭建与设置。

#### 2.必须遵循的原则

XML 布局代码的编写有一定的规范：

- 有且只有一个**views**根节点
- 指定 xsi（只需要复制上面的 xsi 配置，不作任何改动。xsd 文件提供了 XML 代码提示和校验的功能。）

  综上所述，XML 布局需保持以下的格式：

```XML
<?xml version="1.0" encoding="utf-8"?>
<views xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.koudaikr.cn/petral-ui.xsd">
  <!-- insert any view here -->
</views>
```

#### 3.XML 代码提示

- 推荐 VSCode 编辑 XML 代码，安装插件：**XML Language Support by Red Hat**

  ![](http://www.koudaikr.cn/Petral/xml.png)

- 属性值的类型可参考：PetralParser.swift

##### [1] 控件属性的值类型

| 控件属性类型    | 值格式 1              | 值格式 2     | 值格式 3         | 值格式 4           | 值格式 5 |
| --------------- | --------------------- | ------------ | ---------------- | ------------------ | -------- |
| NSTextAlignment | left                  | right        | center           | justified          | natural  |
|                 | 居左                  | 居右         | 居中             |                    |          |
| UIFont          | 12                    | 12+          |                  |                    |          |
|                 | 系统 12               | 系统 12 加粗 |                  |                    |          |
| UIEdgeInsets    | 10,20.0,30,40         |              |                  |                    |          |
|                 | top,left,bottom,right |              |                  |                    |          |
| CGSize          | 10,20.4               |              |                  |                    |          |
|                 | width,height          |              |                  |                    |          |
| CGPoint         | 10,20.4               |              |                  |                    |          |
|                 | x,y                   |              |                  |                    |          |
| Bool            | true                  | false        |                  |                    |          |
|                 | 真                    | 假           |                  |                    |          |
| CGRect          | 0                     | 100.0,200    | 10.0,20,100,200  |                    |          |
|                 | CGRect.zero           | width,height | x,y,width,height |                    |          |
| UIColor         | #d7d7d7               | d7d7d7       | rgb(100,200,231) | rgba(10,20,30,0.5) | red      |
|                 | HEX 值                | HEX 值       | RGB 值           | RGBA 值            | 颜色名   |

##### [2] 布局属性的值类型

| 布局属性类型 | 值格式 1                | 值格式 2           | 值格式 3                             | 值格式 4               |
| ------------ | ----------------------- | ------------------ | ------------------------------------ | ---------------------- |
| left         | 0                       | label1             | label1,100                           | label1;20              |
|              | 左边与 superView 距离 0 | 左边与 label1 相同 | 左边与 label1 偏离 100               | 左边与 label1 距离 100 |
| right        | 0                       | label1             | label1,100                           | label1;20              |
|              | 右边与 superView 距离 0 | 右边与 label1 相同 | 右边与 label1 偏离 100               | 右边与 label1 距离 100 |
| top          | 0                       | label1             | label1,100                           | label1;20              |
|              | 顶部与 superView 距离 0 | 顶部与 label1 相同 | 顶部与 label1 偏离 100               | 顶部与 label1 距离 100 |
| bottom       | 0                       | label1             | label1,100                           | label1;20              |
|              | 底部与 superView 距离 0 | 底部与 label1 相同 | 底部与 label1 偏离 100               | 底部与 label1 距离 100 |
| xCenter      | 0                       | label1             | label1,100                           |                        |
|              | x 与 superView 居中     | x 与 label1 居中   | x 与 label1 居中并偏离 100           |                        |
| yCenter      | 0                       | label1             | label1,100                           |                        |
|              | y 与 superView 居中     | y 与 label1 居中   | y 与 label1 居中并偏离 100           |                        |
| center       | 0                       | label1             | label1,20,30                         |                        |
|              | 与 superView 居中       | 与 label1 居中     | 与 label1 居中，x 偏离 20，y 偏离 30 |                        |
| width        | 0                       | label1             | label1,100                           |100%                        |
|              | 宽度为 0                | 宽度与 label1 相同 | 宽度与 label1 一致并偏离 100         |占据superView宽度的100%                        |
| height       | 0                       | label1             | label1,100                           |100%                        |
|              | 高度为 0                | 高度与 label1 相同 | 高度与 label1 一致并偏离 100         |占据superView高度的100%                        |

#### 4.控件的设置

XML 布局支持大部分可静态配置的 UI 控件，例如：UIView、UIButton、UIImageView 等。其中 UIView 可缩写成全部小写的 view，具体类型如下：

| 类型               | 缩写             |
| ------------------ | ---------------- |
| UIView             | view             |
| UIButton           | button           |
| UIImageView        | imageview        |
| UILabel            | label            |
| UIScrollView       | scrollview       |
| UITableView        | tableview        |
| UITextField        | textfield        |
| UITextView         | textview         |
| UICollectionView   | collectionview   |
| UIDatePicker       | datepicker       |
| UIPickerView       | pickerview       |
| UIProgressView     | progressview     |
| UISearchBar        | searchbar        |
| UISegmentedControl | segmentedcontrol |
| UISlider           | slider           |
| UIStepper          | stepper          |
| UISwitch           | switch           |
| UIWebView          | webview          |

除了上面的控件之外，还支持自定义控件，控件名称为对应的 class 类型，例如 RedImageView 是一个继承 UIImageView 的自定义类：

```XML
<?xml version="1.0" encoding="utf-8"?>
<views xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.koudaikr.cn/petral-ui.xsd">
  <RedImageView
    id="image1"
    frame="10,50,100,20"
    image="icon_profile"></RedImageView>
</views>
```

RedImageView 类可通用父类的属性，例如 image 属性

#### 5.控件的互相嵌套

全面支持系统和自定义控件之间的互相嵌套

```XML
<?xml version="1.0" encoding="utf-8"?>
<views xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.koudaikr.cn/petral-ui.xsd">
  <scrollview
            id="scrollview1"
            frame="10,370,300,120"
            contentSize="300,120"
            contentOffset="0,0"
            contentInset="10,20,10,10"
            backgroundColor="#d6d6d6">
    <RedImageView
      id="image1"
      frame="10,50,100,20"
      image="icon_profile"></RedImageView>
  </scrollview>
</views>
```

### (2)iOS 引用 XML 布局

#### 1.XML 控件的加载

```Swift
self.view.petralLoadXmlViews(xmlPath: "XmlViewController");
```

上面的代码表示 self.view 加载 XmlViewController.xml 的布局文件

#### 2.通过 id 访问指定的控件

```Swift
let userInfoView = self.view.petralViewById(id: "userInfoView") as! UserInfoView;
```

上面的代码表示 userInfoView 是 XmlViewController 里 id 属性为"userInfoView"的控件。

### 微信讨论群

二维码若过期，请加微信 ikrboy，请注明 petral 或者 github。

<img width="300" height="540" src="http://www.koudaikr.cn/Petral/WechatIMG19.jpeg"/>
