interface ZIF_JUM_LOG
  public .


  types:
    BEGIN OF ts_options,
           auto_save TYPE boole_d,
         END OF ts_options .

  methods SAVE
    returning
      value(RV_SUBRC) type SYST_SUBRC .
  methods ADD_MESSAGE
    importing
      !IS_MESSAGE type BAL_S_MSG
      !IV_TYPE type SYMSGTY default 'I'
      !IV_PROBCLASS type BALPROBCL default ZIF_JUM_LOG_CONST=>GC_S_PROBCLASS-MEDIUM
    returning
      value(RV_SUBRC) type SYST_SUBRC .
  methods ADD_BAPIRET2
    importing
      !IS_BAPIRET2 type BAPIRET2
      !IV_TYPE type SYMSGTY default 'I'
      !IV_PROBCLASS type BALPROBCL default ZIF_JUM_LOG_CONST=>GC_S_PROBCLASS-MEDIUM
    returning
      value(RV_SUBRC) type SYST_SUBRC .
  methods ADD_EXCEPTION
    importing
      !IX_EXCEPTION type ref to CX_ROOT
      !IV_TYPE type SYMSGTY default 'E'
      !IV_PROBCLASS type BALPROBCL default ZIF_JUM_LOG_CONST=>GC_S_PROBCLASS-MEDIUM
    returning
      value(RV_SUBRC) type SYST_SUBRC .
  methods ADD_SYS
    importing
      !IV_TYPE type SYMSGTY default 'I'
      !IV_PROBCLASS type BALPROBCL default ZIF_JUM_LOG_CONST=>GC_S_PROBCLASS-MEDIUM
    returning
      value(RV_SUBRC) type SYST_SUBRC .
  methods ADD_BAPIRETTAB
    importing
      !IT_BAPIRETTAB type BAPIRETTAB
      !IV_TYPE type SYMSGTY default 'I'
      !IV_PROBCLASS type BALPROBCL default ZIF_JUM_LOG_CONST=>GC_S_PROBCLASS-MEDIUM
    returning
      value(RV_SUBRC) type SYST_SUBRC .
  methods SHOW
    importing
      !IS_PROFILE type BAL_S_PROF optional .
  methods IS_EMPTY
    returning
      value(RV_EMPTY) type BOOLE_D .
endinterface.
