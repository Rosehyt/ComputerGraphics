# ComputerGraphics

---

## 你已經完成了哪些任務?
- **Line algorithm** 線演算法 
- **Circle Algorithm** 圓演算法 
- **Ellipse Algorithm**橢圓演算法 
- **Bézier Curve Algorithm**貝塞爾曲線演算法 
- **Eraser**橡皮
<img width="1238" height="714" alt="image" src="https://github.com/user-attachments/assets/a022df80-2c35-4102-98d1-70693f953ad4" />

---

## 你作品的一些截圖?
### 1.Line algorithm 線演算法 
<img width="1236" height="513" alt="image" src="https://github.com/user-attachments/assets/a03478cc-bf55-4a9f-bad1-8c6662128245" />

### 2.Circle Algorithm 圓演算法 
<img width="1230" height="687" alt="image" src="https://github.com/user-attachments/assets/53362580-8a11-4477-bd68-410d41a1e715" />

### 3.Ellipse Algorithm橢圓演算法  4.Bézier Curve Algorithm貝塞爾曲線演算法 5.Eraser橡皮
<img width="1236" height="458" alt="image" src="https://github.com/user-attachments/assets/c4247a2c-3536-4553-9240-e37323e0c0fe" />

---

## 您是如何完成這些任務的（解釋關鍵程式碼片段、使用的演算法或您的發現等）?

- 發現 Point、Line、Polygon都有drawShape() 的 CGLine(p1.x, p1.y, p2.x, p2.y)，找 CGLine函式，看到todo作業。

- 總要做 CGLine(float x1, float y1, float x2, float y2)  、CGCircle(float x, float y, float r)  、CGEllipse(float x, float y, float r1, float r2)  、CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4)  、CGEraser(Vector3 p1, Vector3 p2) 五個函示。
- 透過這些的訊息詢問chatGPT 順便告訴他禁止使用以下內置函數：

> line(x1,y1,x2,y2);  
> circle(x,y,r);  
> ellipse(x,y,r1,r2);  
> bezier(x1,y1,x2,y2,x3,y3,x4,y4);  
> rect(x,y,w,h);
> 
> beginShape();  
> vertex(x,y);  
> endShape();

### Bresenham 直線演算法:
- 它在每次畫點時會判斷：
- 接下來的點是畫在「右邊」還是「右下角」（或右上角）
- 使用 誤差值 去逼近理想的斜率，但只用整數運算（效率高）


### Midpoint 圓演算法:  
- 只用整數運算
- 運用圓的對稱性，只計算 1/8 圓，然後用對稱性補出整個圓。
- 一個圓心在 (x₀, y₀)，半徑為 r 的圓，其所有點 (x, y) 滿足：
> (x - x<sub>0</sub>)<sup>2</sup> + (y - y<sub>0</sub>)<sup>2</sup> = r <sup>2</sup>


### Midpoint 橢圓演算法:
>(x - x<sub>0</sub>)<sup>2</sup> / r<sub>2</sub><sup>1</sup> + (y - y<sub>0</sub>)<sup>2</sup> / r<sub>2</sub><sup>2</sup> = 1  
>(x0, y0) 為橢圓中心、r1 為 x 軸半徑、r2 為 y 軸半徑
- 分為兩個區域繪製：  
- Region 1（斜率 < 1）：沿 X 增加，Y 根據誤差決定要不要減  
- Region 2（斜率 >= 1）：沿 Y 減少，X 根據誤差決定要不要加

### 四階貝茲曲線 Cubic Bézier Curve:
- p1（起點）、p2（控制點1）、p3（控制點2）、p4(終點)  
>B(t) = (1-t)<sup>3</sup>*P<sub>1</sub> + 3(1-t)<sup>2</sup>*t*P<sub>2</sub> + 3(1-t)t<sup>2</sup>*P<sub>3</sub> + t<sup>3</sup>*P<sub>4</sub>

### 橡皮擦 CGEraser(Vector3 p1, Vector3 p2) 函數:  
- 擦除畫面上 p1 到 p2 定義的區域，也就是畫一個矩形，並用背景顏色 color(250) 去蓋掉這區域內的所有點。
