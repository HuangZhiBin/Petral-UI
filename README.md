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
let nameLabel = UILabel.init();
nameLabel.petralize()
  .frame(x: 0, y: 0, width: 80, height: 20)
  .text("姓名")
  .font(size: 14, bold: true)
  .textColor(UIColor.init(hexString: "#1f1f1f"));
```
通过直接调用.为前缀的方法，直接连续设置View的UI属性，与调用系统方法的API类似。可实现对View的连续设置，减少代码。
现有的API可以基本满足UI设置，大家可以根据实际需要自行添加更多的API方法。

## 2.自动布局
通过最少的代码，实现类似AutoLayout/Masory自动布局的功能，但代码量远少于这两个框架。

自动布局的使用步骤：
1.    View初始化后，通过addSubview()方法添加到当前页面。必须先执行addSubview()方法，才能使用Petral-UI进行自动布局的设置。
```swift
self.view.addSubview(nameLabel);
```
2.访问View的petralRestraint属性的方法设置布局。
```swift
nameLabel.petralRestraint
.topIn(offset: 10) // View的顶部与父View的距离为10
.leftIn(offset: 20);// View的左边与父View的距离为20
```
------------

### 自动布局的API

#### 1.同级间View的约束

View a与View b是属于同一层级的两个View，View b的位置可以由View a决定。

**注意：如果a与b不是属于同一层级，调用以下方法将报错。**

##### （1）to方法

- **leftTo()**

View b的左边与View a的距离是n

```swift
b.petralRestraint.leftTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/leftto.png)

------------


- **rightTo()**

View b的右边与View a的距离是n

```swift
b.petralRestraint.rightTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/rightto.png)

------------


- **topTo()**

View b的顶部与View a的距离是n

```swift
b.petralRestraint.topTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/topto.png)


------------


- **bottomTo()**

View b的底部与View a的距离是n

```swift
b.petralRestraint.bottomTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/bottomto.png)


##### （2）as方法

- **leftAs**

View b的左边与View a的左边的水平位置一致（可偏离n）

```swift
b.petralRestraint.leftAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/leftas.png)


------------


- **rightAs**

View b的右边与View a的右边的水平位置一致（可偏离n）
```swift
b.petralRestraint.rightAs(a, offset: n)
```


![](http://www.koudaikr.cn/Petral/rightas.png)


------------


- **topAs**

View b的顶部与View a的顶部的水平位置一致（可偏离n）

```swift
b.petralRestraint.topAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/topas.png)

------------



- **bottomAs**

View b的底部与View a的底部的水平位置一致（可偏离n）

```swift
b.petralRestraint.bottomAs(a, offset: n)
```


![](http://www.koudaikr.cn/Petral/bottomas.png)


------------


- **xCenterAs**

```swift
b.petralRestraint.xCenterAs(a, offset: n)
```
View b的中间水平位置与View a的中间水平位置一致（可偏离n）


![](http://www.koudaikr.cn/Petral/xcenteras.png)


------------


- **yCenterAs**

```swift
b.petralRestraint.yCenterAs(a, offset: n)
```
View b的中间垂直位置与View a的中间垂直位置一致（可偏离n）

![](http://www.koudaikr.cn/Petral/ycenteras.png)


------------



- **centerAs**

```swift
b.petralRestraint.centerAs(a, xOffset: m, yOffset: n)
```
View b的中间点与View a的中间点位置一致（x可偏离m,y可偏离n）

![](http://www.koudaikr.cn/Petral/centeras.png)



#### 2.父子间View的约束

View a与View b的父View，View b的位置可以由View a决定。

**注意：如果a不是b的父View，调用以下方法将报错。**




- **leftIn()**

View b的左边与父View的左边的距离为n

```swift
b.petralRestraint.leftIn(offset: n)
```


![](http://www.koudaikr.cn/Petral/leftin.png)


------------




- **rightIn()**

View b的右边与父View的y右边的距离为n

```swift
b.petralRestraint.rightIn(offset: n)
```


![](http://www.koudaikr.cn/Petral/rightin.png)



------------



- **topIn()**

View b的顶部与父View的顶部的距离为n

```swift
b.petralRestraint.topIn(offset: n)
```

![](http://www.koudaikr.cn/Petral/topin.png)


------------




- **bottomIn()**

View b的底部与父View的底部的距离为n

```swift
b.petralRestraint.bottomIn(offset: n)
```


![](http://www.koudaikr.cn/Petral/bottomin.png)



------------



- **xCenterIn()**

View b的水平位置位于父View的中间

```swift
b.petralRestraint.xCenterIn()
```

![](http://www.koudaikr.cn/Petral/xcenterin.png)


------------


- **yCenterIn()**

View b的垂直位置位于父View的中间

```swift
b.petralRestraint.yCenterIn()
```


![](http://www.koudaikr.cn/Petral/ycenterin.png)



------------



- **centerIn()**

View b的水平和垂直位置位于父View的中间

```swift
b.petralRestraint.centerIn()
```


![](http://www.koudaikr.cn/Petral/centerin.png)



#### 3.指定View的固定宽高




- **width()**

View b的固定宽度为n

```swift
b.petralRestraint.width(n)
```


![](http://www.koudaikr.cn/Petral/width.png)




------------



- **height()**

View b的固定高度为n

```swift
b.petralRestraint.height(n)
```


![](http://www.koudaikr.cn/Petral/height.png)



### 布局的级联更新

- **updateDependeds()**

View b的位置受到View a的制约，View c的位置受到View b的制约，若View a的位置或者大小发生改变，要保持之前的制约条件(Restraint)，需要手动调用API方法a.petralRestraint.updateDependeds();进行更新，使View b和View c的位置和大小发生改变。不手动调用该方法，将不主动实现UI的级联更新。

```swift
a.petralRestraint.updateDependeds();
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
- 2.**reset()** 重置布局
- 3.**remove(type: PetralRestraintType)** 删除冲突的约束条件

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
