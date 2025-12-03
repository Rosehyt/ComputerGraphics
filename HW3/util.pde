public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2
    // You need to check the coordinate p(x,v) if inside the vertexes.
    // If yes return true, vice versa.
    int n = vertexes.length;
      boolean inside = false;
      for (int i = 0, j = n - 1; i < n; j = i++) {
          if (((vertexes[i].y > y) != (vertexes[j].y > y)) &&
              (x < (vertexes[j].x - vertexes[i].x) * (y - vertexes[i].y) / (vertexes[j].y - vertexes[i].y) + vertexes[i].x)) {
              inside = !inside;
          }
      }
    return inside;
}

public Vector3[] findBoundBox(Vector3[] v) {    
    // TODO HW2
    // You need to find the bounding box of the vertexes v.
// 初始化最小和最大值，用於找到包圍盒的邊界
    float minX = Float.MAX_VALUE, minY = Float.MAX_VALUE, minZ = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE, maxY = Float.MIN_VALUE, maxZ = Float.MIN_VALUE;
    
    // 遍歷每個頂點，更新最小和最大值
    for (Vector3 vert : v) {
        minX = Math.min(minX, vert.x);
        minY = Math.min(minY, vert.y);
        minZ = Math.min(minZ, vert.z);
        maxX = Math.max(maxX, vert.x);
        maxY = Math.max(maxY, vert.y);
        maxZ = Math.max(maxZ, vert.z);
    }

    // 用計算的邊界值創建包圍盒的兩個對角頂點
    Vector3 recordminV = new Vector3(minX, minY, minZ);
    Vector3 recordmaxV = new Vector3(maxX, maxY, maxZ);
    
    // 返回包圍盒頂點數組
    Vector3[] result = { recordminV, recordmaxV };
    return result;
}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }

    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertexes of the "boundary".
    // The output is the vertexes of the polygon.
// Iterate over each edge of the clipping polygon (boundary)
    for (int i = 0; i < boundary.length; i++) {
        Vector3 A = boundary[i];
        Vector3 B = boundary[(i + 1) % boundary.length];

        // Initialize output list for this clipping edge
        output = new ArrayList<Vector3>();

        if (input.isEmpty()) {
            // No vertices to clip
            break;
        }

        // Start with the last point in the input list
        Vector3 S = input.get(input.size() - 1);

        for (int j = 0; j < input.size(); j++) {
            Vector3 E = input.get(j);

            if (isInside(E, A, B)) {
                if (!isInside(S, A, B)) {
                    // Compute and add intersection point
                    Vector3 intersection = computeIntersection(S, E, A, B);
                    output.add(intersection);
                }
                // Add the endpoint
                output.add(E);
            } else if (isInside(S, A, B)) {
                // Compute and add intersection point
                Vector3 intersection = computeIntersection(S, E, A, B);
                output.add(intersection);
            }
            // Update S to be the current point E
            S = E;
        }

        // Prepare for the next clipping edge
        input = output;
    }

    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    return result;
}


// Helper method to determine if a point is inside the clipping edge
public boolean isInside(Vector3 P, Vector3 A, Vector3 B) {
    // Edge vector
    float edgeX = B.x - A.x;
    float edgeY = B.y - A.y;
    // Vector from A to point P
    float vectorX = P.x - A.x;
    float vectorY = P.y - A.y;
    // Cross product
    float cross = edgeX * vectorY - edgeY * vectorX;
    // Point is inside if cross product is >= 0 (assuming counter-clockwise order)
    return cross <= 0;
}

// Helper method to compute the intersection point between two lines
public Vector3 computeIntersection(Vector3 S, Vector3 E, Vector3 A, Vector3 B) {
    // Line segment from S to E
    float x1 = S.x, y1 = S.y;
    float x2 = E.x, y2 = E.y;
    // Clipping edge from A to B
    float x3 = A.x, y3 = A.y;
    float x4 = B.x, y4 = B.y;

    // Calculate the denominators
    float denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    if (denom == 0) {
        // Lines are parallel; return endpoint
        return new Vector3(E.x, E.y, E.z);
    }

    // Calculate intersection point
    float px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / denom;
    float py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / denom;

    // Assuming z-coordinate remains the same (or you can set it as needed)
    return new Vector3(px, py, 0);
}

public float getDepth(float x, float y, Vector3[] vertex) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;

    Vector3 v0 = vertex[0];
    Vector3 v1 = vertex[1];
    Vector3 v2 = vertex[2];

    // --- 重心座標分母 ---
    float denom = (v1.y - v2.y) * (v0.x - v2.x) +
                  (v2.x - v1.x) * (v0.y - v2.y);

    if (denom == 0) 
        return Float.POSITIVE_INFINITY; // 退化三角形

    // --- 重心座標 w1, w2 ---
    float w1 = ((v1.y - v2.y) * (x - v2.x) +
                (v2.x - v1.x) * (y - v2.y)) / denom;

    float w2 = ((v2.y - v0.y) * (x - v2.x) +
                (v0.x - v2.x) * (y - v2.y)) / denom;

    float w3 = 1 - w1 - w2;

    // --- 是否在三角形內 ---
    if (w1 < 0 || w2 < 0 || w3 < 0)
        return Float.POSITIVE_INFINITY;

    // --- 內插 Z 深度 ---
    float depth = w1 * v0.z + w2 * v1.z + w3 * v2.z;

    return depth;
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    // TODO HW4
    // Calculate the barycentric coordinates of point P in the triangle verts using
    // the barycentric coordinate system.

    float[] result = { 0.0, 0.0, 0.0 };

    return result;
}
