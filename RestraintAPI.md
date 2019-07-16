### 自动布局的 API

#### 1.同级间 View 的约束

View a 与 View b 是属于同一层级的两个 View，View b 的位置可以由 View a 决定。

**注意：如果 a 与 b 不是属于同一层级，调用以下方法将报错。**

##### （1）to 方法

- **leftTo()**

View b 的左边与 View a 的距离是 n

```swift
b.petralRestraint.leftTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/leftto.png)

---

- **rightTo()**

View b 的右边与 View a 的距离是 n

```swift
b.petralRestraint.rightTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/rightto.png)

---

- **topTo()**

View b 的顶部与 View a 的距离是 n

```swift
b.petralRestraint.topTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/topto.png)

---

- **bottomTo()**

View b 的底部与 View a 的距离是 n

```swift
b.petralRestraint.bottomTo(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/bottomto.png)

##### （2）as 方法

- **leftAs**

View b 的左边与 View a 的左边的水平位置一致（可偏离 n）

```swift
b.petralRestraint.leftAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/leftas.png)

---

- **rightAs**

View b 的右边与 View a 的右边的水平位置一致（可偏离 n）

```swift
b.petralRestraint.rightAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/rightas.png)

---

- **topAs**

View b 的顶部与 View a 的顶部的水平位置一致（可偏离 n）

```swift
b.petralRestraint.topAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/topas.png)

---

- **bottomAs**

View b 的底部与 View a 的底部的水平位置一致（可偏离 n）

```swift
b.petralRestraint.bottomAs(a, offset: n)
```

![](http://www.koudaikr.cn/Petral/bottomas.png)

---

- **xCenterAs**

```swift
b.petralRestraint.xCenterAs(a, offset: n)
```

View b 的中间水平位置与 View a 的中间水平位置一致（可偏离 n）

![](http://www.koudaikr.cn/Petral/xcenteras.png)

---

- **yCenterAs**

```swift
b.petralRestraint.yCenterAs(a, offset: n)
```

View b 的中间垂直位置与 View a 的中间垂直位置一致（可偏离 n）

![](http://www.koudaikr.cn/Petral/ycenteras.png)

---

- **centerAs**

```swift
b.petralRestraint.centerAs(a, xOffset: m, yOffset: n)
```

View b 的中间点与 View a 的中间点位置一致（x 可偏离 m,y 可偏离 n）

![](http://www.koudaikr.cn/Petral/centeras.png)

#### 2.父子间 View 的约束

View a 与 View b 的父 View，View b 的位置可以由 View a 决定。

**注意：如果 a 不是 b 的父 View，调用以下方法将报错。**

- **leftIn()**

View b 的左边与父 View 的左边的距离为 n

```swift
b.petralRestraint.leftIn(offset: n)
```

![](http://www.koudaikr.cn/Petral/leftin.png)

---

- **rightIn()**

View b 的右边与父 View 的 y 右边的距离为 n

```swift
b.petralRestraint.rightIn(offset: n)
```

![](http://www.koudaikr.cn/Petral/rightin.png)

---

- **topIn()**

View b 的顶部与父 View 的顶部的距离为 n

```swift
b.petralRestraint.topIn(offset: n)
```

![](http://www.koudaikr.cn/Petral/topin.png)

---

- **bottomIn()**

View b 的底部与父 View 的底部的距离为 n

```swift
b.petralRestraint.bottomIn(offset: n)
```

![](http://www.koudaikr.cn/Petral/bottomin.png)

---

- **xCenterIn()**

View b 的水平位置位于父 View 的中间

```swift
b.petralRestraint.xCenterIn()
```

![](http://www.koudaikr.cn/Petral/xcenterin.png)

---

- **yCenterIn()**

View b 的垂直位置位于父 View 的中间

```swift
b.petralRestraint.yCenterIn()
```

![](http://www.koudaikr.cn/Petral/ycenterin.png)

---

- **centerIn()**

View b 的水平和垂直位置位于父 View 的中间

```swift
b.petralRestraint.centerIn()
```

![](http://www.koudaikr.cn/Petral/centerin.png)

#### 3.指定 View 的固定宽高

- **width()**

View b 的固定宽度为 n

```swift
b.petralRestraint.width(n)
```

![](http://www.koudaikr.cn/Petral/width.png)

---

- **height()**

View b 的固定高度为 n

```swift
b.petralRestraint.height(n)
```

![](http://www.koudaikr.cn/Petral/height.png)
