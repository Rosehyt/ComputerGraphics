# ComputerGraphics

## 你已經完成了哪些任務?
#### 1.平移矩陣
#### 2.旋轉矩陣（Z 軸）
#### 3.縮放矩陣
#### 4.pnpoly 點在多邊形內判定
#### 5.findBoundBox 找邊界框
#### 6.Sutherland–Hodgman 多邊形裁剪 


## 你作品的一些截圖?
<img width="1229" height="740" alt="image" src="https://github.com/user-attachments/assets/426d42a1-a825-41b9-8fdb-2f9737a51883" />

<img width="1237" height="753" alt="image" src="https://github.com/user-attachments/assets/1720b0e8-c069-487f-8414-05d2e8e1960c" />

## 您是如何完成這些任務的（解釋關鍵程式碼片段、使用的演算法或您的發現等）?
> 在本次作業中，我使用了 ChatGPT
- 確認 矩陣乘法的正確實作方式
- 調整 pnpoly 內部判定公式方向
- 撰寫 Sutherland–Hodgman 裁剪演算法的邏輯順序
- 調整程式碼架構與繪製函式的相容性
>| 任務                                  | 狀態   | 說明                |
>| ------------------------------------- | ---- | ----------------- |
>| `Matrix4.makeTrans()`                 | ✅ 完成 | 生成平移矩陣            |
>| `Matrix4.makeRotZ()`                  | ✅ 完成 | 生成繞 Z 軸的旋轉矩陣      |
>| `Matrix4.makeScale()`                 | ✅ 完成 | 生成縮放矩陣            |
>| `util.pnpoly()`                       | ✅ 完成 | 判斷點是否在多邊形內        |
>| `util.findBoundBox()`                 | ✅ 完成 | 計算多邊形邊界框          |
>| `util.Sutherland_Hodgman_algorithm()` | ✅ 完成 | 實作多邊形裁剪演算法，防止超出畫布 |

#### 透過這些的訊息詢問chatGPT 順便告訴他禁止使用以下內置函數：

> `line(x1,y1,x2,y2);`  
> `circle(x,y,r);`  
> `ellipse(x,y,r1,r2);`  
> `bezier(x1,y1,x2,y2,x3,y3,x4,y4);`  
> `rect(x,y,w,h);`  
> `beginShape();`  
> `vertex(x,y);`  
> `endShape();` 

