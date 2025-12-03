public class Camera {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    Transform transform;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform = new Transform();
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        
        // TODO HW3
        // This function takes four parameters, which are 
        // the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.
        // 計算投影矩陣（這裡假設 GH_FOV 是全局變量，代表視場角）
        float aspect = (float)wid / (float)hei;
        
        // 設置投影矩陣
        projection = Matrix4.Identity();
        
        // 計算透視矩陣
        float fov = GH_FOV; // 假設這個是已經定義的全局變數（通常是45度）
        float tanHalfFov = (float) Math.tan(Math.toRadians(fov) / 2.0f);
        
        // 投影矩陣
        projection.m[0] = 1.0f / (aspect * tanHalfFov);
        projection.m[5] = 1.0f / tanHalfFov;
        projection.m[10] = (far + near) / (near - far);
        projection.m[11] = -1.0f;                        // ★★ 你的錯在這裡
        projection.m[14] = (2 * far * near) / (near - far);  // ★★ 之前放錯位置
        projection.m[15] = 0.0f;

    }
  

//    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {

//    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
      // 計算相機的前向向量（視線方向）
      Vector3 forward = Vector3.sub(lookat, pos);   // 視線方向向量
      forward.normalize();                          // 歸一化視線方向
  
      // 預設的上向量 (上方方向)
      Vector3 up = new Vector3(0, 1, 0);
  
      // 計算相機的右向量
      Vector3 right = Vector3.cross(forward, up);  // 右向量是上向量與視線方向的叉積
      right.normalize();                           // 歸一化右向量
  
      // 計算最終的上向量
      Vector3 finalUp = Vector3.cross(right, forward);  // 最終的上向量是視線方向與右向量的叉積
      finalUp.normalize();                            // 歸一化
  
      // 構造視圖矩陣 worldView
      worldView = Matrix4.Identity();
  
      // 設置視圖矩陣的旋轉部分
      worldView.setXAxis(right);       // 第一列: Right 向量
      worldView.setYAxis(finalUp);     // 第二列: Up 向量
      worldView.setZAxis(forward.mult(-1));  // 第三列: -Forward 向量（視線方向的反向）
  
      // 計算平移部分 (基於相機的位置)
      worldView.setTranslation(new Vector3(
          -Vector3.dot(pos, right),      // X軸的平移
          -Vector3.dot(pos, finalUp),    // Y軸的平移
          Vector3.dot(pos, forward)      // Z軸的平移
      ));
  }

}
