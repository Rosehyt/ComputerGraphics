public class PhongVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }

        Vector4[][] result = { gl_Position, w_position, w_normal };

        return result;
    }
}

public class PhongFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 position = (Vector3) varying[0];
        Vector3 w_position = (Vector3) varying[1];
        Vector3 w_normal = (Vector3) varying[2];
        Vector3 albedo = (Vector3) varying[3];
        Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        Camera cam = main_camera;

        // TODO HW4
        // In this section, we have passed in all the variables you need.
        // Please use these variables to calculate the result of Phong shading
        // for that point and return it to GameObject for rendering
        // Light properties
        // 材質屬性
        float Kd = kdksm.x; // 漫反射係數
        float Ks = kdksm.y; // 鏡面反射係數
        float m = kdksm.z;  // 光滑度
        Vector3 Ka = new Vector3(0.3, 0.3, 0.3); // 環境光係數（硬編碼，可通過參數傳入）

        // 光源屬性
        Vector3 light_color = light.light_color; // 光的顏色
        Vector3 light_position = light.transform.position; // 光源位置
        float light_intensity = light.intensity; // 光強度

        // 相機屬性
        Vector3 view_position = cam.transform.position; // 相機位置

        // **1. 計算環境光分量 (Ambient)**
        Vector3 ambient = Ka.product(light_color); // Ka * 光的顏色

        // **2. 計算漫反射分量 (Diffuse)**
        Vector3 light_dir = (light_position.sub(w_position)).unit_vector(); // 光方向
        float diff = Math.max(Vector3.dot(w_normal,light_dir), 0.0f); // 計算光線與法線的夾角
        Vector3 diffuse = Vector3.mult(Kd * diff * light_intensity, light_color).product(albedo); // Kd * 漫反射

        // **3. 計算鏡面反射分量 (Specular)**
        Vector3 view_dir = (view_position.sub(w_position)).unit_vector(); // 視角方向
        float dotProduct = Vector3.dot(light_dir,w_normal); // V · N
        Vector3 scaledNormal = w_normal.mult(2 * dotProduct); // 2 * (V · N) * N
        Vector3 reflect_dir = light_dir.sub(scaledNormal); // R = V - 2 * (V · N) * N
        float spec = (float) Math.pow(Math.max(Vector3.dot(view_dir,reflect_dir), 0.0f), m); // 鏡面反射公式
        Vector3 specular = Vector3.mult(Ks * spec * light_intensity, light_color); // Ks * 鏡面光

        // **4. 合併所有分量**
        Vector3 final_color = ambient.add(diffuse).add(specular);

        // 限制顏色範圍在 [0, 1]
        final_color.x = Math.min(final_color.x, 1.0f);
        final_color.y = Math.min(final_color.y, 1.0f);
        final_color.z = Math.min(final_color.z, 1.0f);

        // 返回最終顏色，帶上透明度 1.0
        return new Vector4(final_color.x, final_color.y, final_color.z, 1.0);
    }
}

public class FlatVertexShader extends VertexShader {
   Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        
        Vector3 T1 = aVertexPosition[0].sub(aVertexPosition[1]);
        Vector3 T2 = aVertexPosition[0].sub(aVertexPosition[2]);
        Vector3 N = Vector3.cross(T1,T2);

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(N.getVector4(0.0));
        }

        Vector4[][] result = {gl_Position, w_position, w_normal};
        return result;
    }
}


public class FlatFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 position = (Vector3)varying[0];
        Vector3 w_position = (Vector3)varying[1];
        Vector3 w_normal = (Vector3)varying[2];
        Vector3 albedo = (Vector3) varying[3];
        Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        Camera cam = main_camera;

        Vector3 lightDir = (light.transform.position.sub(w_position)).unit_vector();
        Vector3 viewDir = (cam.transform.position.sub(w_position)).unit_vector();
        Vector3 normal = w_normal.unit_vector();

        Vector3 ambient = AMBIENT_LIGHT.product(basic_light.light_color);
        Vector3 diffuse = basic_light.light_color.mult(kdksm.x).mult(Math.max(Vector3.dot(normal, lightDir), 0.0));

        Vector3 reflectDir = (normal.mult(2.0 * Vector3.dot(lightDir, normal))).sub(lightDir);
        float specFactor = (float) Math.pow(Math.max(Vector3.dot(viewDir, reflectDir), 0.0), kdksm.z);
        Vector3 specular = basic_light.light_color.mult(kdksm.y * specFactor);

        Vector3 finalColor = new Vector3(
            ambient.x * albedo.x + diffuse.x * albedo.x + specular.x * albedo.x,
            ambient.y * albedo.y + diffuse.y * albedo.y + specular.y * albedo.y,
            ambient.z * albedo.z + diffuse.z * albedo.z + specular.z * albedo.z
        );

        return new Vector4(finalColor.x, finalColor.y, finalColor.z, 1.0);
    }
}

public class GouraudVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Vector3 albedo = (Vector3) attribute[2];
        Vector3 kdksm = (Vector3) attribute[3];
        Light light = basic_light;
        Camera cam = main_camera;
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        Vector4[] pointColor = new Vector4[3];
        
        
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }

        Vector3 ambient = AMBIENT_LIGHT.product(basic_light.light_color);

        for(int i=0;i<gl_Position.length;i++){
          
            Vector3 lightDir = (light.transform.position.sub(w_position[i].xyz())).unit_vector();
            Vector3 viewDir = (cam.transform.position.sub(w_position[i].xyz())).unit_vector();
            Vector3 normal = w_normal[i].xyz().unit_vector(); 
            Vector3 diffuse = basic_light.light_color.mult(kdksm.x).mult(Math.max(Vector3.dot(normal, lightDir), 0.0));

            Vector3 reflectDir = (normal.mult(2.0 * Vector3.dot(lightDir, normal))).sub(lightDir);
            float specFactor = (float) Math.pow(Math.max(Vector3.dot(viewDir, reflectDir), 0.0), kdksm.z);
            Vector3 specular = basic_light.light_color.mult(kdksm.y).mult(specFactor);
    
            Vector3 finalColor = new Vector3(
                ambient.x * albedo.x + diffuse.x * albedo.x + specular.x * albedo.x,
                ambient.y * albedo.y + diffuse.y * albedo.y + specular.y * albedo.y,
                ambient.z * albedo.z + diffuse.z * albedo.z + specular.z * albedo.z
            );

            pointColor[i] = finalColor.getVector4(1.0);
        }
        return new Vector4[][]{gl_Position,pointColor};
    }
}

public class GouraudFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 position = (Vector3) varying[0];
        Vector3 pointColor = (Vector3)varying[1];
        int norm = -50;

        // TODO HW4
        // Here you have to complete Gouraud shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note : In the fragment shader, the first 'varying' variable must be its
        // screen position.
        // Subsequent variables will be received in order from the vertex shader.
        // Additional variables needed will be passed by the material later.

        return new Vector4(pointColor.mult(norm),1.0);
    }
}
