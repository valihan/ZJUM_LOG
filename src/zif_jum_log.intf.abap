INTERFACE zif_jum_log
  PUBLIC .


  TYPES: BEGIN OF ts_message,
           msgv1 TYPE syst_msgv,
           msgv2 TYPE syst_msgv,
           msgv3 TYPE syst_msgv,
           msgv4 TYPE syst_msgv,
         END OF ts_message.
  TYPES:
    BEGIN OF ts_options,
      auto_save TYPE boole_d,
      reopen    TYPE boole_d,
    END OF ts_options .

  METHODS save
    RETURNING
      VALUE(rv_subrc) TYPE syst_subrc .
  METHODS add_message
    IMPORTING
      !is_message     TYPE bal_s_msg
      !iv_type        TYPE symsgty DEFAULT zif_jum_log_const=>gc_s_mtype-info
      !iv_probclass   TYPE balprobcl DEFAULT zif_jum_log_const=>gc_s_probclass-medium
    RETURNING
      VALUE(rv_subrc) TYPE syst_subrc .
  METHODS add_bapiret2
    IMPORTING
      !is_bapiret2    TYPE bapiret2
      !iv_type        TYPE symsgty DEFAULT zif_jum_log_const=>gc_s_mtype-info
      !iv_probclass   TYPE balprobcl DEFAULT zif_jum_log_const=>gc_s_probclass-medium
    RETURNING
      VALUE(rv_subrc) TYPE syst_subrc .
  METHODS add_exception
    IMPORTING
      !ix_exception   TYPE REF TO cx_root
      !iv_type        TYPE symsgty DEFAULT zif_jum_log_const=>gc_s_mtype-error
      !iv_probclass   TYPE balprobcl DEFAULT zif_jum_log_const=>gc_s_probclass-medium
    RETURNING
      VALUE(rv_subrc) TYPE syst_subrc .
  METHODS add_sys
    IMPORTING
      !iv_type        TYPE symsgty DEFAULT zif_jum_log_const=>gc_s_mtype-info
      !iv_probclass   TYPE balprobcl DEFAULT zif_jum_log_const=>gc_s_probclass-medium
    RETURNING
      VALUE(rv_subrc) TYPE syst_subrc .
  METHODS add_bapirettab
    IMPORTING
      !it_bapirettab  TYPE bapirettab
      !iv_type        TYPE symsgty DEFAULT zif_jum_log_const=>gc_s_mtype-info
      !iv_probclass   TYPE balprobcl DEFAULT zif_jum_log_const=>gc_s_probclass-medium
    RETURNING
      VALUE(rv_subrc) TYPE syst_subrc .
  METHODS add_bopf
    IMPORTING
      !io_message     TYPE REF TO /bobf/if_frw_message
      !iv_type        TYPE symsgty DEFAULT zif_jum_log_const=>gc_s_mtype-info
      !iv_probclass   TYPE balprobcl DEFAULT zif_jum_log_const=>gc_s_probclass-medium
    RETURNING
      VALUE(rv_subrc) TYPE syst_subrc .
  METHODS show
    IMPORTING
      !is_profile TYPE bal_s_prof OPTIONAL .
  METHODS is_empty
    RETURNING
      VALUE(rv_empty) TYPE boole_d .
  METHODS has_error
    RETURNING
      VALUE(rv_has_error) TYPE boole_d .
ENDINTERFACE.
