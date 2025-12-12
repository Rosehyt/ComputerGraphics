public abstract class Material {
    Vector3 albedo = new Vector3(0.9, 0.9, 0.9);
    Shader shader;

    Material() {
        // TODO HW4
        // In the Material, pass the relevant attribute variables and uniform variables
        // you need.
        // In the attribute variables, include relevant variables about vertices,
        // and in the uniform, pass other necessary variables.
        // Please note that a Material will be bound to the corresponding Shader.
    }

    abstract Vector4[][] vertexShader(Triangle triangle, Matrix4 M);

    abstract Vector4 fragmentShader(Vector3 position, Vector4[] varing);

    void attachShader(Shader s) {
        shader = s;
    }
}

public class DepthMaterial extends Material {
    DepthMaterial() {
        shader = new Shader(new DepthVertexShader(), new DepthFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector4[][] r = shader.vertex.main(new Object[] { position }, new Object[] { MVP });
        return r;
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {
        return shader.fragment.main(new Object[] { position });
    }
}

public class PhongMaterial extends Material {
    Vector3 Ka = new Vector3(0.3, 0.3, 0.3);
    float Kd = 0.5;
    float Ks = 0.5;
    float m = 20;

    PhongMaterial() {
        shader = new Shader(new PhongVertexShader(), new PhongFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector3[] normal = triangle.normal;
        Vector4[][] r = shader.vertex.main(new Object[] { position, normal }, new Object[] { MVP, M });
        return r;
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {

        return shader.fragment
                .main(new Object[] { position, varing[0].xyz(), varing[1].xyz(), albedo, new Vector3(Kd, Ks, m) });
    }

}

public class FlatMaterial extends Material {
    FlatMaterial() {
        shader = new Shader(new FlatVertexShader(), new FlatFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;

        // TODO HW4
        // pass the uniform you need into the shader.
        Vector3[] normal = triangle.normal;

        // 调用 FlatVertexShader，将顶点和变换矩阵作为参数
        Vector4[][] r = shader.vertex.main(
            new Object[] { position, normal },  // 顶点位置和法向量
            new Object[] { MVP, M }            // MVP 和模型矩阵
        );
        return r;
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {
        // 正确传递数据到 FlatFragmentShader
        return shader.fragment.main(new Object[] {
            position,                // 屏幕空间位置
            varing[0].xyz(),         // 世界空间位置
            varing[1].xyz(),         // 世界空间法向量
            new Vector3(0.8, 0.8, 0.8), // albedo（材质颜色）
            new Vector3(0.5, 0.5, 20)   // kdksm（漫反射、镜面反射、光滑度）
        });
    }
}

public class GouraudMaterial extends Material {
    GouraudMaterial() {
        shader = new Shader(new GouraudVertexShader(), new GouraudFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        
        // TODO HW4
        // pass the uniform you need into the shader.
        Vector3[] normal = triangle.normal;
        Vector3 albedo = new Vector3(0.8, 0.8, 0.8); // 材质颜色
        Vector3 kdksm = new Vector3(0.5, 0.5, 20);   // 漫反射、镜面反射、光滑度

        // 调用顶点着色器，将顶点数据和变换矩阵传递
        Vector4[][] r = shader.vertex.main(
            new Object[] { position, normal, albedo, kdksm },  // 顶点和材质属性
            new Object[] { MVP, M }                            // 变换矩阵
        );
        return r;
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {
        // 直接调用片段着色器，传递插值后的数据
        return shader.fragment.main(new Object[] {
            position,
            varing[0].xyz() // 插值后的颜色
        });
    }
}

public enum MaterialEnum {
    DM, FM, GM, PM;
}
