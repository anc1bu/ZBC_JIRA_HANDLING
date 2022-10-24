*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBCT_HTTP_CLIENT................................*
DATA:  BEGIN OF STATUS_ZBCT_HTTP_CLIENT              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBCT_HTTP_CLIENT              .
CONTROLS: TCTRL_ZBCT_HTTP_CLIENT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBCT_HTTP_CLIENT              .
TABLES: ZBCT_HTTP_CLIENT               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
