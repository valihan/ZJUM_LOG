class ZCL_JUM_LOG definition
  public
  create private .

public section.

  interfaces ZIF_JUM_LOG .

  methods CONSTRUCTOR
    importing
      !IV_OBJECT type BALOBJ_D
      !IV_SUBOBJECT type BALSUBOBJ
      !IV_EXTNUMBER type BALNREXT optional
      !IS_OPTIONS type ZIF_JUM_LOG=>TS_OPTIONS optional
    raising
      ZCX_JUM_LOG .
  class-methods GET_INSTANCE
    importing
      !IV_OBJECT type BALOBJ_D
      !IV_SUBOBJECT type BALSUBOBJ
      !IV_EXTNUMBER type BALNREXT optional
      !IS_OPTIONS type ZIF_JUM_LOG=>TS_OPTIONS optional
    returning
      value(RO_INSTANCE) type ref to ZIF_JUM_LOG .
protected section.
PRIVATE SECTION.

  TYPES: BEGIN OF ts_instance,
           object    TYPE balobj_d,
           subobject TYPE balsubobj,
           extnumber TYPE balnrext,
           instance  TYPE REF TO zif_jum_log,
         END OF ts_instance.
  CLASS-DATA st_instance TYPE HASHED TABLE OF ts_instance WITH UNIQUE KEY object subobject extnumber.

  DATA: mv_object     TYPE balobj_d,
        mv_subobject  TYPE balsubobj,
        mv_extnumber  TYPE balnrext,
        ms_options    TYPE zif_jum_log=>ts_options,
        mv_log_handle TYPE balloghndl,
        mv_empty      TYPE boole_d.
ENDCLASS.



CLASS ZCL_JUM_LOG IMPLEMENTATION.


  METHOD constructor.
    mv_object    = iv_object.
    mv_subobject = iv_subobject.
    mv_extnumber = iv_extnumber.
    ms_options   = is_options.
    mv_empty     = abap_true.

    DATA(ls_ballog) = VALUE bal_s_log( extnumber = mv_extnumber
                                       object    = mv_object
                                       subobject = mv_subobject
                                       aldate = sy-datum
                                       altime = sy-uzeit
                                       aluser = sy-uname
*ALTCODE
*ALPROG
*ALMODE
*ALCHDATE
*ALCHTIME
*ALCHUSER
*ALDATE_DEL
*DEL_BEFORE
*ALSTATE
*CONTEXT
*PARAMS
    ).

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = ls_ballog
      IMPORTING
        e_log_handle            = mv_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_jum_log.
    ENDIF.

  ENDMETHOD.


  METHOD get_instance.
    ASSIGN st_instance[ object    = iv_object
                        subobject = iv_subobject
                        extnumber = iv_extnumber ] TO FIELD-SYMBOL(<ls_instance>).
    IF sy-subrc <> 0.
      TRY.
          INSERT VALUE #( object    = iv_object
                          subobject = iv_subobject
                          extnumber = iv_extnumber
                          instance  = NEW zcl_jum_log( iv_object    = iv_object
                                                       iv_subobject = iv_subobject
                                                       iv_extnumber = iv_extnumber
                                                       is_options   = is_options ) ) INTO TABLE st_instance ASSIGNING <ls_instance>.
        CATCH zcx_jum_log INTO DATA(lx_log).
          RETURN.
      ENDTRY.
    ENDIF.
    ro_instance = <ls_instance>-instance.
  ENDMETHOD.


  METHOD zif_jum_log~add_bapiret2.
    " Добавление сообщения в журнал приложения
    zif_jum_log~add_message( is_message = VALUE #( msgty  = COND #( WHEN iv_type IS SUPPLIED THEN iv_type ELSE is_bapiret2-type )
                                                   msgid  = is_bapiret2-id
                                                   msgno  = is_bapiret2-number
                                                   msgv1  = is_bapiret2-message_v1
                                                   msgv2  = is_bapiret2-message_v2
                                                   msgv3  = is_bapiret2-message_v3
                                                   msgv4  = is_bapiret2-message_v4 )
                              iv_type      = iv_type
                              iv_probclass = iv_probclass ).
*MSGV1_SRC  Types BALMSGVSRC
*MSGV2_SRC  Types BALMSGVSRC
*MSGV3_SRC  Types BALMSGVSRC
*MSGV4_SRC  Types BALMSGVSRC
*DETLEVEL	Types	BALLEVEL
*PROBCLASS  Types BALPROBCL
*ALSORT	Types	BALSORT
*TIME_STMP  Types BALTIMSTMP
*MSG_COUNT  Types BALCNTCUM
*CONTEXT  Types BAL_S_CONT
*PARAMS	Types	BAL_S_PARM

*LOG_NO	Types	BALOGNR
*LOG_MSG_NO	Types	BALMNR
*PARAMETER  Types BAPI_PARAM
*ROW  Types BAPI_LINE
*FIELD  Types BAPI_FLD
*SYSTEM	Types	BAPILOGSYS
  ENDMETHOD.


  METHOD zif_jum_log~add_bapirettab.
    LOOP AT it_bapirettab ASSIGNING FIELD-SYMBOL(<ls_bapiret2>).
      zif_jum_log~add_bapiret2( is_bapiret2   = <ls_bapiret2>
                                iv_type       = COND #( WHEN iv_type IS SUPPLIED THEN iv_type ELSE <ls_bapiret2>-type )
                                iv_probclass  = iv_probclass ).
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_jum_log~add_exception.

    IF ix_exception IS BOUND.
      DATA: lt_bapiret2 TYPE bapirettab.
      CALL FUNCTION 'RS_EXCEPTION_TO_BAPIRET2'
        EXPORTING
          i_r_exception = ix_exception
        CHANGING
          c_t_bapiret2  = lt_bapiret2.

      IF iv_type IS SUPPLIED.
        zif_jum_log~add_bapirettab( it_bapirettab = lt_bapiret2
                                    iv_type       = iv_type
                                    iv_probclass  = iv_probclass ).
      ELSE.
        zif_jum_log~add_bapirettab( it_bapirettab = lt_bapiret2
                                    iv_probclass  = iv_probclass ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_jum_log~add_message.
    " Добавление системного сообщения в журнал приложения

    DATA(ls_msg) = CORRESPONDING bal_s_msg( is_message ).
    GET TIME STAMP FIELD ls_msg-time_stmp.
    ls_msg-probclass = iv_probclass.

    IF iv_type IS SUPPLIED.
      ls_msg-msgty = iv_type.
    ENDIF.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = mv_log_handle
        i_s_msg          = ls_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      rv_subrc = sy-subrc.
    ELSE.
      mv_empty = abap_false.
      IF ms_options-auto_save = abap_true.
        zif_jum_log~save( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_jum_log~add_sys.
    " Добавление системного сообщения в журнал приложения

    zif_jum_log~add_message( is_message = CORRESPONDING #( sy )
                             iv_probclass  = iv_probclass ).
  ENDMETHOD.


  METHOD zif_jum_log~is_empty.
    rv_empty = mv_empty.
  ENDMETHOD.


  METHOD zif_jum_log~save.
    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = VALUE bal_t_logh( ( mv_log_handle ) )
        i_save_all       = abap_true
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 0.
    rv_subrc = sy-subrc.
  ENDMETHOD.


  METHOD zif_jum_log~show.
    DATA: ls_profile    TYPE bal_s_prof.
    CHECK mv_empty = abap_false.
    IF is_profile IS SUPPLIED.
      ls_profile = is_profile.
    ELSE.
      CALL FUNCTION 'BAL_DSP_PROFILE_STANDARD_GET'
        IMPORTING
          e_s_display_profile = ls_profile
        EXCEPTIONS
          OTHERS              = 0.
    ENDIF.

    DATA(lt_log_handle) = VALUE bal_t_logh( ( mv_log_handle ) ).
    CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
      EXPORTING
        i_t_log_handle      = lt_log_handle
        i_s_display_profile = ls_profile
        i_amodal            = abap_false
      EXCEPTIONS
        OTHERS              = 0.
  ENDMETHOD.
ENDCLASS.
