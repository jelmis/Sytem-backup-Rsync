 #!/bin/bash
rm image.img
mksquashfs `pwd`/backups image.img -comp zstd -Xcompression-level 9
 
