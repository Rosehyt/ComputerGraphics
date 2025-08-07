public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // You need to implement the "line algorithm" in this section.
    // You can use the function line(x1, y1, x2, y2); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // For instance: drawPoint(114, 514, color(255, 0, 0)); signifies drawing a red
    // point at (114, 514).

    /*
     stroke(0);
     noFill();
     line(x1,y1,x2,y2);
    */
    
    // 將浮點數轉為整數
    int xStart = Math.round(x1);
    int yStart = Math.round(y1);
    int xEnd = Math.round(x2);
    int yEnd = Math.round(y2);
    
    int dx = Math.abs(xEnd - xStart);
    int dy = Math.abs(yEnd - yStart);
    
    // 判斷直線方向
    int sx = (xStart < xEnd) ? 1 : -1;
    int sy = (yStart < yEnd) ? 1 : -1;
    
    //橫向和縱向偏離的程度
    int err = dx - dy;

    int x = xStart;
    int y = yStart;

    while (true) {//重複畫點，直到畫到終點為止。
        drawPoint(x, y, color(255, 0, 0));  // 紅色畫線，可以自訂顏色

        if (x == xEnd && y == yEnd) break;
        
        int e2 = 2 * err;  // 因為原始公式是用誤差值除以 2，所以這裡直接乘 2 來避免浮點數。
      
        if (e2 > -dy) {  // 誤差夠大，代表偏離橫向比較多，所以往 x 方向前進（往右畫一格）
            err -= dy;
            x += sx;
        }
        if (e2 < dx) {  // 誤差偏向垂直方向太多，所以也往 y 方向前進（往下畫一格）
            err += dx;
            y += sy;
        }
    }
}

public void CGCircle(float x, float y, float r) {
    // TODO HW1
    // You need to implement the "circle algorithm" in this section.
    // You can use the function circle(x, y, r); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    /*
    stroke(0);
    noFill();
    circle(x,y,r*2);
    */
    int cx = Math.round(x);
    int cy = Math.round(y);
    int radius = Math.round(r);
    
    //初始點從 (0, r)
    int rx = 0;
    
    //p 是決定「下一步是往右還是往右下」的變數
    int ry = radius;
    int p = 1 - radius;
    
    //rx <= ry 是因為畫到 45°（1/8圓）就可以靠對稱畫出整個圓
    while (rx <= ry) {
        // 利用八對稱性畫出所有八個方向的點
        drawPoint(cx + rx, cy + ry, color(0, 0, 255));  // 可自訂顏色
        drawPoint(cx - rx, cy + ry, color(0, 0, 255));
        drawPoint(cx + rx, cy - ry, color(0, 0, 255));
        drawPoint(cx - rx, cy - ry, color(0, 0, 255));
        drawPoint(cx + ry, cy + rx, color(0, 0, 255));
        drawPoint(cx - ry, cy + rx, color(0, 0, 255));
        drawPoint(cx + ry, cy - rx, color(0, 0, 255));
        drawPoint(cx - ry, cy - rx, color(0, 0, 255));

        rx++;

        if (p < 0) {
            p = p + 2 * rx + 1;
        } else {
            ry--;
            p = p + 2 * (rx - ry) + 1;
        }
    }
}

public void CGEllipse(float x, float y, float r1, float r2) {
    // TODO HW1
    // You need to implement the "ellipse algorithm" in this section.
    // You can use the function ellipse(x, y, r1,r2); to verify the correct answer.
    // However, remember to comment out the function before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    /*
    stroke(0);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    */
    int cx = Math.round(x);
    int cy = Math.round(y);
    int rx = Math.round(r1);
    int ry = Math.round(r2);

    int ix = 0;
    int iy = ry;

    float rxSq = rx * rx;
    float rySq = ry * ry;

    float dx = 2 * rySq * ix;
    float dy = 2 * rxSq * iy;

    // Region 1
    float p1 = rySq - (rxSq * ry) + (0.25f * rxSq);

    while (dx < dy) {
        drawSymmetricPoints(cx, cy, ix, iy);

        ix++;
        dx = 2 * rySq * ix;

        if (p1 < 0) {
            p1 += rySq * (2 * ix + 1);
        } else {
            iy--;
            dy = 2 * rxSq * iy;
            p1 += rySq * (2 * ix + 1) - dy;
        }
    }

    // Region 2
    float p2 = rySq * (ix + 0.5f) * (ix + 0.5f) + rxSq * (iy - 1) * (iy - 1) - rxSq * rySq;

    while (iy >= 0) {
        drawSymmetricPoints(cx, cy, ix, iy);

        iy--;
        dy = 2 * rxSq * iy;

        if (p2 > 0) {
            p2 -= rxSq * (2 * iy + 1);
        } else {
            ix++;
            dx = 2 * rySq * ix;
            p2 += dx - rxSq * (2 * iy + 1);
        }
    }
}

void drawSymmetricPoints(int cx, int cy, int x, int y) {
    drawPoint(cx + x, cy + y, color(0, 255, 0));
    drawPoint(cx - x, cy + y, color(0, 255, 0));
    drawPoint(cx + x, cy - y, color(0, 255, 0));
    drawPoint(cx - x, cy - y, color(0, 255, 0));
}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    // TODO HW1
    // You need to implement the "bezier curve algorithm" in this section.
    // You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x,
    // p4.y); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    /*
    stroke(0);
    noFill();
    bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    */
    int steps = 1000; // 控制曲線的平滑度
    float t;

    for (int i = 0; i <= steps; i++) {
        t = (float) i / steps;
        float oneMinusT = 1 - t;

        float x = oneMinusT * oneMinusT * oneMinusT * p1.x
                + 3 * oneMinusT * oneMinusT * t * p2.x
                + 3 * oneMinusT * t * t * p3.x
                + t * t * t * p4.x;

        float y = oneMinusT * oneMinusT * oneMinusT * p1.y
                + 3 * oneMinusT * oneMinusT * t * p2.y
                + 3 * oneMinusT * t * t * p3.y
                + t * t * t * p4.y;

        drawPoint(x, y, color(255, 0, 255)); // 畫出粉紅色的點
    }
}

public void CGEraser(Vector3 p1, Vector3 p2) {
    // TODO HW1
    // You need to erase the scene in the area defined by points p1 and p2 in this
    // section.
    // p1 ------
    // |       |
    // |       |
    // ------ p2
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    int xStart = Math.round(Math.min(p1.x, p2.x));
    int xEnd = Math.round(Math.max(p1.x, p2.x));
    int yStart = Math.round(Math.min(p1.y, p2.y));
    int yEnd = Math.round(Math.max(p1.y, p2.y));

    for (int x = xStart; x <= xEnd; x++) {
        for (int y = yStart; y <= yEnd; y++) {
            drawPoint(x, y, color(250));  // 使用背景色畫出矩形區域（等於擦除）
        }
    }
}

public void drawPoint(float x, float y, color c) {
    stroke(c);
    point(x, y);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}
