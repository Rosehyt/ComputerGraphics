# ComputerGraphics

## 你已經完成了哪些任務?

#### 完成 Matrix4::makeRotX、Matrix4::makeRotY 旋轉矩陣實作
#### 完成 GameObject::localToWorld 模型矩陣組成
#### 完成 Camera::setPositionOrientation 視圖矩陣
#### 完成 Camera::setSize 透視投影矩陣
#### 完成 util::getDepth 深度計算
#### 完成 HW3::cameraControl 相機移動與旋轉
#### 完成 GameObject::debugDraw 反向剔除（Back-face Culling）

## 你作品的一些截圖?
<img width="1240" height="767" alt="image" src="https://github.com/user-attachments/assets/71de7d16-15a7-4c90-86db-9133ba3cc17d" />


## 您是如何完成這些任務的（解釋關鍵程式碼片段、使用的演算法或您的發現等）?

> 在本次作業中，我使用了 ChatGPT
- 協助整理作業說明
- 提供旋轉矩陣、模型矩陣、深度計算等程式碼範例
- 解釋公式與演算法原理
- 調整程式碼架構與繪製函式的相容性

 | 任務                                 | 狀態   | 說明                                                |
| ---------------------------------- | ---- | ------------------------------------------------- |
| `Matrix4::makeRotX()`              | ✅ 完成 | 生成繞 X 軸旋轉矩陣（俯仰矩陣）                                 |
| `Matrix4::makeRotY()`              | ✅ 完成 | 生成繞 Y 軸旋轉矩陣（偏航矩陣）                                 |
| `GameObject::localToWorld()`       | ✅ 完成 | 組合物體縮放、旋轉和平移生成模型矩陣                                |
| `Camera::setPositionOrientation()` | ✅ 完成 | 計算視圖矩陣，將物體從世界座標系轉換到相機座標系                          |
| `Camera::setSize()`                | ✅ 完成 | 設置透視投影矩陣，計算螢幕比例、FOV、近平面與遠平面                       |
| `util::getDepth()`                 | ✅ 完成 | 使用重心座標插值計算三角形內點的深度值                               |
| `HW3::cameraControl()`             | ✅ 完成 | 實作鍵盤控制相機移動（w/s/a/d/q/e），設定移動速度 `moveSpeed = 0.1f` |
| `GameObject::debugDraw()`          | ✅ 完成 | 實作反向剔除（Back-face Culling），只繪製朝向相機的三角形             |

#### 透過這些的訊息詢問chatGPT 順便告訴他禁止使用以下內置函數：

> `line(x1,y1,x2,y2);`  
> `circle(x,y,r);`  
> `ellipse(x,y,r1,r2);`  
> `bezier(x1,y1,x2,y2,x3,y3,x4,y4);`  
> `rect(x,y,w,h);`  
> `beginShape();`  
> `vertex(x,y);`  
> `endShape();` 

#### 1 Matrix4::makeRotY(float a)
```
同上次 makeRotZ(float a) 原理，只是改成對 Y 軸旋轉的矩陣，m[5] = 1。

Matrix4 Matrix4::makeRotY(float a){
    Matrix4 m;
    float c = cos(a), s = sin(a);
    m.m[0] = c;  m.m[1] = 0; m.m[2] = s;  m.m[3] = 0;
    m.m[4] = 0;  m.m[5] = 1; m.m[6] = 0;  m.m[7] = 0;
    m.m[8] = -s; m.m[9] = 0; m.m[10] = c; m.m[11] = 0;
    m.m[12] = 0; m.m[13] = 0; m.m[14] = 0; m.m[15] = 1;
    return m;
}
```

#### 2 Matrix4::makeRotX(float a)
```
同理，只是改成對 X 軸旋轉的矩陣，m[0] = 1。

Matrix4 Matrix4::makeRotX(float a){
    Matrix4 m;
    float c = cos(a), s = sin(a);
    m.m[0] = 1;  m.m[1] = 0;  m.m[2] = 0;  m.m[3] = 0;
    m.m[4] = 0;  m.m[5] = c;  m.m[6] = -s; m.m[7] = 0;
    m.m[8] = 0;  m.m[9] = s;  m.m[10] = c; m.m[11] = 0;
    m.m[12] = 0; m.m[13] = 0; m.m[14] = 0; m.m[15] = 1;
    return m;
}

```


#### 3 GameObject::localToWorld()
```
計算物體的模型矩陣（Model Matrix），將物體從本地坐標系轉換到世界坐標系。
流程說明：

位置平移：使用 transform.position 建立平移矩陣。

旋轉：

繞 Z 軸旋轉 (transform.rotation.z)

繞 X 軸旋轉 (transform.rotation.x)

繞 Y 軸旋轉 (transform.rotation.y)

縮放：使用 transform.scale 計算縮放矩陣。

Matrix4 GameObject::localToWorld() {
    Matrix4 S = Matrix4().makeScale(transform.scale);
    Matrix4 Rx = Matrix4().makeRotX(transform.rotation.x);
    Matrix4 Ry = Matrix4().makeRotY(transform.rotation.y);
    Matrix4 T = Matrix4().makeTranslation(transform.position);
    return T * Ry * Rx * S; // 平移 * 旋轉 * 縮放
}
```

#### 4 Camera::setPositionOrientation(Vector3 pos, Vector3 lookat)
```
計算相機視圖矩陣，將世界坐標轉換到相機坐標系。
流程說明：

計算視線方向 forward = normalize(lookat - pos)

計算右向量 right = normalize(cross(up, forward))

計算最終上向量 finalUp = cross(forward, right)

建立旋轉矩陣 + 平移矩陣，生成最終視圖矩陣

void Camera::setPositionOrientation(Vector3 pos, Vector3 lookat){
    Vector3 forward = (lookat - pos).normalize();
    Vector3 right = cross(up, forward).normalize();
    Vector3 true_up = cross(forward, right);
    viewMatrix = Matrix4(
        right.x, true_up.x, forward.x, 0,
        right.y, true_up.y, forward.y, 0,
        right.z, true_up.z, forward.z, 0,
        -dot(right,pos), -dot(true_up,pos), -dot(forward,pos), 1
    );
}
```

#### 5 Camera::setSize(int w, int h, float n, float f)
```
設置投影矩陣（透視投影），將 3D 物體投影到 2D 螢幕。

計算螢幕寬高比 aspect = w / h

計算 FOV 正切值 tanHalfFov = tan(FOV/2)

設置投影矩陣元素：

X軸縮放：1 / (aspect * tanHalfFov)

Y軸縮放：1 / tanHalfFov

Z軸縮放：(f + n) / (n - f)

Z軸偏移：(2 * f * n) / (n - f)
```

#### 6 util::getDepth(float x, float y, Vector3[] vertex)

```
計算點 (x, y) 在三角形內的深度 Z，使用重心坐標法。

計算三角形面積兩倍 area2

計算重心坐標 alpha, beta, gamma

如果點在三角形內，返回 Z 值；否則返回 Float.POSITIVE_INFINITY
```

#### 7 HW3::cameraControl()
```
使用鍵盤控制相機移動：

w：前進 (z+)

s：後退 (z-)

a：左移 (x-)

d：右移 (x+)

q：上移 (y+)

e：下移 (y-)

移動速度 moveSpeed = 0.1f
```

#### 8 GameObject::debugDraw()
```
將 3D 三角形繪製到 2D 螢幕，並使用背面剔除提高效率。

計算每個三角形的法向量

與視線向量做點積判斷是否朝向相機

如果朝向相機，將三角形的邊用 CGLine 繪製到螢幕
```



