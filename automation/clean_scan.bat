:: Filename is the first argument provided to the script
set filename=%1
"C:\Program Files\VCG\MeshLab\meshlabserver" -i %filename% -o %filename%.stl -s C:\ScanBooth\automation\clean_scan.mlx -om vn
move %filename%.stl C:\ScanBooth\scans\cleaned\
