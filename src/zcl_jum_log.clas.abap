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
      !IV_SUBOBJECT type BALSUBOBJ default ZIF_JUM_LOG_CONST=>GC_S_LOG-NONE
      !IV_EXTNUMBER type BALNREXT optional
      !IS_OPTIONS type ZIF_JUM_LOG=>TS_OPTIONS optional
    returning
      value(RO_INSTANCE) type ref to ZIF_JUM_LOG .
  class-methods MSG_CONVERT_BOPF_2_BAPIRET2
    importing
      !IV_SEVERITY type /BOBF/CM_FRW=>TY_MESSAGE_SEVERITY optional
      !IV_CONSISTENCY_MESSAGES type BOOLE_D default ABAP_TRUE
      !IV_ACTION_MESSAGES type BOOLE_D default ABAP_TRUE
      !IO_MESSAGE type ref to /BOBF/IF_FRW_MESSAGE optional
      !IT_MESSAGE type /BOBF/T_FRW_MESSAGE_K optional
    changing
      !CT_BAPIRET2 type BAPIRET2_TAB .
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

    IF is_options-reopen = abap_true.
      DATA: ls_filter  TYPE bal_s_lfil,
            lt_headers TYPE balhdr_t.
      CALL FUNCTION 'BAL_FILTER_CREATE'
        EXPORTING
          i_object       = iv_object
          i_subobject    = iv_subobject
          i_extnumber    = iv_extnumber
          i_aluser       = sy-uname
        IMPORTING
          e_s_log_filter = ls_filter.

      CALL FUNCTION 'BAL_DB_SEARCH'
        EXPORTING
          i_s_log_filter = ls_filter
        IMPORTING
          e_t_log_header = lt_headers
        EXCEPTIONS
          OTHERS         = 1.

      IF sy-subrc = 0.
        DATA(lv_lines) = lines( lt_headers ) - 1.
        IF lv_lines > 0.
          DELETE lt_headers TO lv_lines.
        ENDIF.

        CALL FUNCTION 'BAL_DB_LOAD'
          EXPORTING
            i_t_log_header = lt_headers
          EXCEPTIONS
            OTHERS         = 1.
        IF sy-subrc = 0.
          mv_log_handle = lt_headers[ 1 ]-log_handle.
        ENDIF.
      ENDIF.
    ENDIF.

    IF mv_log_handle IS INITIAL.
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


  METHOD msg_convert_bopf_2_bapiret2.
    " Копия     /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2

    DATA:
      lt_msg      TYPE /bobf/t_frw_message_k,
      ls_t100key  TYPE scx_t100key,
      lo_cm_frw   TYPE REF TO /bobf/cm_frw,
      lv_field    TYPE fieldname,
      ls_bapiret2 TYPE bapiret2.
    FIELD-SYMBOLS:
      <ls_msg>    TYPE /bobf/s_frw_message_k,
      <attr1>     TYPE scx_attrname,
      <attr2>     TYPE scx_attrname,
      <attr3>     TYPE scx_attrname,
      <attr4>     TYPE scx_attrname,
      <attr1_val> TYPE any,
      <attr2_val> TYPE any,
      <attr3_val> TYPE any,
      <attr4_val> TYPE any.

* Anything to do?
    CHECK io_message IS BOUND OR
          it_message IS NOT INITIAL.

* Mapping
    IF io_message IS BOUND.
      io_message->get_messages( EXPORTING iv_severity             = iv_severity
                                          iv_consistency_messages = iv_consistency_messages
                                          iv_action_messages      = iv_action_messages
                                IMPORTING et_message              = lt_msg                ).
    ENDIF.
    APPEND LINES OF it_message TO lt_msg.

    LOOP AT lt_msg ASSIGNING <ls_msg>.
      CLEAR ls_bapiret2.
      UNASSIGN: <attr1_val>,
                <attr2_val>,
                <attr3_val>,
                <attr4_val>.
*   Take over message variable values
      TRY.
          lo_cm_frw ?= <ls_msg>-message.
          ls_t100key = lo_cm_frw->if_t100_message~t100key.
*       Standard CM Class
          ASSIGN lo_cm_frw->('IF_T100_MESSAGE~T100KEY-ATTR1') TO <attr1>.
          IF <attr1> IS ASSIGNED.
            ASSIGN lo_cm_frw->(<attr1>) TO <attr1_val>.
            IF sy-subrc IS NOT INITIAL.
              ASSIGN <attr1> TO <attr1_val>.
            ENDIF.
          ENDIF.
          IF <attr1_val> IS ASSIGNED.
            ls_bapiret2-message_v1 = <attr1_val>.
          ENDIF.
          ASSIGN lo_cm_frw->('IF_T100_MESSAGE~T100KEY-ATTR2') TO <attr2>.
          IF <attr2> IS ASSIGNED.
            ASSIGN lo_cm_frw->(<attr2>) TO <attr2_val>.
            IF sy-subrc IS NOT INITIAL.
              ASSIGN <attr2> TO <attr2_val>.
            ENDIF.
          ENDIF.
          IF <attr2_val> IS ASSIGNED.
            ls_bapiret2-message_v2 = <attr2_val>.
          ENDIF.
          ASSIGN lo_cm_frw->('IF_T100_MESSAGE~T100KEY-ATTR3') TO <attr3>.
          IF <attr3> IS ASSIGNED.
            ASSIGN lo_cm_frw->(<attr3>) TO <attr3_val>.
            IF sy-subrc IS NOT INITIAL.
              ASSIGN <attr3> TO <attr3_val>.
            ENDIF.
          ENDIF.
          IF <attr3_val> IS ASSIGNED.
            ls_bapiret2-message_v3 = <attr3_val>.
          ENDIF.
          ASSIGN lo_cm_frw->('IF_T100_MESSAGE~T100KEY-ATTR4') TO <attr4>.
          IF <attr4> IS ASSIGNED.
            ASSIGN lo_cm_frw->(<attr4>) TO <attr4_val>.
            IF sy-subrc IS NOT INITIAL.
              ASSIGN <attr4> TO <attr4_val>.
            ENDIF.
          ENDIF.
          IF <attr4_val> IS ASSIGNED.
            ls_bapiret2-message_v4 = <attr4_val>.
          ENDIF.
        CATCH cx_sy_move_cast_error.
          ls_t100key = <ls_msg>-message->if_t100_message~t100key.
          ls_bapiret2-message_v1 = ls_t100key-attr1.
          ls_bapiret2-message_v2 = ls_t100key-attr2.
          ls_bapiret2-message_v3 = ls_t100key-attr3.
          ls_bapiret2-message_v4 = ls_t100key-attr4.
      ENDTRY.
*   Take over message body
      ls_bapiret2-type    = <ls_msg>-severity.
      ls_bapiret2-id      = ls_t100key-msgid.
      ls_bapiret2-number  = ls_t100key-msgno.
      ls_bapiret2-message = <ls_msg>-message->if_message~get_text( ).
      CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
        IMPORTING
          own_logical_system             = ls_bapiret2-system
        EXCEPTIONS
          own_logical_system_not_defined = 0
          OTHERS                         = 0.
      READ TABLE <ls_msg>-message->ms_origin_location-attributes
        INTO lv_field
        INDEX 1.
      IF sy-subrc EQ 0.
        ls_bapiret2-field = lv_field.
      ELSE.
        CLEAR ls_bapiret2-field.
      ENDIF.
*   Collect message
      APPEND ls_bapiret2 TO ct_bapiret2.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_jum_log~add_bapiret2.
    " Добавление сообщения в журнал приложения
    zif_jum_log~add_message( is_message = VALUE #( msgty  = COND #( WHEN iv_type IS NOT INITIAL THEN iv_type ELSE is_bapiret2-type )
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


  METHOD zif_jum_log~add_bopf.
    DATA: lt_bapiret TYPE bapiret2_tab.

    msg_convert_bopf_2_bapiret2( EXPORTING io_message  = io_message
                                           iv_severity = iv_type
                                 CHANGING ct_bapiret2 = lt_bapiret ).

    zif_jum_log~add_bapirettab( iv_type       = iv_type
                                iv_probclass  = iv_probclass
                                it_bapirettab = lt_bapiret   ).
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

    IF iv_type IS NOT INITIAL.
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


  METHOD zif_jum_log~has_error.
    DATA: ls_filter     TYPE bal_s_mfil,
          lt_log_handle TYPE bal_t_logh.

    ls_filter-msgty = VALUE #( ( sign   = zif_jum_log_const=>gc_s_sign-inclusive
                                 option = zif_jum_log_const=>gc_s_option-eq
                                 low    = zif_jum_log_const=>gc_s_mtype-err ) ).
    lt_log_handle = VALUE #( ( mv_log_handle ) ).

    CALL FUNCTION 'BAL_GLB_SEARCH_MSG'
      EXPORTING
        i_t_log_handle = lt_log_handle
        i_s_msg_filter = ls_filter
*      IMPORTING
*       e_t_msg_handle = rt_message_handles
      EXCEPTIONS
        msg_not_found  = 0.
    rv_has_error = COND #( WHEN sy-subrc = 0 THEN abap_false ELSE abap_true ).
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
