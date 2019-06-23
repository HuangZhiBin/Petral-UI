![](http://www.koudaikr.cn/Petral/logo.png)

**Petral-UI**是一个以Swift实现的 UI布局框架，以最少的代码，实现UI的搭建、属性设置以及布局控制。

## 接入条件

```
swift.version >= 4.0
```

## 接入方式

```Cocoapods
pod 'Petral-UI'
```

Petral-UI主要是下面两个部分：

## 1.连续点方法
连续设置UIView的属性，例如
```swift
let nameLabel = UILabel.init()
.pt_frame(x: 0, y: 0, width: 80, height: 20)
.pt_text("姓名")
.pt_font(size: 14, bold: true)
.pt_textColor(UIColor.init(hexString: "#1f1f1f"));
```
通过直接调用.pt_为前缀的方法，直接连续设置View的UI属性，与调用系统方法的API类似。可实现对View的连续设置，减少代码。
现有的API可以基本满足UI设置，大家可以根据实际需要自行添加更多的API方法。

## 2.自动布局
通过最少的代码，实现类似AutoLayout/Masory自动布局的功能，但代码量远少于这两个框架。

自动布局的使用步骤：
1.    View初始化后，通过addSubview()方法添加到当前页面。必须先执行addSubview()方法，才能使用Petral-UI进行自动布局的设置。
```swift
self.view.addSubview(nameLabel);
```
2.访问View的petralRestraint属性，通过以pt_为前缀的方法设置布局。
```swift
nameLabel.petralRestraint
.pt_topIn(self.view, distance: 10) // View的顶部与父View的距离为10
.pt_leftIn(self.view, distance: 20);// View的左边与父View的距离为20
```
------------

### 自动布局的API

#### 1.同级间View的约束

View a与View b是属于同一层级的两个View，View b的位置可以由View a决定。

**注意：如果a与b不是属于同一层级，调用以下方法将报错。**

##### （1）to方法

- **pt_leftTo()**

View b的左边与View a的距离是n

```swift
b.petralRestraint.pt_leftTo(a, distance: n)
```

![](http://www.koudaikr.cn/Petral/leftto.png)

------------


- **pt_rightTo()**

View b的右边与View a的距离是n

```swift
b.petralRestraint.pt_rightTo(a, distance: n)
```

![](http://www.koudaikr.cn/Petral/rightto.png)

------------


- **pt_topTo()**

View b的顶部与View a的距离是n

```swift
b.petralRestraint.pt_topTo(a, distance: n)
```

![](http://www.koudaikr.cn/Petral/topto.png)


------------


- **pt_bottomTo()**

View b的底部与View a的距离是n

```swift
b.petralRestraint.pt_bottomTo(a, distance: n)
```

![](http://www.koudaikr.cn/Petral/bottomto.png)


##### （2）as方法

- **pt_leftAs**

View b的左边与View a的左边的水平位置一致（可偏离n）

```swift
b.petralRestraint.pt_leftAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/leftas.png)


------------


- **pt_rightAs**

View b的右边与View a的右边的水平位置一致（可偏离n）
```swift
b.petralRestraint.pt_rightAs(a, offset: n)
```


![](http://www.koudaikr.cn/Petral/rightas.png)


------------


- **pt_topAs**

View b的顶部与View a的顶部的水平位置一致（可偏离n）

```swift
b.petralRestraint.pt_topAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/topas.png)

------------



- **pt_bottomAs**

View b的底部与View a的底部的水平位置一致（可偏离n）

```swift
b.petralRestraint.pt_bottomAs(a, offset: n)
```


![](http://www.koudaikr.cn/Petral/bottomas.png)


------------


- **pt_xCenterAs**

```swift
b.petralRestraint.pt_xCenterAs(a, offset: n)
```
View b的中间水平位置与View a的中间水平位置一致（可偏离n）


![](http://www.koudaikr.cn/Petral/xcenteras.png)


------------


- **pt_yCenterAs**

```swift
b.petralRestraint.pt_yCenterAs(a, offset: n)
```
View b的中间垂直位置与View a的中间垂直位置一致（可偏离n）

![](http://www.koudaikr.cn/Petral/ycenteras.png)


------------



- **pt_centerAs**

```swift
b.petralRestraint.pt_centerAs(a, xOffset: m, yOffset: n)
```
View b的中间点与View a的中间点位置一致（x可偏离m,y可偏离n）

![](http://www.koudaikr.cn/Petral/centeras.png)



#### 2.父子间View的约束

View a与View b的父View，View b的位置可以由View a决定。

**注意：如果a不是b的父View，调用以下方法将报错。**




- **pt_leftIn()**

View b的左边与父View a的左边的距离为n

```swift
b.petralRestraint.pt_leftIn(a, distance: n)
```


![](http://www.koudaikr.cn/Petral/leftin.png)


------------




- **pt_rightIn()**

View b的右边与父View a的y右边的距离为n

```swift
b.petralRestraint.pt_rightIn(a, distance: n)
```


![](http://www.koudaikr.cn/Petral/rightin.png)



------------



- **pt_topIn()**

View b的顶部与父View a的顶部的距离为n

```swift
b.petralRestraint.pt_topIn(a, distance: n)
```

![](http://www.koudaikr.cn/Petral/topin.png)


------------




- **pt_bottomIn()**

View b的底部与父View a的底部的距离为n

```swift
b.petralRestraint.pt_bottomIn(a, distance: n)
```


![](http://www.koudaikr.cn/Petral/bottomin.png)



------------



- **pt_xCenterIn()**

View b的水平位置位于父View a的中间

```swift
b.petralRestraint.pt_xCenterIn(a)
```

![](http://www.koudaikr.cn/Petral/xcenterin.png)


------------


- **pt_yCenterIn()**

View b的垂直位置位于父View a的中间

```swift
b.petralRestraint.pt_yCenterIn(a)
```


![](http://www.koudaikr.cn/Petral/ycenterin.png)



------------



- **pt_centerIn()**

View b的水平和垂直位置位于父View a的中间

```swift
b.petralRestraint.pt_centerIn(a)
```


![](http://www.koudaikr.cn/Petral/centerin.png)



#### 3.指定View的固定宽高




- **pt_width()**

View b的固定宽度为n

```swift
b.petralRestraint.pt_width(n)
```


![](http://www.koudaikr.cn/Petral/width.png)




------------



- **pt_height()**

View b的固定高度为n

```swift
b.petralRestraint.pt_height(n)
```


![](http://www.koudaikr.cn/Petral/height.png)



### 布局的级联更新

- **pt_updateDependeds()**

View b的位置受到View a的制约，View c的位置受到View b的制约，若View a的位置或者大小发生改变，要保持之前的制约条件(Restraint)，需要手动调用API方法a.petralRestraint.pt_updateDependeds();进行更新，使View b和View c的位置和大小发生改变。不手动调用该方法，将不主动实现UI的级联更新。

```swift
a.petralRestraint.pt_updateDependeds();
```

![](http://www.koudaikr.cn/Petral/relative.png)

![](http://www.koudaikr.cn/Petral/relative2.png)

### 布局冲突的情况

以下的情形会发生布局冲突，运行时抛出fatalError：

- 同时设置view的left、right和width约束
- 同时设置view的top、bottom和height约束
- 同时设置view的left、xCenter约束
- 同时设置view的right、xCenter约束
- 同时设置view的top、yCenter约束
- 同时设置view的bottom、yCenter约束

运行时发现fatalError的情形，请通过下面的方法解决冲突。

### 解决布局冲突的办法

根据fatalError的说明，首先应了解冲突发生的具体规则，然后选择下面的其中一个方法解决冲突。

- 1.修改已有的约束条件（即改动已有的代码，重新修改约束条件）
- 2.**pt_reset()** 重置布局
- 3.**pt_remove(type: PetralRestraintType)** 删除冲突的约束条件

**PetralRestraintType**的类型：

类型 | 说明
---- | ---
left | 左约束
right | 右约束
bottom | 底约束
top | 顶约束
xCenter | 水平居中
yCenter | 垂直居中
width | 宽度约束
height | 高度约束

### 微信讨论群

二维码若过期，请加微信ikrboy，请注明petral或者github。

<img width="300" height="540" src="http://www.koudaikr.cn/Petral/WechatIMG19.jpeg"/>
