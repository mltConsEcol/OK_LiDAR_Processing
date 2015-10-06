#Invoke Lastools
setwd("D:/TestLAS")
test <- system("lasinfo 33096H4_NW_A.las", intern=TRUE)[30]




#install.packages("RSAGA")
setwd("D:/TestLAS")

library(RSAGA)
work_env <- rsaga.env()
work_env
rsaga.get.libraries() #library: io_shapes_las
rsaga.get.modules('io_shapes_las') #module 1 'Import LAS files'


x <- rsaga.geoprocessor(lib="io_shapes_las", module=2, param=list(FILE="33096H4_NW_A.las"))#, HEADER=1), env=work_env)
zed <- rsaga.geoprocessor(lib="io_shapes_las", module=0, param=list(POINTS="33096H4_NW_A.spc", FILE="33096H4_NW_A_2222.las"))

rsaga.module.exists(lib="io_shapes_las", module=1)#, param=list(FILES="33096H4_NW_A.las"), env=work_env)

rsaga.get.usage('io_shapes_las',0)
# library path:   C:\PROGRA~1\SAGA-GIS\modules\
# library name:   io_shapes_las
# library     :   LAS
# Usage: saga_cmd io_shapes_las 1 [-FILES <str>] [-POINTS <str>] [-T <str>] [-i <str>] [-a <str>] [-r <str>] [-c <str>] [-u <str>] [-n <str>] [-R <str>] [-G <str>] [-B <str>] [-e <str>] [-d <str>] [-p <str>] [-C <str>] [-VALID <str>] [-RGB_RANGE <str>]
  # -FILES:<str>          Input Files
        # File path
  # -POINTS:<str>         Point Clouds
        # Point Cloud list (output)
  # -T:<str>              gps-time
        # Boolean
        # Default: 0
  # -i:<str>              intensity
        # Boolean
        # Default: 0
  # -a:<str>              scan angle
        # Boolean
        # Default: 0
  # -r:<str>              number of the return
        # Boolean
        # Default: 0
  # -c:<str>              classification
        # Boolean
        # Default: 0
  # -u:<str>              user data
        # Boolean
        # Default: 0
  # -n:<str>              number of returns of given pulse
        # Boolean
        # Default: 0
  # -R:<str>              red channel color
        # Boolean
        # Default: 0
  # -G:<str>              green channel color
        # Boolean
        # Default: 0
  # -B:<str>              blue channel color
        # Boolean
        # Default: 0
  # -e:<str>              edge of flight line flag
        # Boolean
        # Default: 0
  # -d:<str>              direction of scan flag
        # Boolean
        # Default: 0
  # -p:<str>              point source ID
        # Boolean
        # Default: 0
  # -C:<str>              rgb color
        # Boolean
        # Default: 0
  # -VALID:<str>          Check Point Validity
        # Boolean
        # Default: 0
  # -RGB_RANGE:<str>      R,G,B value range
        # Choice
        # Available Choices:
        # [0] 16 bit
        # [1] 8 bit 
