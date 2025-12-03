public class GameObject {
    Transform transform;
    Mesh mesh;
    String name;
    Shader shader;

    GameObject() {
        transform = new Transform();
    }

    GameObject(String fname) {
        transform = new Transform();
        setMesh(fname);
        String[] sn = fname.split("\\\\");
        name = sn[sn.length - 1].substring(0, sn[sn.length - 1].length() - 4);
        shader = new Shader(new DepthVertexShader(), new DepthFragmentShader());
    }

    void reset() {
        transform.position.setZero();
        transform.rotation.setZero();
        transform.scale.setOnes();
    }

    void setMesh(String fname) {
        mesh = new Mesh(fname);
    }

    void Draw() {
        Matrix4 MVP = main_camera.Matrix().mult(localToWorld());
        for (int i=0; i<mesh.triangles.size(); i++) {
            Triangle triangle = mesh.triangles.get(i);
            Vector3[] position = triangle.verts;
            Vector4[] gl_Position = shader.vertex.main(new Object[]{position}, new Object[]{MVP});
            Vector3[] s_Position = new Vector3[3];
            for (int j = 0; j<gl_Position.length; j++) {
                s_Position[j] = gl_Position[j].homogenized();
            }
            Vector3[] boundbox = findBoundBox(s_Position);
            float minX = map(min( max(boundbox[0].x, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.z - renderer_size.x);
            float maxX = map(min( max(boundbox[1].x, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.z - renderer_size.x);
            float minY = map(min( max(boundbox[0].y, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.w - renderer_size.y);
            float maxY = map(min( max(boundbox[1].y, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.w - renderer_size.y);
            
            for (int y = int(minY); y < maxY; y++) {
                for (int x = int(minX); x < maxX; x++) {
                    float rx=map(x, 0.0 , renderer_size.z - renderer_size.x, -1, 1);
                    float ry=map(y, 0.0, renderer_size.w - renderer_size.y, -1, 1);
                    if (!pnpoly(rx, ry, s_Position)) continue;
                    int index = y * int(renderer_size.z - renderer_size.x) + x;
                    
                    float z = getDepth(rx, ry, s_Position );
                    Vector4 c = shader.fragment.main(new Object[]{new Vector3(rx, ry, z)});
                    
                    if (GH_DEPTH[index] > z) {
                        GH_DEPTH[index] = z;
                        renderBuffer.pixels[index] = color(c.x * 255, c.y*255, c.z*255);
                    }
                }
            }
        }        
        update();
    }

    void update() {
    }

    void debugDraw() {
      Matrix4 MVP = main_camera.Matrix().mult(localToWorld());
      for (int i = 0; i < mesh.triangles.size(); i++) {
          Triangle triangle = mesh.triangles.get(i);
          Vector3[] img_pos = new Vector3[3];
          
          // 計算三角形在世界空間中的頂點位置
          for (int j = 0; j < 3; j++) {
              img_pos[j] = MVP.mult(triangle.verts[j].getVector4(1.0)).homogenized();
          }
          
          // 計算三角形的法向量
          Vector3 edge1 = img_pos[1].sub(img_pos[0]);
          Vector3 edge2 = img_pos[2].sub(img_pos[0]);
          Vector3 normal = Vector3.cross(edge1, edge2);
          normal.normalize();
          
          // 計算視線向量（從三角形的第一個頂點指向相機）
          Vector3 viewDir = img_pos[0].mult(-1);  // 因為在NDC空間，相機在原點
          viewDir.normalize();
          
          // 計算法向量和視線向量的點積
          float dotProduct = Vector3.dot(normal, viewDir);
          
          // 如果點積小於0，表示這個面朝向相機，才進行繪製
          if (dotProduct < 0) {
              // 將NDC座標轉換為螢幕座標
              for (int j = 0; j < img_pos.length; j++) {
                  img_pos[j] = new Vector3(
                      map(img_pos[j].x(), -1, 1, renderer_size.x, renderer_size.z),
                      map(img_pos[j].y(), -1, 1, renderer_size.y, renderer_size.w),
                      img_pos[j].z()
                  );
              }
              
              // 繪製三角形邊緣
              CGLine(img_pos[0].x(), img_pos[0].y(), img_pos[1].x(), img_pos[1].y());
              CGLine(img_pos[1].x(), img_pos[1].y(), img_pos[2].x(), img_pos[2].y());
              CGLine(img_pos[2].x(), img_pos[2].y(), img_pos[0].x(), img_pos[0].y());
          }
      }
  }

    String getGameObjectName() {
        return name;
    }

    Matrix4 localToWorld() {
        // TODO HW3
        // You need to calculate the model Matrix here.

       // ----- Scale -----
      Matrix4 S = new Matrix4();
      S.makeScale(transform.scale);
  
      // ----- Rotation (Z * Y * X 順序) -----
      Matrix4 Rx = new Matrix4();
      Rx.makeRotX(transform.rotation.x);
  
      Matrix4 Ry = new Matrix4();
      Ry.makeRotY(transform.rotation.y);
  
      Matrix4 Rz = new Matrix4();
      Rz.makeRotZ(transform.rotation.z);
  
      Matrix4 R = Rz.mult(Ry).mult(Rx);
  
      // ----- Translation -----
      Matrix4 T = new Matrix4();
      T.makeTrans(transform.position);
  
      // ----- Model Matrix (localToWorld) -----
      // M = T * R * S
      Matrix4 M = T.mult(R).mult(S);
  
      return M;

    }

    Matrix4 worldToLocal() {
        return Matrix4.Scale(transform.scale.inv()).mult(Matrix4.RotZ(-transform.rotation.z))
                .mult(Matrix4.RotX(-transform.rotation.x)).mult(Matrix4.RotY(-transform.rotation.y))
                .mult(Matrix4.Trans(transform.position.mult(-1)));
    }

    Vector3 forward() {
        return (Matrix4.RotZ(transform.rotation.z).mult(Matrix4.RotX(transform.rotation.y))
                .mult(Matrix4.RotY(transform.rotation.x)).zAxis()).mult(-1);
    }
}
