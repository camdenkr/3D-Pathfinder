import numpy as np
import open3d as o3d

def main():
    print("Load a ply point cloud, print it, and render it")
    pcd = o3d.io.read_point_cloud("../data/point_cloud.ply")
    o3d.visualization.draw_geometries([pcd],
                                    zoom=0.3412,
                                    front=[0.4257, -0.2125, -0.8795],
                                    lookat=[2.6172, 2.0475, 1.532],
                                    up=[-0.0694, -0.9768, 0.2024])

if __name__ == "__main__":
    main()