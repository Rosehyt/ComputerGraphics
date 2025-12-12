public class Camera extends GameObject {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform.position = new Vector3(0, 0, -50);
        name = "Camera";
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
       // 計算屏幕的寬高比
        float aspect = (float) wid / hei;
    
        // 計算垂直 FOV 的 tangent 值
        float t = (float) Math.tan(Math.toRadians(GH_FOV / 2.0f));
    
        // 填充投影矩陣
        projection = Matrix4.Identity();
        projection.m[0] = 1.0f / (t * aspect); // X 軸縮放
        projection.m[5] = 1.0f / t;           // Y 軸縮放
        projection.m[10] = -(f + n) / (f - n); // Z 軸縮放
        projection.m[11] = -1.0f;             // 齊次坐標
        projection.m[14] = -(2.0f * f * n) / (f - n); // Z 軸平移
        projection.m[15] = 0.0f;              // 齊次坐標

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {
        worldView = Matrix4.RotX(rotX).mult(Matrix4.RotY(rotY)).mult(Matrix4.Trans(pos.mult(-1)));
    }

    void setPositionOrientation() {
        worldView = Matrix4.RotX(transform.rotation.x).mult(Matrix4.RotY(transform.rotation.y))
                .mult(Matrix4.Trans(transform.position.mult(-1)));
    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.
        // 固定的上向量 (Top Vector)
        Vector3 topVector = new Vector3(0, 1, 0);
    
        // 計算前向向量 (Forward)
        Vector3 forward = lookat.sub(pos).unit_vector();
    
        // 計算右向向量 (Right)
        Vector3 right = Vector3.cross(topVector, forward).unit_vector();
    
        // 計算上向向量 (Up)
        Vector3 up = Vector3.cross(forward, right).unit_vector();
    
        // 構造視圖矩陣
        worldView = Matrix4.Identity();
    
        // 設置旋轉部分
        worldView.setXAxis(right);      // 第一列: Right
        worldView.setYAxis(up);         // 第二列: Up
        worldView.setZAxis(forward.mult(-1)); // 第三列: Negative Forward
    
        // 設置平移部分 (基於相機的位置)
        worldView.setTranslation(new Vector3(
            -Vector3.dot(pos, right), 
            -Vector3.dot(pos, up), 
            Vector3.dot(pos, forward)
        ));
    }
}
