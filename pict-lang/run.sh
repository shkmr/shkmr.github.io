rm -rf pa pb
mkdir -p pa pb
gosh -l./pict-core.scm parallel.scm
convert -loop 0 pa/*[16].png pa.gif
convert -loop 0 pb/*[16].png pb.gif

gosh -l./pict-core.scm fractal.scm
